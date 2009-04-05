import urllib
import apt
from debian_bundle import deb822
from debian_bundle import debtags
from ConfigParser import SafeConfigParser
import subprocess
import os
import shutil
import pysvn

target_dir = 'build/source'

codename2descr = {
    'apsy_etch': 'Debian GNU/Linux 4.0 (etch)',
    'apsy_lenny': 'Debian GNU/Linux 5.0 (lenny)',
    'apsy_squeeze': 'Debian testing (squeeze)',
    'apsy_sid': 'Debian unstable (sid)',
    'apsy_dapper': 'Ubuntu 6.06 LTS "Dapper Drake" (dapper)',
    'apsy_edgy': 'Ubuntu 6.10 "Edgy Eft" (edgy)',
    'apsy_feisty': 'Ubuntu 7.04 "Feisty Fawn" (feisty)',
    'apsy_gutsy': 'Ubuntu 7.10 "Gutsy Gibbon" (gutsy)',
    'apsy_hardy': 'Ubuntu 8.04 LTS "Hardy Heron" (hardy)',
    'apsy_intrepid': 'Ubuntu 8.10 "Intrepid Ibex" (intrepid)',
    'apsy_jaunty': 'Ubuntu 9.04 "Jaunty Jackalope" (jaunty)',
    }

def transCodename(codename):
    """Translate a known codename into a release description.

    Unknown codenames will simply be returned as is.
    """
    if codename in codename2descr.keys():
        return codename2descr[codename]
    else:
        return codename



class AptListsCache(object):
    def __init__(self, cachedir='cache', ro_cachedirs=None):
        self.cachedir = cachedir

        if not ro_cachedirs is None:
            self.ro_cachedirs = ro_cachedirs
        else:
            self.ro_cachedirs = []

        # always use system cache
        self.ro_cachedirs.append('/var/lib/apt/lists/')


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
            print 'Caching file from %s' % url

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




