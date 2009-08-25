#!/usr/bin/env python
"""Tell me who you are!
"""

import pysvn
import json
from debian_bundle import deb822
import apt
from ConfigParser import SafeConfigParser
from optparse import OptionParser, Option, OptionGroup, OptionConflictError
import sys
import os
import shutil
import urllib2
import urllib
import subprocess
# templating
from jinja2 import Environment, PackageLoader

from pprint import PrettyPrinter


class AptListsCache(object):
    def __init__(self, cachedir='build/cache',
                 ro_cachedirs=None,
                 init_db=None):
        self.cachedir = cachedir

        if not ro_cachedirs is None:
            self.ro_cachedirs = ro_cachedirs
        else:
            self.ro_cachedirs = []

        # create cachedir
        create_dir(self.cachedir)

    def get(self, url, update=False):
        """Looks in the cache if the file is there and takes the cached one.
        Otherwise it is downloaded first.

        Knows how to deal with http:// and svn:// URLs.

        :Return:
          file handler
        """
        # look whether it is compressed
        cext = url.split('.')[-1]
        if cext in ['gz', 'bz2']:
            target_url = url[:-1 * len(cext) -1]
        else:
            # assume not compressed
            target_url = url
            cext = None

        # turn url into a filename -- mimik what APT does for
        # /var/lib/apt/lists/
        tfilename = '_'.join(target_url.split('/')[2:])

        # if we need to download anyway do not search
        if update:
            cfilename = os.path.join(self.cachedir, tfilename)
        else:
            # look for the uncompressed file anywhere in the cache
            cfilename = None
            for cp in [self.cachedir] + self.ro_cachedirs:
                if os.path.exists(os.path.join(cp, tfilename)):
                    cfilename = os.path.join(cp, tfilename)

        # nothing found?
        if cfilename is None:
            # add cache item
            cfilename = os.path.join(self.cachedir, tfilename)
            update = True

        # if updated needed -- download
        if update:
            #print 'Caching file from %s' % url

            if url.startswith('svn://'):
                # export from SVN
                pysvn.Client().export(url, cfilename)
            if url.startswith('http://'):
                # download
                tempfile, ignored = urllib.urlretrieve(url)

                # decompress
                decompressor = None
                if cext == 'gz':
                    decompressor = 'gzip'
                elif cext == 'bz2':
                    decompressor = 'bzip2'
                elif cext == None:
                    decompressor = None
                else:
                    raise ValueError, \
                          "Don't know how to decompress %s files" \
                          % cext

                if not decompressor is None:
                    if subprocess.call([decompressor, '-d', '-q', '-f',
                                       tempfile]) == 1:
                        raise RuntimeError, \
                              "Something went wrong while decompressing '%s'" \
                              % tempfile

                # move decompressed file into cache
                shutil.move(os.path.splitext(tempfile)[0], cfilename)

                # XXX do we need that if explicit filename is provided?
                urllib.urlcleanup()

        # open cached file
        fh = open(cfilename, 'r')

        return fh


def add_pkgfromtaskfile(db, urls):
    cache = AptListsCache()
    pkgs = []

    for task in urls:
        fh = cache.get(task)

        # loop over all stanzas
        for stanza in deb822.Packages.iter_paragraphs(fh):
            if stanza.has_key('Depends'):
                pkg = stanza['Depends']
            elif stanza.has_key('Suggests'):
                pkg = stanza['Suggests']
            else:
                continue

            # account for multiple packages per line
            if pkg.count(','):
                pkgs += [p.strip() for p in pkg.split(',')]
            else:
                pkgs.append(pkg.strip())

    for p in pkgs:
        if not db.has_key(p):
            db[p] = get_emptydbentry()

    return db

def get_emptydbentry():
    return {'main': {}}

