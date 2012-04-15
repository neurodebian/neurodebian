:date: 2012-04-14 22:05:00
:tags: debian, neuroscience, software, development, packages, virtualization

.. _chap_ndtools_build:

NeuroDebian nd* tools
=====================

One of the goals of NeuroDebian_ is to provide recent versions of
scientific software on stable Debian (and Ubuntu) deployments.  That
is why we build (whenever possible) every new package not only for the
Debian unstable (the entry point of packages into Debian) but also for
Debian testing and stable, and Ubuntu releases.  To automate such
procedure we prepared few rudimentary wrappers around cowbuilder_
allowing to build packages in isolated environment.  Also we provide a
backport-dsc_ script to ease backporting with optional application
per-release patchsets.  In this blog post we would like to introduce
you to these tools.  They will be of use for anyone working on a
package intended to be uploaded to NeuroDebian_ repository.  With a
single command you will be able to build a given Debian source package
across distributions.  As a result it verifies that there are no
outstanding backport-ability issues or compatibility problems with
core components (e.g. supported versions of Python) if your source
package excercises test suites at build time.

.. _cowbuilder: http://packages.debian.org/sid/cowbuilder
.. _NeuroDebian: http://neuro.debian.net
.. _backport-dsc: https://github.com/neurodebian/neurodebian/blob/master/tools/backport-dsc


Procedure
---------

- [1-20 min] If you are not running Debian-based distribution,
  :ref:`Install NeuroDebian VM <chap_vm>`; otherwise just :ref:`add apt
  sources for NeuroDebian repository <repository_howto>`.

- [<1 min] Install the neurodebian-dev package providing nd* tools::

   sudo apt-get install neurodebian-dev

- [1-5 min] Adjust default configuration (``sudo vim
  /etc/neurodebian/cmdsettings.sh``) used by nd commands to

  - point ``cowbuilderroot`` variable to some directory under
    ``brain`` account, e.g. ``~brain/debs`` (should be created by you)

  - remove undesired releases (e.g. deprecated ``karmic``) from
    allnddist and alldist

  - adjust ``mirror`` entries to use the `Debian mirror`_ and `Ubuntu
    mirror`_ of your choice or may be even point to your `approx
    <http://packages.debian.org/sid/approx>`_ apt-caching server

.. _`Debian mirror`: http://www.debian.org/mirror/list
.. _`Ubuntu mirror`: https://launchpad.net/ubuntu/+archivemirrors

- [10-60 min] Create the COWs for all releases you left in the
  configuration file::

  	sudo nd_adddistall


Building
--------

At this point you should be all set to build packages for all
distributions with a single command.  E.g.::

   sudo nd_build4all blah_1-1.dsc

should take the .dsc file you provide, and build it for main Debian
sid and all ND-supported releases of Debian and Ubuntu.
``nd_build4allnd`` would build only for the later omitting the vanilla
Debian sid.  The highlevel summary either builds succeed or failed get
reported in ``summary.log`` in the same directory, pointing to
``.build`` log files for the corresponding architecture/release.


Troubleshooting Failing Build
-----------------------------

Provide ``--hookdir`` cmdline pbuilder argument to point to a hook
which would get kicked in by pbuilder upon failure, e.g.:

   sudo apt-get install git
   git clone https://github.com/neurodebian/neurodebian
   sudo nd_build4debianmain *.dsc -- --hookdir $PWD/neurodebian/tools/hooks


If you have any comments (typos, improvements, etc) -- feel welcome to
leave a comment below, or `contact us`_ .

.. _contact us: http://neuro.debian.net/#contacts