class DebianPkgArchive(SafeConfigParser):
    """
    """
    def __init__(self, cache=None):
        """
        :Parameter:
        """
        SafeConfigParser.__init__(self)

        # release codnames found in the repos
        self.releases = {}

        # use provided file cache or use fresh one
        if not cache is None:
            self.cache = cache
        else:
            self.cache = AptListsCache()

        # init debtags DB
        self.dtags = debtags.DB()
        self.dtags.read(open('/var/lib/debtags/package-tags'))

        # init package filter
        self.pkgfilter = None


    def __repr__(self):
        """Generate INI file content for current content.
        """
        # make adaptor to use str as file-like (needed for ConfigParser.write()
        class file2str(object):
            def __init__(self):
                self.__s = ''
            def write(self, val):
                self.__s += val
            def str(self):
                return self.__s

        r = file2str()
        self.write(r)

        return r.str()


    def save(self, filename):
        """Write current content to a file.
        """
        f = open(filename, 'w')
        self.write(f)
        f.close()


    def ensureUnique(self, section, option, value):
        if not self.has_option(section, option):
            self.set(section, option, value)
        else:
            if not self.get(section, option) == value:
                raise ValueError, "%s: %s is not unique (%s != %s)" \
                                  % (section, option,
                                     self.get(section, option), value)


    def appendUniqueCSV(self, section, option, value):
        """
        """
        if not self.has_option(section, option):
            self.set(section, option, value)
        else:
            l = self.get(section, option).split(', ')
            if not value in l:
                self.set(section, option, ', '.join(l + [value]))


    def importRelease(self, rurl, force_update=False):
        # root URL of the repository
        baseurl = '/'.join(rurl.split('/')[:-1])
        # get the release file from the cache
        release_file = self.cache.get(rurl, update=force_update)

        # create parser instance
        rp = deb822.Release(release_file)

        # architectures on this dist
        archs = rp['Architectures'].split()
        components = rp['Components'].split()
        # compile a new codename that also considers the repository label
        # to distinguish between official and unofficial repos.
        codename = '_'.join([rp['Label'], rp['Codename']])

        # store the release itself
        if not codename in self.releases.keys():
            self.releases[codename] = components

        # compile the list of Packages files to parse and parse them
        for c in components:
            for a in archs:
                # compile packages URL
                pkgsurl = '/'.join([baseurl, c, 'binary-' + a, 'Packages.bz2'])

                # retrieve from cache
                packages_file = self.cache.get(pkgsurl,
                                               update=force_update)

                # parse
                self._parsePkgsFile(packages_file, codename, c, baseurl)

                # cleanup
                packages_file.close()

        # cleanup
        release_file.close()


    def _parsePkgsFile(self, fh, codename, component, baseurl):
        """
        :Parameters:
          fh: file handler
            Packages list file
          codename: str
            Codename of the release
          component: str
            The archive component this packages file corresponds to.
        """
        for stanza in deb822.Packages.iter_paragraphs(fh):
            self._storePkg(stanza, codename, component, baseurl)


    def _storePkg(self, st, codename, component, baseurl):
        """
        :Parameter:
          st: Package section
        """
        pkg = st['Package']

        # do nothing if package is not in filter if there is any
        if not self.pkgfilter is None and not pkg in self.pkgfilter:
            return

        if not self.has_section(pkg):
            self.add_section(pkg)

        # which releases
        self.appendUniqueCSV(pkg, "releases", codename)

        # arch listing
        self.appendUniqueCSV(pkg, "archs %s" % codename, st['Architecture'])

        # versions
        self.ensureUnique(pkg,
                          "version %s %s" % (codename, st['Architecture']),
                          st['Version'])

        # link to .deb
        self.ensureUnique(pkg,
                          "file %s %s" % (codename, st['Architecture']),
                          '/'.join(baseurl.split('/')[:-2] + [st['Filename']]))

        # component
        self.ensureUnique(pkg, 'component ' + codename, component)

        # store the pool url
        self.ensureUnique(pkg, "poolurl %s" % codename,
                 '/'.join(baseurl.split('/')[:-2] \
                         + [os.path.dirname(st['Filename'])]))


        # now the stuff where a single variant is sufficient and where we go for
        # the latest available one
        if self.has_option(pkg, "newest version") \
            and apt.VersionCompare(st['Version'],
                                   self.get(pkg, "newest version")) < 0:
            return

        # everything from here will overwrite existing ones

        # we seems to have an updated package
        self.set(pkg, "newest version", st['Version'])

        # description
        self.set(pkg, "description", st['Description'].replace('%', '%%'))

        # maintainer
        self.set(pkg, "maintainer", st['Maintainer'])

        # optional stuff
        if st.has_key('Homepage'):
            self.set(pkg, 'homepage', st['Homepage'])

        # query debtags
        debtags = self.dtags.tagsOfPackage(pkg)
        if debtags:
            self.set(pkg, 'debtags', ', '.join(debtags))


    def writeSourcesLists(self):
        fl = open(os.path.join(target_dir, 'sources_lists'), 'w')
        for trans, r in sorted([(transCodename(k), k) 
                for k in self.releases.keys()]):
            f = open(os.path.join(target_dir,
                                  "static/debneuro.%s.sources.list" % r),
                     'w')
            f.write("deb http://apsy.gse.uni-magdeburg.de/debian %s %s\n" \
                    % (r, ' '.join(self.releases[r])))
            f.write("deb-src http://apsy.gse.uni-magdeburg.de/debian %s %s\n" \
                    % (r, ' '.join(self.releases[r])))
            # XXX use :download: role from sphinx 0.6 on
            fl.write('* `%s <http://apsy.gse.uni-magdeburg.de/debian/html/_static/debneuro.%s.sources.list>`_\n' \
                     % (trans, r))
            f.close()
        fl.close()


    def importProspectivePkgsFromTaskFile(self, url):
        fh = dpa.cache.get(url)

        for st in deb822.Packages.iter_paragraphs(fh):
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

            # store pkg info
            if not self.has_section(pkg):
                self.add_section(pkg)

            # pkg description
            self.set(pkg, "description",
                     st['Pkg-Description'].replace('%', '%%'))

            # optional stuff
            if st.has_key('Homepage'):
                self.set(pkg, 'homepage', st['Homepage'])

            if st.has_key('Pkg-URL'):
                self.set(pkg, 'external pkg url', st['Pkg-URL'])

            if st.has_key('WNPP'):
                self.set(pkg, 'wnpp debian', st['WNPP'])

            if st.has_key('License'):
                self.set(pkg, 'license', st['License'])

            # treat responsible as maintainer
            if st.has_key('Responsible'):
                self.set(pkg, "maintainer", st['Responsible'])


    def setPkgFilterFromTaskFile(self, urls):
        for task in taskfiles:
            fh = dpa.cache.get(task)

            pkgs = []

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

        # activate filter
        self.pkgfilter = pkgs


