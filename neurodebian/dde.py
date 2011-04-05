#!/usr/bin/env python
"""Tell me who you are!
"""

import pysvn
import json
from debian_bundle import deb822
import numpy as np
import jinja2

# Lets first assure no guarding (but annoying) warnings
import warnings
warnings.simplefilter('ignore', FutureWarning)
warnings.filterwarnings('ignore', 'Module debian_bundle was already imported.*', UserWarning)

import apt
from ConfigParser import SafeConfigParser
from optparse import OptionParser, Option, OptionGroup, OptionConflictError
import sys
import os
import copy
import shutil
import urllib2
import urllib
import codecs
import subprocess
import time
import re
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
        fh = codecs.open(cfilename, 'r', 'utf-8')

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
            elif stanza.has_key('Recommends'):
                pkg = stanza['Recommends']
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

def import_blendstask(cfg, db, url):
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

        if st.has_key('Depends'):
            pkg = st['Depends']
        elif st.has_key('Recommends'):
            pkg = st['Recommends']
        elif st.has_key('Suggests'):
            pkg = st['Suggests']
        else:
#            print 'Warning: Cannot determine name of prospective package ' \
#                    '... ignoring. Dump follows:'
#            print st
            continue

        # take care of pkg lists
        for p in pkg.split(', '):
            if not db.has_key(p):
                print 'Ignoring blend package "%s"' % p
                continue

            info = {}

            # blends info
            info['tasks'] = [task]
            if st.has_key('License'):
                info['license'] = st['License']
            if st.has_key('Responsible'):
                info['responsible'] = st['Responsible']

            # pkg description
            if st.has_key('Pkg-Description'):
                descr = st['Pkg-Description'].split('\n')
                info['description'] = descr[0].strip()
                info['long_description'] = \
                        u'\n'.join(descr[1:])

                # charge the basic property set
                db[p]['main']['description'] = info['description']
                db[p]['main']['long_description'] = info['long_description']
            if st.has_key('WNPP'):
                db[p]['main']['debian_itp'] = st['WNPP']
            if st.has_key('Pkg-URL'):
                db[p]['main']['other_pkg'] = st['Pkg-URL']
            if st.has_key('Homepage'):
                db[p]['main']['homepage'] = st['Homepage']

            # Publications
            if st.has_key('Published-Title'):
                title = st['Published-Title']
                if title[-1] == '.':
                    # trip trailing dot -- added later
                    pub = {'title': title[:-1]}
                else:
                    pub = {'title': title}
                if st.has_key('Published-Authors'):
                    pub['authors'] = st['Published-Authors']
                if st.has_key('Published-Year'):
                    pub['year'] = st['Published-Year']
                if st.has_key('Published-In'):
                    pub['in'] = st['Published-In']
                if st.has_key('Published-URL'):
                    pub['url'] = st['Published-URL']
                if st.has_key('Published-DOI'):
                    pub['doi'] = st['Published-DOI']
                    # need at least one URL
                    if not pub.has_key('url'):
                        pub['url'] = "http://dx.doi.org/%s" % st['Published-DOI']

                db[p]['main']['publication'] = pub

            # Registration
            if st.has_key('Registration'):
                db[p]['main']['registration'] = st['Registration']

            # Remarks
            if st.has_key('Remark'):
                # prepend a single space to make it look like a long description
                info['remark'] = convert_longdescr(' ' + st['Remark'])

            # only store if there isn't something already
            if not db[p].has_key('blends'):
                db[p]['blends'] = info
            else:
                # just add this tasks name and id
                db[p]['blends']['tasks'].append(task)

            # handle pkg name aliases
            if p in cfg.options('blend package aliases'):
                src_entry = db[p].copy()
                # remove original entry
                del db[p]
                # copy the entry into all aliases
                for alias in cfg.get('blend package aliases', p).split():
                    print "Aliasing %s to %s" % (p, alias)
                    db[alias] = copy.deepcopy(src_entry)

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
    info['long_description'] = u'\n'.join(descr[1:])

    db[pkg][distkey] = info

    # charge the basic property set
    db[pkg]['main']['description'] = info['description']
    db[pkg]['main']['long_description'] = info['long_description']
    if st.has_key('Source'):
        db[pkg]['main']['sv'] = "%s %s" % (st['Source'], st['Version'])
    else:
        db[pkg]['main']['sv'] = "%s %s" % (st['Package'], st['Version'])
    if st.has_key('Homepage'):
        db[pkg]['main']['homepage'] = st['Homepage']
    if st.has_key('Recommends'):
        db[pkg]['main']['recommends'] = st['Recommends']

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


