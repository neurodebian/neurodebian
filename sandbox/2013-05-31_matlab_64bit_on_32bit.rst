:date: 2012-05-31 22:16:00
:tags: debian, neuroscience, software, matlab, multiarch, 

.. _chap_matlab_64bit_on_32bit:


Running 64bit Matlab on 32bit host OS
=====================================

Some of you have experienced problems due the recent move of Mathworks to
drop 32-bit Linux builds of their products (i.e. Matlab R2013a and
co.). Please note that this is not the first time Mathworks values its own
costs higher than the benefits of a few scientists.  In 1998 PowerPC builds
for Macs were abandoned, causing a `furious reaction
<http://www.mathworks.com/matlabcentral/newsreader/view_thread/5910>`__
of the community.

Luckily, users of the fresh Debian stable release *wheezy* (or more recent
variants of Debian and its derivatives) who still need a 32bit OS on
64bit-capable hardware can take advantage of the new `multiarch
<http://wiki.debian.org/Multiarch>`_ support.  Multiarch allows for
multiple architecturesi to co-exist on a hardware/kernel
that is capable of supporting both (e.g. i386 and amd64).

Below we describe how you can use multiarch support and in few simple steps
that prepare your existing 32bit user-land for running 64bit Matlab.


Procedure
---------

- [2-10 min] Install 64-bit kernel and reboot::

   sudo apt-get install linux-image-amd64

- [1-3 min] Enable multi-arch support for amd64 architecture::

   sudo dpkg --add-architecture amd64
   sudo apt-get update

- [1-5 min] Install 64bit libraries needed for matlab::

   sudo apt-get install libstdc++6:amd64 zlib1g:amd64 libncurses5:amd64 \
     libxp6:amd64 libstdc++6-4.4-dev:amd64 libxt6:amd64 libxmu6:amd64 libxtst6:amd64

Now your 64bit matlab (which you hopefully "registered" with
:ref:`matlab-support <binary_pkg_matlab-support>`) is ready to run.

If you have any comments (typos, improvements, etc) -- feel welcome to
leave a comment below, or `contact us`_ .

.. _contact us: http://neuro.debian.net/#contacts
