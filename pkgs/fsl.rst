Packages for the complete FSL suite
===================================

Since FSL covers a very broad range of analysis techniques the suite is split
into a number of separate packages to allow a more fine-grained selection of
the functionality provided by FSL. The following related packages are available:

:ref:`pkg_fsl`
  This packages provides the FSL binaries. This includes everything one needs
  to run a basic fMRI analysis. However, it is recommend to also at least
  install the :ref:`fsl-atlases <pkg_fsl-atlases>` package.

:ref:`pkg_fslview`
  Almost everybody should install this package.

:ref:`pkg_fsl-doc`
  Contains the FSL documentation in HTML format as included in the official FSL
  sources. This package should be installed to use the online help capabilities
  of FSL.

:ref:`pkg_fslview-doc`
  The FSLView documentation in HTML format. This package is necessary for the
  online help system of FSLView.

:ref:`pkg_fsl-atlases`
  Contains the standard space brain templates and brain atlases. Almost
  everybody should install this package.

:ref:`pkg_fsl-possum-data`
  This package provides the templates for the MR sequence simulator POSSUM.
  If one does not use POSSUM this package is not necessary.

:ref:`pkg_fsl-first-data`
  This package provides model data for FIRST subcortical brain segmentation.
  This package is almost 1GB! It is only required if one wants to use FIRST
  or run the FSL FEEDS suite.

:ref:`pkg_fsl-feeds`
  This package provides the `FSL Evaluation and Example Data Suite`_. This
  package performs two functions -- it tests whether the FSL tools are working
  properly and it provides example data to try running FSL on. Additionally the
  :command:`fsl-selftest` command is avaliable. This is a little script that
  runs all tests (or a selected one) in a temporary directory and reports the
  results. A manpage is included. This package can be used to perform
  `FSL benchmarks`_.

.. _FSL Evaluation and Example Data Suite: http://www.fmrib.ox.ac.uk/fsl/fsl/feeds.html


Report bugs
===========

If you discover any bugs please report them. The best way to get quick and
professional help is to post to the `FSL mailing list`_. If you send a
bugreport please include detailed information about the problem. This should at
least be a description how the bug can be reproduced as well as information
concerning you environment (for example the operation system). You might also
want to have a look at the mailing list archive whether the problem has been
discovered before.

.. _FSL mailing list: http://www.jiscmail.ac.uk/lists/fsl.html

If you use the package on a Debian system (not Ubuntu) you can simply use the
:command:`reportbug` tool to send a bug report to the `Debian bug tracking
system`_. The bug tracker provides a public list of all reported `bugs of FSL`_
and `bugs of FSLView`_

.. _bugs of FSL: http://bugs.debian.org/src:fsl
.. _bugs of FSLVIEW: http://bugs.debian.org/src:fslview
.. _Debian bug tracking system: http://bugs.debian.org


Additional information
======================

Since December 2007 the FSL package is officially part of the non-free
section of Debian. The latest package version will always be available
from http://packages.debian.org/sid/fsl in the Debian archive.
However, this only applies to the packages of the FSL and FSLView
binaries. FSL data packages (first, possum, atlases and feeds) are not
yet official Debian packages and will be available from here, as well
as backports for Debian and recent Ubuntu releases.

.. note::

  Please be sure to `read the information`_ about the differences
  between the Debian packaging and the official FSL releases.

.. _read the information: http://git.debian.org/?p=pkg-exppsy/fsl.git;a=blob_plain;f=debian/README.Debian;hb=HEAD


Usage information
-----------------

FSL requires a config file to be sourced before it can be used. For the Debian
packages this config file is in `/etc/fsl/fsl.sh`. Open a terminal where you
want to start FSL and source it like this::

  . /etc/fsl/fsl.sh

Note the dot at the beginning. If you want to have this done automatically, you
could add those line to e.g. your `$HOME/.bashrc` file (or a corresponding
config file of another POSIX-compatible shell). Once you have done that, you
can start using FSL.



Upgrading from FSL 3.x
----------------------

The FSL configuration file has changed significantly. Please be sure to
(re)source it.