def dde_get(url, fail=False):
    # enforce delay to be friendly to DDE
    time.sleep(3)
    try:
        data = json.read(urllib2.urlopen(url+"?t=json").read())['r']
        print "SUCCESS:", url
        return data
    except urllib2.HTTPError, e:
        print "NOINFO:", url, type(e)
        return False
    except urllib2.URLError, e:
        print "URLERROR:", url, type(e)
        if fail:
            print "Permanant failure"
            return False
        print "Try again after 30 seconds..."
        time.sleep(30)
        return dde_get(url, fail=True)
    except (StopIteration):
        print "NOINFO:", url
        return False
    except json.ReadException, e:
        print "UDD-DOWN?:", url, type(e)
        return False


def nitrc_get(spec, fail=False):
    nitrc_url = 'http://www.nitrc.org/export/site/projects.json.php'
    try:
        # change into this from python 2.6 on
        #data = json.loads(urllib2.urlopen(nitrc_url + '?spec=%s' % spec).read())
        data = json.read(urllib2.urlopen(nitrc_url + '?spec=%s' % spec).read())
        print "NITRC-SUCCESS:", spec
    except urllib2.HTTPError, e:
        print "NITRC-NOINFO:", spec, type(e)
        return False
    except urllib2.URLError, e:
        print "NITRC-URLERROR:", spec, type(e)
        if fail:
            print "Permanant failure"
            return False
        print "Try again after 30 seconds..."
        time.sleep(30)
        return nitrc_get(spec, fail=True)
    return data


def parse_nitrc(data):
    if data is False:
        return None
    # simplify -- there is only one project in the data
    project = data['projects'][0]
    nitrc_filtered = {'downloads': 0,
                      'id': project['id']}
    for pkg in project['packages']:
        for release in pkg['releases']:
            for file in release['files']:
                nitrc_filtered['downloads'] += file['download_count']
    return nitrc_filtered


def import_nitrc(cfg, db):
    for p in db.keys():
        if not cfg.has_option("nitrc ids", p):
            continue
        nitrc_spec = cfg.get("nitrc ids", p)
        nitrc_data = nitrc_get(nitrc_spec)
        nitrc_excerpt = parse_nitrc(nitrc_data)
        if not nitrc_excerpt is None:
            db[p]['nitrc'] = nitrc_excerpt
    return db


def import_dde(cfg, db):
    query_url = cfg.get('dde', 'pkgquery_url')
    for p in db.keys():
        # get freshest
        q = dde_get(query_url + "/packages/all/%s" % p)
        if q:
            # copy all stuff, while preserving non-overlapping information
            for k, v in q.iteritems():
                db[p]['main'][k] = v
            # get latest popcon info for debian and ubuntu
            # cannot use origin field itself, since it is none for few packages
            # i.e. python-nifti
            origin = q['drc'].split()[0]
            if origin == 'ubuntu':
                if q.has_key('popcon'):
                    db[p]['main']['ubuntu_popcon'] = q['popcon']
                # if we have ubuntu, need to get debian
                q = dde_get(query_url + "/packages/prio-debian-sid/%s" % p)
                if q and q.has_key('popcon'):
                    db[p]['main']['debian_popcon'] = q['popcon']
            elif origin == 'debian':
                if q.has_key('popcon'):
                    db[p]['main']['debian_popcon'] = q['popcon']
                # if we have debian, need to get ubuntu
                q = dde_get(query_url + "/packages/prio-ubuntu-natty/%s" % p)
                if q and q.has_key('popcon'):
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

def assure_unicode(s):
    """Assure that argument is unicode

    Necessary if strings are not carrying out Pythonish 'u' prefix to
    signal UTF8 strings, but are in fact UTF8
    """
    if type(s) is unicode:
        return s
    elif type(s) is str:
        # attempt regular unicode call and if fails -- just decode it
        # into utf8
        try:
            return unicode(s)
        except UnicodeDecodeError, e:
            return s.decode('utf8')
    else:
        return assure_unicode(str(s))


