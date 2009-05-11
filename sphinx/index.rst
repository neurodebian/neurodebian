***********************************************
 Welcome to the Debian Neuroscience Repository
***********************************************

This repository provides mostly neuroscience-related packages to be
used on Debian systems (or a Debian-derivates like Ubuntu). It
contains both unofficial or prospective packages which are not
available from the main Debian archive, as well backported or simply
rebuilt packages also available elsewhere.

This service is provided "as is". There is no guarantee that a package
works as expected, so use them at your own risk. They might kill your
system (although that is rather unlikely). You've been warned!

The repository contains both neuroscience-related packages as well as
general purpose software which is necessary to resolved dependencies, or
is simply useful in the neuroscience context. The featured neuroscience
software can be browsed via the repository :ref:`genindex` or through the
:ref:`maintainer view <bymaintainer>`.

All other packages are available from the :ref:`full package list
<full_pkg_list>`.


News
====

Due to scheduled maintenance work on the electrical grid the repository hosted
at `apsy.gse.uni.magdeburg.de/debian` will be down on May 16 (and possibly
May 17).


.. _repository_howto:

How to use this repository
==========================

The easiest way to use this repository is to download an APT-configuration
file. Simply click on the name of your target distribution/release and save the
downloaded file in the `/etc/apt/sources.list.d/` directory on your system
(depending on the browser, you might have to right-click and choose 'save as').
Saving files in this directory will require superuser privileges, therefore you
should probably download the file into a temporary directory and subsequently
move it into `/etc/apt/sources.list.d/`. APT-configurations are available for
the following releases:

.. include:: sources_lists

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

When you start using this repository, you might get warning messages
like this::

  The following signatures couldn't be verified because 
  the public key is not available.`

Or you will be asked questions like this over and over::

  WARNING: The following packages cannot be authenticated!
  ...
  Install these packages without verification [y/N]?

This is because your APT installation initially does not know the GPG
key that is used to sign the release files of this repository. Making
APT happy again is easy:

1. Get the key. Either download the `repository key from here
   <http://apsy.gse.uni-magdeburg.de/debian/apsy.gse.uni-magdeburg.de.asc>`_
   or fetch it from *subkeys.pgp.net*.

2. Now feed the key into APT by invoking::

     apt-key add #file#

   Where `#file#` has to be replaced with the location of the key file you just
   downloaded. You need to have superuser-privileges to do this (either do it
   as root or use sudo).