.. note::

  There seem to be some remaining incompatibilities of FSL scripts with the
  *dash* shell. This is the default shell on Ubuntu systems. If you discover any
  problems, please make sure to read `a related posting on the FSL mailing
  list`_.

.. _a related posting on the FSL mailing list: http://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=ind0709&L=fsl&T=0&F=&S=&P=19638


Building binary packages yourself
---------------------------------

If no binary packages for your distribution/platform are available, you can
still build your own. All you need to do is to add this line to your
`/etc/apt/sources.list`::

  deb-src http://apsy.gse.uni-magdeburg.de/debian #distro# main non-free

Choose the value of `#distro#` like described in the binary package section. Be
sure to update your package list after that (Remember: :command:`aptitude
update`). To build FSL packages, do this (no superuser privileges required,
but you might have to install `apt-src` first)::

  apt-src install fsl
  apt-src build fsl

Be patient as this will take some time. All packages will be created in the
directory where the commands are executed. Please note, that you might need to
download or even compile other packages that FSL depends on.

If you are done, you can install the packages with::

  dpkg -i fsl*.deb

After you have repeated this procedure for the `fslview` source package, you
should be ready to use FSL.

Advanced: Arch-dependend compiler flags
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you have some experience with compiler flags and you also care for speed,
you might want to have the FSL binaries optimized for every detail of your
platform. To take advantage of all special features of your favorite processor
you can specify custom compiler flags that are used when building binary
packages from the source package of FSL. To achieve this, simply define them in
a variable called :envvar:`DEB_ARCH_OPT_FLAGS` in the environment. In its
simplest form, building an optimized package could be done like this::

  DEB_ARCH_OPT_FLAGS="-march=opteron" apt-src build fsl

Note that not all flags are available with every compiler. The above example
does not work with the standard compiler of Debian sarge (gcc 3.3) and you
obviously need an AMD Opteron processor.


FSL benchmarks
--------------

Here is a list of some benchmarking results that demonstrate how fast FSL runs
on several different platforms and distributions. The :command:`fsl-feeds`
package is used for benchmarking FSL. The listed time for a complete
fsl-selftest run is the user time as reported by :command:`time -p`. If you are
also interested in benchmarking results of the non-Debian FSL distribution, you
can visit the `FSL-FEEDS timing website`_.

.. _FSL-FEEDS timing website: http://www.fmrib.ox.ac.uk/fsl/feeds/doc/timings.html