def import_blendstask(db, url):
    cache = AptListsCache()
    fh = cache.get(url)
    task_name = None

    # figure out blend's task page URL, since they differ from blend to blend
    urlsec = url.split('/')
    blendname = urlsec[-3]
    if blendname == 'debian-med':
        taskpage_url = 'http://debian-med.alioth.debian.org/tasks/'
    elif blendname == 'debian-science':
        taskpage_url = 'http://blends.alioth.debian.org/science/tasks/' 
    else:
        raise ValueError('Unknown blend "%s"' % blendname)
    taskpage_url += urlsec[-1]

    for st in deb822.Packages.iter_paragraphs(fh):
        if st.has_key('Task'):
            task_name = st['Task']
            task = (blendname, task_name, taskpage_url)

        # do not stop unless we have a description
        if not st.has_key('Pkg-Description'):
            continue

        if st.has_key('Depends'):
            pkg = st['Depends']
        elif st.has_key('Suggests'):
            pkg = st['Suggests']
        else:
            print 'Warning: Cannot determine name of prospective package ' \
                    '... ignoring.'
            continue

        if not db.has_key(pkg):
            print 'Ignoring blend package "%s"' % pkg
            continue

        info = {}

        # blends info
        info['tasks'] = [task]
        if st.has_key('License'):
            info['license'] = st['License']
        if st.has_key('Responsible'):
            info['responsible'] = st['Responsible']

        # pkg description
        descr = st['Pkg-Description'].replace('%', '%%').split('\n')
        info['description'] = descr[0].strip()
        info['long_description'] = ' '.join([l.strip() for l in descr[1:]])

        # charge the basic property set
        db[pkg]['main']['description'] = info['description']
        db[pkg]['main']['long_description'] = info['long_description']
        if st.has_key('WNPP'):
            db[pkg]['main']['debian_itp'] = st['WNPP']
        if st.has_key('Pkg-URL'):
            db[pkg]['main']['other_pkg'] = st['Pkg-URL']
        if st.has_key('Homepage'):
            db[pkg]['main']['homepage'] = st['Homepage']

        # only store if there isn't something already
        if not db[pkg].has_key('blends'):
            db[pkg]['blends'] = info
        else:
            # just add this tasks name and id
            db[pkg]['blends']['tasks'].append(task)

    return db


def get_releaseinfo(rurl):
    cache = AptListsCache()
    # root URL of the repository
    baseurl = '/'.join(rurl.split('/')[:-1])
    # get the release file from the cache
    release_file = cache.get(rurl)

    # create parser instance
    rp = deb822.Release(release_file)

    # architectures on this dist
    archs = rp['Architectures'].split()
    components = rp['Components'].split()
    # compile a new codename that also considers the repository label
    # to distinguish between official and unofficial repos.
    label = rp['Label']
    origin = rp['Origin']
    codename = rp['Codename']
    labelcode = '_'.join([rp['Label'], rp['Codename']])

    # cleanup
    release_file.close()

    return {'baseurl': baseurl, 'archs': archs, 'components': components,
            'codename': codename, 'label': label, 'labelcode': labelcode,
            'origin': origin}


def build_pkgsurl(baseurl, component, arch):
    return '/'.join([baseurl, component, 'binary-' + arch, 'Packages.bz2'])


def import_release(cfg, db, rurl):
    cache = AptListsCache()

    ri = get_releaseinfo(rurl)

    # compile the list of Packages files to parse and parse them
    for c in ri['components']:
        for a in ri['archs']:
            # compile packages URL
            pkgsurl = build_pkgsurl(ri['baseurl'], c, a)

            # retrieve from cache
            packages_file = cache.get(pkgsurl)

            # parse
            for stanza in deb822.Packages.iter_paragraphs(packages_file):
                db = _store_pkg(cfg, db, stanza, ri['origin'], ri['codename'], c, ri['baseurl'])

            # cleanup
            packages_file.close()

    return db

def _store_pkg(cfg, db, st, origin, codename, component, baseurl):
    """
    :Parameter:
      st: Package section
    """
    pkg = st['Package']

    # only care for known packages
    if not db.has_key(pkg):
#        print 'Ignoring NeuroDebian package "%s"' % pkg
        return db

    distkey = (trans_codename(codename, cfg), 'neurodebian-' + codename)

    if db[pkg].has_key(distkey):
        info = db[pkg][distkey]
    else:
        info = {'architecture': []}

    # fill in data
    if not st['Architecture'] in info['architecture']:
        info['architecture'].append(st['Architecture'])
    info['maintainer'] = st['Maintainer']
    if st.has_key('Homepage'):
        info['homepage'] = st['Homepage']
    info['version'] = st['Version']

    # origin
    info['distribution'] = origin
    info['release'] = codename
    info['component'] = component

    # pool url
    info['poolurl'] = '/'.join([os.path.dirname(st['Filename'])])

    # pkg description
    descr = st['Description'].replace('%', '%%').split('\n')
    info['description'] = descr[0].strip()
    info['long_description'] = ' '.join([l.strip() for l in descr[1:]])

    db[pkg][distkey] = info

    # charge the basic property set
    db[pkg]['main']['description'] = info['description']
    db[pkg]['main']['long_description'] = info['long_description']
    if st.has_key('Homepage'):
        db[pkg]['main']['homepage'] = st['Homepage']

    return db


