The packages are available through an APT repository You can either browse the
archive or add this line to your `/etc/apt/sources.list`::

  deb http://apsy.gse.uni-magdeburg.de/debian #distro# #section#

Replace `#distro#` with ..., depending on which distribution you are using.
Note that not every package is available for all distributions. You need to
replace #section# with the value(s) corresponding to the package(s) you are
interested in (get it from the table below). Multiple sections are allowed.
Please, do not forget to update your package index, e.g. by running apt-get
update.  If no binary packages are available for your distribution, you can
still download the source packages. Simply add this to your
`/etc/apt/sources.list` (you have to replace #distro# and #section# as
described above)::

  deb-src http://apsy.gse.uni-magdeburg.de/debian #distro# #section#

After the usual apt-get update you can get and build the packages with e.g.
apt-src or whatever you like. To build e.g. dicomnifti you can do this: apt-src
install dicomnifti

This downloads the sources and installs all build-dependencies if necessary.
You need root-privileges to install the build-dependencies, so apt-src might
ask for a password. Now invoke: apt-src build dicomnifti

This will build all binary packages which should appear in the current
directory (if everything worked well). You can now install the packages with
dpkg.



