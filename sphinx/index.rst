.. _welcome:

***********************************************
 Welcome to the Debian Neuroscience Repository
***********************************************

This repository provides mostly neuroscience-related packages to be used on
Debian_ systems (or Debian-derivatives like Ubuntu_). It contains both unofficial
or prospective packages which are not (yet) available from the main Debian_
archive, as well as backported or simply rebuilt packages also available
elsewhere. Please see the :ref:`faq` for more information about the goals of
this project.

This service is provided "as is". There is no guarantee that a package
works as expected, so use them at your own risk. If you encounter problems,
please `report <#contact>`_ them.

Please |spread|, if you like it.

.. raw:: html

 <p>
 <a href="pkgs.html"><img border="0" src="_static/package.png" title="List of available packages" /></a>
 <a href="vm.html"><img border="0" src="_static/machine.png" title="Get NeuroDebian for your non-Debian computer" /></a>
 <a href="debian/pool"><img border="0" src="_static/pool.png" title="Go to the package pool (deep and cold, only for experts)" /></a>
 </p>

.. _Ubuntu: http://www.ubuntu.com

News
====

.. raw:: html

 <script src="http://widgets.twimg.com/j/2/widget.js"></script>
 <script>
 new TWTR.Widget({
   version: 2,
   type: 'profile',
   rpp: 10,
   interval: 6000,
   width: 'auto',
   height: 150,
   theme: {
     shell: {
       background: '#898989',
       color: '#ffffff'
     },
     tweets: {
       background: '#ffffff',
       color: '#000000',
       links: '#82032f'
     }
   },
   features: {
     scrollbar: true,
     loop: false,
     live: false,
     hashtags: true,
     timestamp: true,
     avatars: false,
     behavior: 'all'
   }
 }).render().setUser('NeuroDebian').start();
 </script>

Follow us on twitter_ to subscribe to the NeuroDebian news.

.. _twitter: http://twitter.com/NeuroDebian

.. _repository_howto:



How to use this repository
==========================

The easiest way to use this repository is to download an APT-configuration file
(`sources.list`). Simply choose your target distribution/release and download
the configuration for a mirror close to you (depending on your browser, you
might have to right-click and choose 'save as'). Once downloaded, put the file
in the `/etc/apt/sources.list.d/` directory on your system. Moving files in
this directory will require superuser privileges, therefore you should probably
download the file into a temporary directory and subsequently move it into
`/etc/apt/sources.list.d/`. APT-configurations are available for the following
releases and repository mirrors:

.. include:: sources_lists

.. note::
  Thanks to the `Department of Experimental Psychology at the University of
  Magdeburg`_, and the `Department of Psychological and Brain Sciences at Dartmouth
  College`_ for hosting a mirror.

  If your are interested in mirroring the repository, please see the :ref:`faq`.

.. _Department of Experimental Psychology at the University of Magdeburg: http://apsy.gse.uni-magdeburg.de
.. _Department of Psychological and Brain Sciences at Dartmouth College: http://www.dartmouth.edu/~psych

Once this is done, you have to update the package index. Use your favorite
package manager, e.g. synaptic, adept, or whatever you like. In the terminal
you can use :command:`aptitude` to achieve the same::

  sudo aptitude update

Now, you can proceed to install packages, e.g.::

  sudo aptitude install lipsia

.. note::
  Not every package is available for all distributions/releases. For information
  about which package version is available for which release and architecture,
  please have a look at the corresponding package pages.


Package authentication
----------------------

When you start using this repository, you probably get warning messages
like this::

  The following signatures couldn't be verified because 
  the public key is not available.`

Or you will be asked questions like this over and over::

  WARNING: The following packages cannot be authenticated!
  ...
  Install these packages without verification [y/N]?

This is because your APT installation initially does not know the GPG
key that is used to sign the release files of this repository. It is easy to
make APT happy again:

1. Get the key. Either download the `repository key from here
   <_static/neuro.debian.net.asc>`_
   or fetch it from http://wwwkeys.pgp.net (2649A5A9).

2. Now feed the key into APT by invoking::

     apt-key add #file#

   Where `#file#` has to be replaced with the location of the key file you just
   downloaded. You need to have superuser-privileges to do this (either do it
   as root or use sudo).


.. _chap_installation:

Installation
============

Virtual Machine
---------------

If you are not running Debian_ on a particular machine a :ref:`chap_vm` is
provided as a convenient testing and evaluation environment.  After a few
simple steps to setup the virtual machine, you will be able to use NeuroDebian_
as an integral part of your existing working environment without any sacrifice.
The virtual machine is also a suitable environment to temporarily deploy
neuroscience software on machines running other operating systems, e.g. for the
purpose of teaching a neuroimaging data analysis course in a multipurpose
computer lab.


Debian
------

Having been exposed to the wonders of NeuroDebian_ you are no longer
satisfied with your previous choice of operating system?  We would
recommend installing Debian_ to replace or complement (dual-boot) your
existing OS.  Please visit `"Getting Debian"
<http://www.debian.org/distrib/>`_ to obtain the images for your
hardware architecture and then simply add |repos|.


.. _chap_team:


The Team
========

Our main goal is to provide neuroscience FOSS_ for Debian_. Thus the
whole project would not be possible without the work of over 3,000
Debian_ developers and contributors who are as enthusiastically pursuing
a similar goal.  To add our share -- Debian_ packages of FOSS_ for
neuroscience research -- the `Experimental Psychology Debian packaging
project <http://alioth.debian.org/projects/pkg-exppsy>`_ was created
to formally join the forces of

* `Michael Hanke <http://mih.voxindeserto.de>`_
* `Yaroslav Halchenko <http://www.onerussian.com>`_

A number of packages that are now available from the NeuroDebian repository
were not packaged by our team, but similar Debian teams.  Therefore we want to
express particular gratitude to the `Debian Med`_ and `Debian Science`_ teams
for all their work.

.. _FOSS: http://en.wikipedia.org/wiki/Free_and_open_source_software


Contact
=======

`Email us <team@neuro.debian.net>`_ if you have any suggestions or want to
report a problem.

.. toctree::
   :hidden:

   faq
   pkgs
   spread
   vm
   links_names
   substitutions

.. probably should be purged altogether
.. toctree::
   :hidden:

   livecd
   gpg
   setup

.. include:: links_names.rst
.. include:: substitutions.rst