def trans_codename(codename, cfg):
    """Translate a known codename into a release description.

    Unknown codenames will simply be returned as is.
    """
    # if we know something, tell
    if codename in cfg.options('release codenames'):
        return cfg.get('release codenames', codename)
    else:
        return codename


def create_dir(path):
    if os.path.exists(path):
        return

    ps = path.split(os.path.sep)

    for i in range(1,len(ps) + 1):
        p = os.path.sep.join(ps[:i])

        if not os.path.exists(p):
            os.mkdir(p)


def dde_get(url):
    try:
        return json.read(urllib2.urlopen(url+"?t=json").read())['r']
    except urllib2.HTTPError:
        return False


def import_dde(cfg, db):
    dists = cfg.get('dde', 'dists').split()
    query_url = cfg.get('dde', 'pkgquery_url')
    for p in db.keys():
        # get freshest
        q = dde_get(query_url + "/packages/all/%s" % p)
        if q:
            db[p]['main'] = q
            # get latest popcon info for debian and ubuntu
            # cannot use origin field itself, since it is none for few packages
            # i.e. python-nifti
            origin = q['drc'].split()[0]
            print 'popcon query for', p
            if origin == 'ubuntu':
                print 'have ubuntu first'
                if q.has_key('popcon'):
                    print 'ubuntu has popcon'
                    db[p]['main']['ubuntu_popcon'] = q['popcon']
                # if we have ubuntu, need to get debian
                q = dde_get(query_url + "/packages/prio-debian-sid/%s" % p)
                if q and q.has_key('popcon'):
                    print 'debian has popcon'
                    db[p]['main']['debian_popcon'] = q['popcon']
            elif origin == 'debian':
                print 'have debian first'
                if q.has_key('popcon'):
                    print 'debian has popcon'
                    db[p]['main']['debian_popcon'] = q['popcon']
                # if we have debian, need to get ubuntu
                q = dde_get(query_url + "/packages/prio-ubuntu-karmic/%s" % p)
                if q and q.has_key('popcon'):
                    print 'ubuntu has popcon'
                    db[p]['main']['ubuntu_popcon'] = q['popcon']
            else:
                print("Ignoring unkown origin '%s' for package '%s'." \
                        % (origin, p))

        # now get info for package from all releases in UDD
        q = dde_get(query_url + "/dist/p:%s" % p)
        if not q:
            continue
        # hold all info about this package per distribution release
        info = {}
        for cp in q:
            distkey = (trans_codename(cp['release'], cfg),
                       "%s-%s" % (cp['distribution'], cp['release']))
            if not info.has_key(distkey):
                info[distkey] = cp
                # turn into a list to append others later
                info[distkey]['architecture'] = [info[distkey]['architecture']]
            # accumulate data for multiple over archs
            else:
                comp = apt.VersionCompare(cp['version'],
                                          info[distkey]['version'])
                # found another arch for the same version
                if comp == 0:
                    info[distkey]['architecture'].append(cp['architecture'])
                # found newer version, dump the old ones
                elif comp > 0:
                    info[distkey] = cp
                    # turn into a list to append others later
                    info[distkey]['architecture'] = [info[distkey]['architecture']]
                # simply ignore older versions
                else:
                    pass

        # finally assign the new package data
        for k, v in info.iteritems():
            db[p][k] = v

    return db


def generate_pkgpage(pkg, cfg, db, template, addenum_dir):
    # local binding for ease of use
    db = db[pkg]
    # do nothing if there is not at least the very basic stuff
    if not db['main'].has_key('description'):
        return
    title = '**%s** -- %s' % (pkg, db['main']['description'])
    underline = '*' * (len(title) + 2)
    title = '%s\n %s\n%s' % (underline, title, underline)

    # preprocess long description
    ld = db['main']['long_description']
    ld = ' '.join([l.lstrip(' .') for l in ld.split('\n')])

    page = template.render(pkg=pkg,
                           title=title,
                           long_description=ld,
                           cfg=cfg,
                           db=db)
    # the following can be replaced by something like
    # {% include "sidebar.html" ignore missing %}
    # in the template whenever jinja 2.2 becomes available
    addenum = os.path.join(os.path.abspath(addenum_dir), '%s.rst' % pkg)
    if os.path.exists(addenum):
        page += '\n\n.. include:: %s\n' % addenum
    return page


def store_db(db, filename):
    pp = PrettyPrinter(indent=2)
    f = open(filename, 'w')
    f.write(pp.pformat(db))
    f.close()


def read_db(filename):
    f = open(filename)
    db = eval(f.read())
    return db