def genPkgPage(db, pkg):
    """
    :Parameters:
      db: database
      pkg: str
        Package name
    """
    descr = db.get(pkg, 'description').split('\n')

    s = '.. index:: %s, ' % pkg
#    s += db.get(pkg, 'maintainer').split('<')[0]

    s += '\n'

    if db.has_option(pkg, 'debtags'):
        # filter tags
        tags = [t for t in db.get(pkg, 'debtags').split(', ')
                    if t.split('::')[0] in ['field', 'works-with']]
        if len(tags):
            s += '.. index:: %s\n\n' % ', '.join(tags)

    # main ref target for this package
    s += '.. _deb_' + pkg + ':\n'

    # separate header from the rest
    s += '\n\n\n'

    header = '%s -- %s' % (pkg, descr[0])
    s += '*' * (len(header) + 2)
    s += '\n ' + header + '\n'
    s += '*' * (len(header) + 2) + '\n\n'

    # put description
    s += '\n'.join([l.lstrip(' .') for l in descr[1:]])
    s += '\n'

    if db.has_option(pkg, 'homepage'):
        s += '\n**Homepage**: %s\n' % db.get(pkg, 'homepage')

    s += '\nBinary packages'\
        '\n===============\n'

    s += genMaintainerSection(db, pkg)

    if db.has_option(pkg, 'wnpp debian'):
        s += 'A Debian packaging effort has been officially announced. ' \
             'Please see the corresponding `intent-to-package bug report`_ ' \
             'for more information about its current status.\n\n' \
             '.. _intent-to-package bug report: http://bugs.debian.org/%s\n\n' \
             % db.get(pkg, 'wnpp debian')

    s += genBinaryPackageSummary(db, pkg, 'DebNeuro repository')

#    if db.has_option(pkg, 'external pkg url'):
#        s += 'Other unofficial ressources\n' \
#             '---------------------------\n\n'
#        s += 'An unofficial package is available from %s\ .\n\n' \
#                % db.get(pkg, 'external pkg url')
    return s


def genMaintainerSection(db, pkg):
    s = ''

    if not db.has_option(pkg, 'maintainer'):
        s += '\nCurrently, nobody seems to be responsible for creating or ' \
             'maintaining Debian packages of this software.\n\n'
        return s

    # there is someone responsible
    maintainer = db.get(pkg, 'maintainer')

    # do we have actual packages, or is it just a note
    if not db.has_option(pkg, 'releases'):
        s += '\nThere are currently no binary packages available. However, ' \
             'the last known packaging effort was started by %s which ' \
             'meanwhile might have led to an initial unofficial Debian ' \
             'packaging.\n\n' % maintainer
        return s

    s += '\n**Maintainer**: %s\n\n' % maintainer

    if not maintainer.startswith('Michael Hanke'):
        s += '\n.. note::\n'
        s += '  Do not contact the original package maintainer regarding ' \
             '  bugs in this unofficial binary package. Instead, contact ' \
             '  the repository maintainer at michael.hanke@gmail.com\ .'

    return s


def genBinaryPackageSummary(db, pkg, reposname):
    # do nothing if the are no packages
    if not db.has_option(pkg, 'releases'):
        return ''

    s = '\n%s\n%s\n' % (reposname, '-' * len(reposname))

    s += 'The repository contains binary packages for the following ' \
         'distribution releases and system architectures. Note, that the ' \
         'corresponding source packages are of course available too. Please ' \
         'click on the release name to access them.\n\n'

    # for all releases this package is part of
    for rel in db.get(pkg, 'releases').split(', '):
        # write release description and component
        s += '\n`%s <%s>`_:\n  ' \
                % (transCodename(rel),
                   db.get(pkg, 'poolurl %s' % rel))

        s += '[%s] ' % db.get(pkg, 'component ' + rel)

        # archs this package is available for
        archs = db.get(pkg, 'archs ' + rel).split(', ')

        # extract all present versions for any arch
        versions =  [db.get(pkg, 'version %s %s' % (rel, arch))
                        for arch in archs]

        # if there is only a single version for all of them, simplify the list
        single_ver = versions.count(versions[0]) == len(versions)

        if single_ver:
            # only one version string for all
            s += ', '.join(['`%s <%s>`_' \
                    % (arch, db.get(pkg, 'file %s %s' % (rel, arch)))
                        for arch in archs])
            s += ' (%s)' % versions[0]
        else:
            # a separate version string for each arch
            s += ', '.join(['`%s <%s>`_ (%s)' \
                    % (arch,
                       db.get(pkg, 'file %s %s' % (rel, arch)),
                       db.get(pkg, 'version %s %s' % (rel, arch)))
                        for arch in archs])

        s += '\n'

    return s

