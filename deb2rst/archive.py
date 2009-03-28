import urllib
import apt_pkg as ap
import apt
from ConfigParser import SafeConfigParser
import gzip
import subprocess

class DebianPkgArchive(SafeConfigParser):
    """
    """
    def __init__(self, dists):
        """
        :Parameter:
          dists: list
            List of Release file URLs, one for each distribution in the archive.
        """
        SafeConfigParser.__init__(self)

        for dist in dists:
            filename, ignored = urllib.urlretrieve(dist)
            baseurl = '/'.join(dist.split('/')[:-1])
            self._parseDistribution(filename, baseurl)
            urllib.urlcleanup()


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


    def _parseDistribution(self, rfile, baseurl):
        """
        :Parameter:
          rfile: filename
            Release file for the distribution
          baseurl: str
            Base URL of this distribution. This path contains the Release file.
        """
        # create parser instance
        rparser = ap.ParseTagFile(open(rfile, 'r'))
        # get release section content
        rparser.Step()

        # architectures on this dist
        archs = rparser.Section['Architectures'].split()
        components = rparser.Section['Components'].split()
        codename = rparser.Section['Codename']

        # compile the list of Packages files to parse and parse them
        for c in components:
            for a in archs:
                # compile URL
                pkgsurl = '/'.join([baseurl, c, 'binary-' + a, 'Packages.gz'])
                # retrieve
                filename, ignored = urllib.urlretrieve(pkgsurl)
                # decompress
                subprocess.call(['gzip', '-d', filename])
                # parse
                self._parsePkgsFile(filename[:-3], codename, c)
            break


    def _parsePkgsFile(self, pfile, codename, component):
        """
        :Parameters:
          pfile: Packages filename
          codename: str
            Codename of the release
          component: str
            The archive component this packages file corresponds to.
        """
        pp = ap.ParseTagFile(open(pfile, 'r'))

        while pp.Step():
            sec = pp.Section
            self._storePkg(sec, codename, component)


    def _storePkg(self, psec, codename, component):
        """
        :Parameter:
          psec: apt_pkg parser section
        """
        pkg = psec['Package']

        if not self.has_section(pkg):
            self.add_section(pkg)

        # which releases
        self.appendUniqueCSV(pkg, "releases", codename)

        # arch listing
        self.appendUniqueCSV(pkg, "archs %s" % codename, psec['Architecture'])

        # versions
        self.ensureUnique(pkg,
                          "version %s %s" % (codename, psec['Architecture']),
                          psec['Version'])

        # now the stuff where a single variant is sufficient and where we go for
        # the latest available one
        if self.has_option(pkg, "newest version") \
            and apt.VersionCompare(psec['Version'],
                                   self.get(pkg, "newest version")) < 0:
            return

        # everything from here will overwrite existing ones

        # we seems to have an updated package
        self.set(pkg, "newest version", psec['Version'])

        # description
        self.set(pkg, "description", psec['Description'])

        # optional stuff
        if psec.has_key('Homepage'):
            self.set(pkg, 'homepage', psec['Homepage'])


def genPkgPage(db, pkg):
    """
    :Parameters:
      db: database
      pkg: str
        Package name
    """
    pass



dpa = DebianPkgArchive(
        [
            'http://elrond/debian/dists/dapper/Release',
#            'http://elrond/debian/dists/etch/Release',
        ])
print dpa
