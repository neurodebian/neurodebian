:date: 2011-12-12 12:05:00
:tags: debian, neuroscience, development, packages, virtualization

.. _chap_ndtools_build:

NeuroDebian nd* tools
=====================

TODO

Procedure
---------

- [1-20 min] :ref:`Install NeuroDebian VM <chap_vm>`

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

At this point you would be all set to build packages for all
distributions in a single command.  E.g.::

   sudo nd_build4all blah_1-1.dsc

should take the .dsc file you provide, and build it for main Debian
sid and all ND-supported releases of Debian and Ubuntu.
nd_build4allnd would build only for the later omitting the vanilla
Debian sid.  The highlevel summary either builds succeed or failed get
reported in ``summary.log`` in the same directory, pointing to
``.build`` log files for the corresponding architecture/release.


Troubleshooting Failing Build
-----------------------------

Provide --hookdir cmdline pbuilder argument to point to a hook which
would get kicked in by pbuilder upon failure, e.g.:

   sudo apt-get install git
   git clone https://github.com/neurodebian/neurodebian
   sudo nd_build4debianmain *.dsc -- --hookdir $PWD/neurodebian/tools/hooks


If you have any comments (typos, improvements, etc) -- feel welcome to
leave a comment below, or just email `us@NeuroDebian`_ .

.. _us@NeuroDebian: http://neuro.debian.net/#contacts