def convert_longdescr(ld):
    """

    yoh: I think all this long description conversion will keep giving
    us problems since per se there is no strict regulations,
    especially in blends files
    """
    descr = u''
    ld = ld.replace('% ', '%% ')
    ld = ld.replace(r'\t', '    ') # just in case assuming tab 4
    ld = ld.split('\n')
    re_leadblanks = re.compile("^ *")
    re_itemized = re.compile("^[o*-+] +")
    re_itemized_gr = re.compile("^( *)([-o*+] +)?(.*?)$")
    re_description_gr = re.compile("^( *[^-]+ - )(.*?)$")

    def unwrap_lines(lines):
        out = []
        indent_levels = [-1]
        for l in lines:
            match = re_itemized_gr.search(l).groups()
            if ((len(match[0]) in indent_levels and match[1] is None)
                or (len(match[0]) > max(indent_levels)+4)) \
                and match[2].strip() != '.':
                # append to previous
                if not out[-1].endswith(" "):
                    out[-1] += " "
                out[-1] += match[2]
            else:
                out.append(l)

            indent_levels = [len(match[0])]
            if match[1] is not None:
                indent_levels += [len(match[0]) + len(match[1])]
            if match[2].strip() == '.':
                # reset though if '.'
                indent_levels = [-1]
        return out

    def dedent_withlevel(lines):
        """Dedent `lines` given in a list provide dedented lines and how much was dedented
        """
        nleading = min([re_leadblanks.search(l).span()[1]
                        for l in lines])
        return [l[nleading:] for l in lines], nleading

    def block_lines(ld, level=0):
        # so we got list of lines
        # dedent all of them first
        ld, level = dedent_withlevel(ld)

        # lets collect them in blocks/paragraphs
        # 1. into paragraphs split by '.'
        blocks, block = [], None

        # next block can begin if
        #  1.  . line
        #  2. it was an itemized list and all items begin with
        #     the same symbol or get further indented accordingly
        #     so let's first check if it is an itemized list
        itemized_match = re_itemized.search(ld[0])
        if itemized_match:
            allow_indents = " "*itemized_match.span()[1]
        else:
            allow_indents = None
        for l in ld:
            if block is None or l.strip() == '.' \
                   or (len(l) and ( len(block) and (
                (l.startswith(' ') and not block[-1].startswith(' '))
                or
                (not l.startswith(' ') and block[-1].startswith(' '))))):
                block = []
                blocks.append(block)
            if l.strip() != '.':
                block.append(l)
        if len(blocks) == 1:
            return blocks[0]
        else:
            return [block_lines(b, level+1) for b in blocks]

    def blocks_to_rst(bls, level=0):
        # check if this block is an itemized beast
        #itemized_match = re_itemized_gr.search(bls[0][0])
        #if itemized_match:
        #    res += ' 'allow_indents = " "*itemized_match.span()[1]
        out = ''
        for b in bls:
            if isinstance(b, list):
                if len(b) == 1:
                    out += " "*level + b[0] + '\n\n'
                else:
                    out += blocks_to_rst(b, level+1)
            else:
                e = " "*level + b + '\n'
                if not re_itemized.search(b):
                    pass
                    #e += '\n'
                elif len(e) and e[0] == ' ':
                    # strip 1 leading blank
                    e = e[1:]
                out += e
        out += '\n'
        return out

    ld = unwrap_lines(ld)
    bls = block_lines(ld)
    return blocks_to_rst(bls)


def underline_text(text, symbol):
    underline = symbol * len(text)
    return '%s\n%s\n' % (text, underline)


def generate_pkgpage(pkg, cfg, db, template, addenum_dir, extracts_dir):
    # local binding for ease of use
    pkgdb = db[pkg]
    # do nothing if there is not at least the very basic stuff
    if not pkgdb['main'].has_key('description'):
        return
    title = '**%s** -- %s' % (pkg, pkgdb['main']['description'])
    title = underline_text(title, '*')

    ex_dir = None
    if 'sv' in pkgdb['main']:
        ex_dir = os.path.join(extracts_dir, pkgdb['main']['sv'].split()[0])
        if not os.path.exists(ex_dir):
            ex_dir = None
    page = template.render(
            pkg=pkg,
            title=title,
            long_description=convert_longdescr(
                assure_unicode(pkgdb['main']['long_description'])),
            cfg=cfg,
            db=pkgdb,
            fulldb=db,
            extracts_dir=ex_dir,
            op=os.path)
    # the following can be replaced by something like
    # {% include "sidebar.html" ignore missing %}
    # in the template whenever jinja 2.2 becomes available
    addenum = os.path.join(os.path.abspath(addenum_dir), '%s.rst' % pkg)
    if os.path.exists(addenum):
        page += '\n\n.. include:: %s\n' % addenum
    return page