def write_sourceslist(jinja_env, cfg, outdir):
    create_dir(outdir)
    create_dir(os.path.join(outdir, '_static'))

    repos = {}
    for release in cfg.options('release codenames'):
        transrel = trans_codename(release, cfg)
        repos[transrel] = []
        for mirror in cfg.options('mirrors'):
            listname = 'neurodebian.%s.%s.sources.list' % (release, mirror)
            repos[transrel].append((mirror, listname))
            lf = open(os.path.join(outdir, '_static', listname), 'w')
            aptcfg = '%s %s main contrib non-free\n' % (cfg.get('mirrors', mirror),
                                                      release)
            lf.write('deb %s' % aptcfg)
            lf.write('deb-src %s' % aptcfg)
            lf.close()

    srclist_template = jinja_env.get_template('sources_lists.rst')
    sl = open(os.path.join(outdir, 'sources_lists'), 'w')
    sl.write(srclist_template.render(repos=repos))
    sl.close()


def write_pkgpages(jinja_env, cfg, db, outdir, addenum_dir):
    create_dir(outdir)
    create_dir(os.path.join(outdir, 'pkgs'))

    # generate the TOC with all packages
    toc_template = jinja_env.get_template('pkgs_toc.rst')
    toc = open(os.path.join(outdir, 'pkgs.rst'), 'w')
    toc.write(toc_template.render(pkgs=db.keys()))
    toc.close()

    # and now each individual package page
    pkg_template = jinja_env.get_template('pkg.rst')
    for p in db.keys():
        page = generate_pkgpage(p, cfg, db, pkg_template, addenum_dir)
        # when no page is available skip this package
        if page is None:
            continue
        pf = open(os.path.join(outdir, 'pkgs', p + '.rst'), 'w')
        pf.write(generate_pkgpage(p, cfg, db, pkg_template, addenum_dir))
        pf.close()


def prepOptParser(op):
    # use module docstring for help output
    op.usage = "%s [OPTIONS]\n\n" % sys.argv[0] + __doc__

    op.add_option("--db",
                  action="store", type="string", dest="db",
                  default=None,
                  help="Database file to read. Default: None")

    op.add_option("--cfg",
                  action="store", type="string", dest="cfg",
                  default=None,
                  help="Repository config file.")

    op.add_option("-o", "--outdir",
                  action="store", type="string", dest="outdir",
                  default=None,
                  help="Target directory for ReST output. Default: None")

    op.add_option("-r", "--release-url",
                  action="append", dest="release_urls",
                  help="None")

    op.add_option("--pkgaddenum", action="store", dest="addenum_dir",
                  type="string", default=None, help="None")


def main():
    op = OptionParser(version="%prog 0.0.2")
    prepOptParser(op)

    (opts, args) = op.parse_args()

    if len(args) != 1:
        print('There needs to be exactly one command')
        sys.exit(1)

    cmd = args[0]

    if opts.cfg is None:
        print("'--cfg' option is mandatory.")
        sys.exit(1)
    if opts.db is None:
        print("'--db' option is mandatory.")
        sys.exit(1)


    cfg = SafeConfigParser()
    cfg.read(opts.cfg)

    # load existing db, unless renew is requested
    if cmd == 'updatedb':
        db = {}
        if cfg.has_option('packages', 'select taskfiles'):
            db = add_pkgfromtaskfile(db, cfg.get('packages',
                                                 'select taskfiles').split())

        # add additional package names from config file
        if cfg.has_option('packages', 'select names'):
            for p in cfg.get('packages', 'select names').split():
                if not db.has_key(p):
                    db[p] = get_emptydbentry()

        # get info from task files
        if cfg.has_option('packages', 'prospective'):
            for url in cfg.get('packages', 'prospective').split():
                db = import_blendstask(db, url)

        # parse NeuroDebian repository
        if cfg.has_option('neurodebian', 'releases'):
            for rurl in cfg.get('neurodebian', 'releases').split():
                db = import_release(cfg, db, rurl)

        # collect package information from DDE
        db = import_dde(cfg, db)
        # store the new DB
        store_db(db, opts.db)
        # and be done
        return

    # load the db from file
    db = read_db(opts.db)

    # fire up jinja
    jinja_env = Environment(loader=PackageLoader('neurodebian', 'templates'))

    # generate package pages and TOC and write them to files
    write_pkgpages(jinja_env, cfg, db, opts.outdir, opts.addenum_dir)

    write_sourceslist(jinja_env, cfg, opts.outdir)

if __name__ == "__main__":
    main()