def maintainer2email(maint):
    return maint.split('<')[1].rstrip('>')


def writePkgsBy(db, key, value2id):
    collector = {}

    # get packages by maintainer
    for p in db.sections():
        if db.has_option(p, key):
            by = db.get(p, key)

            if not collector.has_key(by):
                collector[by] = (value2id(by), [p])
            else:
                collector[by][1].append(p)

    toc = open(os.path.join(target_dir, 'by%s.rst' % key), 'w')
    toc.write('.. index:: Packages by %s\n.. _by%s:\n' % (key, key))

    heading = 'Packages by %s' % key
    toc.write('%s\n%s\n\n' % (heading, '=' * len(heading)))
    toc.write('.. toctree::\n  :maxdepth: 1\n\n')

    # summary page per maintainer
    for by in sorted(collector.keys()):
        toc.write('  by%s/%s\n' % (key, collector[by][0]))

    toc.close()


def writeRst(db):
    # open pkgs toctree
    toc = open(os.path.join(target_dir, 'pkgs.rst'), 'w')
    # write header
    toc.write('Archive content\n===============\n\n'
              '.. toctree::\n  :maxdepth: 1\n\n')

    for p in sorted(db.sections()):
        print "Generating page for '%s'" % p
        pf = open(os.path.join(target_dir, 'pkgs/%s.rst' % p), 'w')
        pf.write(genPkgPage(db, p))

        # check for doc addons
        if os.path.exists(os.path.join(target_dir, 'pkgs_addenum/%s.rst' % p)):
            pf.write('\n\n.. include:: ../pkgs_addenum/%s.rst\n' %p)
        pf.close()
        toc.write('  pkgs/%s\n' % p)


    toc.close()



dpa = DebianPkgArchive()


release_urls=[
            'http://apsy.gse.uni-magdeburg.de/debian/dists/dapper/Release',
            'http://apsy.gse.uni-magdeburg.de/debian/dists/gutsy/Release',
            'http://apsy.gse.uni-magdeburg.de/debian/dists/hardy/Release',
            'http://apsy.gse.uni-magdeburg.de/debian/dists/intrepid/Release',
            'http://apsy.gse.uni-magdeburg.de/debian/dists/etch/Release',
            'http://apsy.gse.uni-magdeburg.de/debian/dists/lenny/Release',
            'http://apsy.gse.uni-magdeburg.de/debian/dists/squeeze/Release',
            'http://apsy.gse.uni-magdeburg.de/debian/dists/sid/Release',
            ]

taskfiles = [
  'svn://svn.debian.org/blends/projects/med/trunk/debian-med/tasks/imaging',
  'svn://svn.debian.org/blends/projects/med/trunk/debian-med/tasks/imaging-dev',
  'svn://svn.debian.org/blends/projects/science/trunk/debian-science/tasks/neuroscience-cognitive',
            ]

dpa.setPkgFilterFromTaskFile(taskfiles)
dpa.pkgfilter += ['fsl-doc', 'fslview-doc', 'fsl-atlases', 'fsl-possum-data',
                  'fsl-first-data', 'fsl-feeds']

dpa.importProspectivePkgsFromTaskFile(taskfiles[0])

for rurl in release_urls:
    dpa.importRelease(rurl, force_update=False)

dpa.save('db.db')

dpa.writeSourcesLists()

writeRst(dpa)
writePkgsBy(dpa, 'maintainer', maintainer2email)


