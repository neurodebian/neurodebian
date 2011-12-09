:date: 2011-12-09 16:08:00
:tags: debian, neuroscience, software, FSL, fslview, chroot, virtualization

.. _chap_schroot_fslview:

"Install" fslview on recent systems
===================================

Preamble
--------

Sometimes research software projects start to lag behind recent
developments in the libraries they rely upon because it might require
considerable effort, and thus time, to adapt them.  That leads to
inability to build those tools using up-to-date versions of libraries
available on the system due to the change in their API, and thus those
tools get removed from the archive.

That is the situation which happened with fslview_ tool from FSL_
suite.  At the moment it still relies on Qt library version 3 and VTK
GUI support for it.

.. note::

   Last version of Qt3, 3.3.8, was released in February 2007, with
   official support by Trolltech terminated later that year.

   Qt4 was first released in 2005, and current stable series 4.7
   released appeared in September 2010).

Because of the age and discontinued upstream support, Qt3 was
deprecated in Debian, and tools relying on it were encouraged to
migrate to use Qt4.  As a result, although Qt3 itself is still present
in Debian (and thus Ubuntu), VTK GUI support for Qt3 (package
`libvtk5.4-qt3`_) which fslview uses, was removed from Debian due to
Qt3 deprecation.  Once again, it was not removed just to annoy people,
but rather because it became unfeasible to maintain robust building
and system functioning.  As the result, fslview_ package is currently
present only in the releases of Debian and Ubuntu which carry
libvtk5.4-qt3 library.  Those are -- Debian squeeze (stable), Ubuntu
nutty and maverick.  If you upgraded your system from one of those
releases, good chance is that you still have fslview (and required
libraries) installed although not available from the archive.  They
might even work.  But fresh systems installations will not have them.

.. _`libvtk5.4-qt3`: http://packages.debian.org/search?keywords=libvtk5.4-qt3

Workaround
----------

While everyone is waiting for fslview_ to become compatible with Qt4
there are possible workarounds meanwhile to keep research going on
bleeding edge releases.  The first, obvious choice for a FOSS
enthusiast, is to build fslview_ from source by first building VTK Qt3
bindings.  While it might be educationally valuable and exciting, we
are afraid in the end it might be more frustrating than useful.

Therefore we would like to suggest another, much more straightforward
and painless approach -- lightweight virtualization, or chroot_
jailing.  In this exercise in **4 simple steps** we will install a
complete (minimalistic) installation of Debian stable which has
fslview available into a directory, and provide convenience wrapper to
run fslview as it was installed on the "main" system.  Moreover, in
case of security or critical fixes to fslview, such chroot
environment, while being Debian installation, would be upgradeable as
easily as your main system, thus guaranteeing robust performance.

Although demonstrated here on the example with fslview, such approach
is generally useful for various use cases.  E.g. we have used it in
the opposite situation -- on stable Debian systems we needed to run
some software available only from Debian unstable or testing, and
backporting of all required dependencies was either cumbersome or just
impossible without sacrificing stability of the system.

.. _chroot: http://en.wikipedia.org/wiki/Chroot
.. _fslview: http://www.fmrib.ox.ac.uk/fsl/fslview
.. _FSL: http://www.fmrib.ox.ac.uk/fsl


Prerequisites
-------------

For this exercise you would need

- 3--20 minutes depending on the bandwidth to the Debian mirror and
  efficiency in cut/paste operations

- root access to the system while performing this setup, although
  end-users of fslview would not need it to use it

- tools to install Debian in a directory (called debootstrap_) and
  convenience utility to "enable" such a chroot-ed environment (called
  schroot_)

.. _debootstrap: http://wiki.debian.org/Debootstrap
.. _schroot: http://packages.debian.org/sid/schroot


Procedure
---------

- Install the tools::

   sudo apt-get install debootstrap schroot

- Choose a location with enough space (around 400 MB) and install a
  complete Debian squeeze installation with fslview::

   sudo debootstrap --include=fslview squeeze /srv/chroots/squeeze http://ftp.us.debian.org/debian

  .. note::
     You might like to adjust URL to the archive to use some closer
     closer to you `Debian mirror`_

.. _`Debian mirror`: http://www.debian.org/mirror/list

- Create schroot_ configuration file ``/etc/schroot/chroot.d/squeeze``
  with following content::

   [squeeze]
   description=Debian squeeze (6.x stable)
   type=directory
   location=/srv/chroots/squeeze
   users=YOURLOGIN
   aliases=debian,default

  Replace YOURLOGIN with a comma separated list of users who should be
  allowed to access this chroot environment (see ``man schroot.conf``
  for more options, e.g. how to specify the groups etc.)

- At this point you should already be ready to invoke any command
  within the chroot environment, so just create a little shell script
  ``/usr/local/bin/fslview``, make it executable and be all set::

   echo -e '#!/bin/sh\nschroot -p -c squeeze /usr/bin/fslview' > /usr/local/bin/fslview
   chmod a+x /usr/local/bin/fslview

  .. note::
     You might need to become root for above operations, or not
     depending either you are a part of ``staff`` user group.

Optional steps
--------------

Although at this point you are all set to run fslview from the
chroot-ed environment, we would suggest a few additional steps you
would need to perform within the chroot-ed environment, so just enter
it with using ``schroot -c squeeze -p``, become root (via ``su``
command, root password should be the same as on the main system):

- `Enable NeuroDebian repository <http://neuro.debian.net/#how-to-use-this-repository>`_

- Enable security and functionality updates::

  	sed -e 's,squeeze,squeeze-updates,g' /etc/apt/sources.list > /etc/apt/sources.list.d/updates.list
    echo 'deb http://security.debian.org/ stable/updates main' > /etc/apt/sources.list.d/security.list
	apt-get update
	apt-get upgrade

- Read ``man schroot`` on how to enable persistent sessions so that
  chroot initiation could be done ones during boot instead of per each
  fslview invocation

If you have any comments (typos, improvements, etc) -- feel welcome to
leave a comment below, or just email `us@NeuroDebian`_ .

.. _us@NeuroDebian: http://neuro.debian.net/#contacts