def store_db(db, filename):
    pp = PrettyPrinter(indent=2)
    f = codecs.open(filename, 'w', 'utf-8')
    f.write(pp.pformat(db))
    f.close()


def read_db(filename):
    f = codecs.open(filename, 'r', 'utf-8')
    db = eval(f.read())
    return db

def write_sourceslist(jinja_env, cfg, outdir):
    create_dir(outdir)
    create_dir(os.path.join(outdir, 'lists'))

    repos = {}
    for release in cfg.options('release codenames'):
        if release == 'data':
            # no seperate list for the data archive
            continue
        transrel = trans_codename(release, cfg)
        repos[transrel] = []
        for mirror in cfg.options('mirrors'):
            listname = '%s.%s' % (release, mirror)
            repos[transrel].append((mirror, listname))
            lf = open(os.path.join(outdir, 'lists', listname), 'w')
            for rel in ('data', release):
                aptcfg = '%s %s main contrib non-free\n' % (cfg.get('mirrors', mirror),
                                                          rel)
                lf.write('deb %s' % aptcfg)
                lf.write('#deb-src %s' % aptcfg)
            lf.close()

    id2codename = dict([(cfg.get('release backport ids', r), r)
                            for r in cfg.options('release codenames')])
    id2relname = dict([(cfg.get('release backport ids', r), trans_codename(r, cfg))
                            for r in cfg.options('release codenames')])
    mirror2name = dict([(m, cfg.get('mirror names', m))
                            for m in cfg.options('mirrors')])
    mirror2url = dict([(m, cfg.get('mirrors', m))
                            for m in cfg.options('mirrors')])
    srclist_template = jinja_env.get_template('sources_lists.rst')
    sl = open(os.path.join(outdir, 'sources_lists'), 'w')
    sl.write(srclist_template.render(id2codename=id2codename,
                                     id2relname=id2relname,
                                     mirror2name=mirror2name,
                                     mirror2url=mirror2url))
    sl.close()


def sort_by_tasks(db):
    tasks = {}
    for pkg in db.keys():
        if not 'blends' in db[pkg]:
            # no blend info
            continue
        blendinfo = db[pkg]['blends']
        if not 'tasks' in blendinfo:
            # no task info in blend data
            continue
        taskinfo = blendinfo['tasks']
        for task in taskinfo:
            taskname = task[1]
            if not taskname in tasks:
                tasks[taskname] = []
            else:
                tasks[taskname].append(pkg)
    return tasks


def sort_by_maintainer(db):
    maints = {}
    maint_ids = {}
    for pkg in db.keys():
        maint = None
        pkginfo = db[pkg]
        # start with the blends info
        if 'blends' in pkginfo and 'responsible' in pkginfo['blends']:
            maint = pkginfo['blends']['responsible']
        if not 'main' in db[pkg] and maint is None:
            # no info
            continue
        info = db[pkg]['main']
        if not 'maintainer' in info and maint is None:
            # no maintainer info
            continue
        if 'original_maintainer' in info and not info['original_maintainer'] is None:
            maint = info['original_maintainer']
        elif 'maintainer' in info and not info['maintainer'] is None:
            maint = info['maintainer']
        if maint is None:
            # no sane maintainer info
            continue
        # safeguard: <> confuses sphinx and we don't care about different emails
        maint = maint[:maint.find('<')].strip()
        # kick out non-ascii ones (should not be, but too tired to find the bug)
        try:
            codecs.ascii_decode(maint)
        except UnicodeEncodeError:
            continue
        if not maint.lower() in maints:
            maints[maint.lower()] = []
            maint_ids[maint.lower()] = [maint]
        else:
            maint_ids[maint.lower()].append(maint)
        maints[maint.lower()].append(pkg)
    # remove duplicates
    out = {}
    for m in maints:
        out[maint_ids[m][0]] = np.unique(maints[m])
    return out


def sort_by_release(db):
    rels = {}
    for pkg in db.keys():
        pkginfo = db[pkg]
        for sec in pkginfo:
            if not isinstance(sec, tuple):
                # only releases are of interest
                continue
            relname = sec[0]
            if not relname in rels:
                rels[relname] = []
            else:
                rels[relname].append(pkg)
    # remove duplicates
    for r in rels:
        rels[r] = np.unique(rels[r])
    return rels