+------------+---------------+------+------+---------+------------------+--------+----+--------------+
|Distribution|CPU            |Arch. |Memory|Compiler |Flags             |Version |Time|Submitted     |
+============+===============+======+======+=========+==================+========+====+==============+
|Ubuntu      |Intel Core i7  |x86_64|12GB  |gcc 4.3  |                  |4.1.3-1 |1236| Jiří Keller  |
|jaunty      |8 cores 3.4 Ghz|      |      |         |                  |        |    |              |
+------------+---------------+------+------+---------+------------------+--------+----+--------------+
|Ubuntu      |Intel Core 2   |x86_64|4GB   |gcc 4.1.2|                  |4.0.2-1 |1377| Jiří Keller  |
|gutsy       |Quad Q6700 3Ghz|      |      |         |                  |        |    |              |
+------------+---------------+------+------+---------+------------------+--------+----+--------------+
|Debian sid  |2x Dual Opteron|amd64 |12GB  |gcc 4.1.1|                  |3.3.7-2 |1560|Yaroslav      |
|            |275 2.2 Ghz    |      |      |         |                  |        |    |Halchenko     |
+------------+---------------+------+------+---------+------------------+--------+----+--------------+
|Ubuntu edgy |2x Dual Opteron|i686  |3GB   |gcc 4.1.2|                  |3.3.8-1 |2096|Jeff          |
|            |275 2.2 GHz    |      |      |         |                  |        |    |Stevenson     |
+------------+---------------+------+------+---------+------------------+--------+----+--------------+
|Debian lenny|Intel Core2    |i686  |2GB   |gcc 4.3.1|                  |4.1.0-1 |2108|Michael       |
|            |E8400 3Ghz     |      |      |         |                  |        |    |Hanke         |
+------------+---------------+------+------+---------+------------------+--------+----+--------------+
|Debian etch |Quad Opteron   |amd64 |32GB  |gcc 3.4.6|-O3 -m64          |3.2b-4  |2152|Antti         |
|            |850 2.4 GHz    |      |      |         |-march=opteron    |        |    |Korvenoja     |
|            |               |      |      |         |-mfpmath=sse      |        |    |              |
|            |               |      |      |         |-msse2            |        |    |              |
|            |               |      |      |         |-ffast-math       |        |    |              |
|            |               |      |      |         |-funroll-all-loops|        |    |              |
|            |               |      |      |         |-fpeel-loops      |        |    |              |
|            |               |      |      |         |-ftracer          |        |    |              |
|            |               |      |      |         |-funswitch-loops  |        |    |              |
|            |               |      |      |         |-funit-at-a-time  |        |    |              |
+------------+---------------+------+------+---------+------------------+--------+----+--------------+
|Debian lenny|Athlon X2      |amd64 |4GB   |gcc 4.3  |                  |4.0.4-1 |2268|Petr          |
|            |4800 2.5 GHz   |      |      |         |                  |        |    |Hluštík       |
+------------+---------------+------+------+---------+------------------+--------+----+--------------+
|Ubuntu      |Quad Core2     |amd64 |4GB   |gcc 4.1  |                  |4.0-1   |2500|Vincent       |
|feisty      |2.4 GHz        |      |      |         |                  |        |    |Ferrera       |
+------------+---------------+------+------+---------+------------------+--------+----+--------------+
|Debian etch |Quad Opteron   |amd64 |32GB  |gcc 4.0.2|-O3 -m64          |3.2b-4  |2619|Antti         |
|            |850 2.4 GHz    |      |      |         |-march=opteron    |        |    |Korvenoja     |
|            |               |      |      |         |-mfpmath=sse      |        |    |              |
|            |               |      |      |         |-msse2            |        |    |              |
|            |               |      |      |         |-ffast-math       |        |    |              |
|            |               |      |      |         |-funroll-all-loops|        |    |              |
|            |               |      |      |         |-fpeel-loops      |        |    |              |
|            |               |      |      |         |-ftracer          |        |    |              |
|            |               |      |      |         |-funswitch-loops  |        |    |              |
|            |               |      |      |         |-funit-at-a-time  |        |    |              |
+------------+---------------+------+------+---------+------------------+--------+----+--------------+
|Debian etch |Quad Opteron   |amd64 |32GB  |gcc 4.0.2|-O3               |3.2b-4  |2652|Antti         |
|            |850 2.4 GHz    |      |      |         |                  |        |    |Korvenoja     |
+------------+---------------+------+------+---------+------------------+--------+----+--------------+
|Debian etch |2x Opteron     |amd64 |12GB  |gcc 4.1.2|                  |4.0.2-3 |2847|Michael       |
|            |270 2.2 GHz    |      |      |         |                  |        |    |Hanke         |
+------------+---------------+------+------+---------+------------------+--------+----+--------------+
|Ubuntu gutsy|Athlon 64X2    |amd64 |2GB   |gcc 4.1.3|                  |4.0.1   |3605|Nicholas P.   |
|            |5200+ 2.6 GHz  |      |      |         |                  |        |    |Holmes        |
+------------+---------------+------+------+---------+------------------+--------+----+--------------+

.. Template
 |            |               |      |      |         |                  |        |    |              |
 |            |               |      |      |         |                  |        |    |              |
 +------------+---------------+------+------+---------+------------------+--------+----+--------------+


If you want to have your system included in this list, please send an email
with the logfile of the benchmark. You can run the benchmark (and create the
logfile) by running (fsl-feeds-3.2beta-3 or higher is required)::

  (time -p fsl-selftest -c) > benchmark.log 2>&1

And include the following information in your message:

* Which distribution are you using?

* CPU-type (as specific as possible)

* How much physical memory has the machine? If you don't know this, send the
  output of::

    free | head -n2 | tail -n1 | awk '{print $2}' -

* If you compiled the binary packages yourself, which compiler did you use?
  (hint: `gcc --version`)

* Which custom compiler flags did you use when building the package (if any)?

* Which version of the Debian FSL package was used?
