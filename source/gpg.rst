.. _gpg_signatures:


Package authentication
======================


When you start using this repository, you might get warning messages like this::

  The following signatures couldn't be verified because 
  the public key is not available.`

Or you will be asked questions like this over and over::

  WARNING: The following packages cannot be authenticated!
  ...
  Install these packages without verification [y/N]?

This is because your APT installation does not know the GPG key that is used to
sign the release files of this repository. Making APT happy again is easy:

1. Get the key. Either download the `repository key from here
   <http://apsy.gse.uni-magdeburg.de/debian/apsy.gse.uni-magdeburg.de.asc>`_
   or fetch it from *subkeys.pgp.net*.

2. Now feed the key into APT by invoking::

     apt-key add #file#

   Where `#file#` has to be replaced with the location of the key file you just
   downloaded. You need to have superuser-privileges to do this (either do it
   as root or use sudo).