def write_pkgpages(jinja_env, cfg, db, outdir, addenum_dir, extracts_dir):
    create_dir(outdir)
    create_dir(os.path.join(outdir, 'pkgs'))
    create_dir(os.path.join(outdir, 'pkglists'))
    # template for individual package listings
    toc_template = jinja_env.get_template('pkgs_toc.rst')
    # the high-level package list overview
    hltoc = codecs.open(os.path.join(outdir, 'pkgs.rst'), 'w', 'utf-8')
    hltoc.write('.. _pkglists:\n\n')
    hltoc.write(underline_text('Software packages', '='))
    defs = [(sort_by_tasks(db), 'By purpose', 'Packages for %s'),
            (sort_by_release(db), 'By release', 'Packages for %s'),
            (sort_by_maintainer(db), 'By maintainer', 'Packages by %s')]
    for def_ in defs:
        # TOC for each thingie
        pkgsdict, sectitle, title_tmpl = def_
        hltoc.write(underline_text(sectitle, '-'))
        ids = pkgsdict.keys()
        ids.sort()
        for id_ in ids:
            label = ('pkgs-%s-%s' % (sectitle, id_)).lower().replace(' ', '_').replace('/', '_')
            # filter out crap
            filtered_pkgs = [p for p in pkgsdict[id_] if p in db]
            if not len(filtered_pkgs):
                continue
            plist = toc_template.render(
                        label=label,
                        title=underline_text(title_tmpl % id_, '='),
                        pkgs=filtered_pkgs,
                        db=db)
            toc = codecs.open(os.path.join(outdir,
                                           'pkglists',
                                           '%s.rst' % label),
                              'w', 'utf-8')
            toc.write(plist)
            toc.close()
            hltoc.write('* :ref:`%s`\n' % label)
        hltoc.write('\n\n')


    # now a complete list of all packages
    hltoc.write(underline_text('Complete list', '-'))
    toc = codecs.open(os.path.join(outdir, 'pkglists', 'pkgs-all.rst'),
                      'w', 'utf-8')
    toc.write(toc_template.render(label='full_pkg_list',
                title=underline_text('Complete package list', '='),
                pkgs=db.keys(), db=db))
    toc.close()
    hltoc.write('* :ref:`full_pkg_list`\n')
    hltoc.close()

    # and now each individual package page
    pkg_template = jinja_env.get_template('pkg.rst')
    for p in db.keys():
        page = generate_pkgpage(p, cfg, db, pkg_template, addenum_dir, extracts_dir)
        # when no page is available skip this package
        if page is None:
            continue
        pf = codecs.open(os.path.join(outdir, 'pkgs', p + '.rst'), 'w', 'utf-8')
        pf.write(page)
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

    op.add_option("--extracts", action="store", dest="extracts_dir",
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

    if cmd == 'debug_ld':
        # load the db from file
        db = read_db(opts.db)

        for p in db.keys():
        #for p in ['dtitk', 'psychopy', 'psytoolkit', 'ginkgo-cadx', 'gridengine-master', 'cctools']:
            if not 'long_description' in db[p]['main']:
                continue
            ld = db[p]['main']['long_description']

            print ">>>>>>>>> ", p
            #print ld
            print "----"
            print convert_longdescr(ld)
        raise SystemExit
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
                db = import_blendstask(cfg, db, url)

        # parse NeuroDebian repository
        if cfg.has_option('neurodebian', 'releases'):
            for rurl in cfg.get('neurodebian', 'releases').split():
                db = import_release(cfg, db, rurl)

        # collect package information from DDE
        db = import_dde(cfg, db)
        # get info from NITRC
        db = import_nitrc(cfg, db)
        # store the new DB
        store_db(db, opts.db)
        # and be done
        return

    # load the db from file
    db = read_db(opts.db)

    # fire up jinja
    jinja_env = Environment(loader=PackageLoader('neurodebian', 'templates'))

    # generate package pages and TOC and write them to files
    write_pkgpages(jinja_env, cfg, db, opts.outdir, opts.addenum_dir, opts.extracts_dir)

    write_sourceslist(jinja_env, cfg, opts.outdir)

if __name__ == "__main__":
    main()
