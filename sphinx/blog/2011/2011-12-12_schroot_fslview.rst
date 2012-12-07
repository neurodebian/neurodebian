:date: 2011-12-12 12:05:00
:tags: debian, neuroscience, software, FSL, fslview, chroot, virtualization

.. _chap_schroot_fslview:

Chroot workaround for fslview (HOWTO)
=====================================

.. note::

  With the release of FSLView 4.0.0b this workaround should no longer be
  necessary. However, the technology is stil equally useful to work around
  similar problems with other software.

Preamble
--------

Sometimes research software lags behind developments in libraries it relies
upon, because necessary changes to the code might require considerable effort,
and thus time.  That leads to difficulties building those tools using
up-to-date library versions due API incompatibility.

That is what happened with fslview_ from the FSL_ suite.  Today, at
the end of 2011, it still relies on Qt3_ and VTK GUI
support for it.

.. _Qt3: http://doc.qt.nokia.com/3.3/

.. note::

   Last version of Qt3, 3.3.8, was released in February 2007, with
   official support by Trolltech terminated later that year.

   Qt4 was first released in 2005, and current stable series 4.7
   released appeared in September 2010.

Because of its age and discontinued upstream support, `Qt3 was
orphaned`_ in Debian, and tools relying on it were encouraged to
migrate to use Qt4.  As a result, although Qt3 itself is still present
in Debian (and thus Ubuntu), VTK GUI support for Qt3 (package
`libvtk5.4-qt3`_) which fslview uses, was removed from Debian due to
Qt3 deprecation.  It should be made clear that it was not removed to annoy people,
but rather because it became unfeasible to maintain its robust building
and functioning.  So nowadays fslview_ is
present only in those previous releases of Debian and Ubuntu which carry
the libvtk5.4-qt3 library.  Those are -- Debian squeeze (stable), Ubuntu
nutty and maverick.  If you upgraded your system from one of those
releases, chances are that you still have fslview (and required
libraries) installed although not they are not available from the APT repository
anymore. Therefore fresh systems installations will not have them at all.

.. _`Qt3 was orphaned`: http://lists.debian.org/debian-devel/2011/05/msg00236.html
.. _`libvtk5.4-qt3`: http://packages.debian.org/search?keywords=libvtk5.4-qt3

Workaround
----------

While everyone is waiting for a new release of fslview_ compatible with Qt4
there are possible workarounds to keep research going on bleeding edge
Debian-based operating systems.  The first, obvious choice for a FOSS
enthusiast, is to build fslview_ from source by first building VTK Qt3
bindings, possibly after building Qt3 itself.  While it might be educationally
valuable and exciting, we are afraid in the end it might be more frustrating
than useful.

Therefore we would like to suggest another, much more straightforward
and hopefully painless approach -- lightweight virtualization, or chroot_
jailing, which exists in Unix-land since 1970s.
With this exercise in **4 simple steps** we will install a
complete (minimalistic) installation of Debian stable into a separate
directory -- without harming the original system installation.  We will provide a convenience wrapper to
run fslview as if it was installed on the "main" system.  So your
system will stay intact while you would enhance it with additional
software in a stable Debian environment. Moreover if
security or critical fixes to any components of that installation
become available, this chroot
environment, being a complete Debian installation, could be as
easily upgraded as your main system, thus guaranteeing robust performance.

Although we demonstrate this setup with fslview in mind, such approach
is generally useful for various use cases.  For example, we have used it in
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
  end-users of fslview would not need root access after everything
  is set up

- 2 additional tools -- debootstrap_ to install Debian in a directory
  and a convenience utility schroot_ to "enable" such an environment

.. _debootstrap: http://wiki.debian.org/Debootstrap
.. _schroot: http://packages.debian.org/sid/schroot


Procedure
---------

- Install the tools::

   sudo apt-get install debootstrap schroot

- Choose a location with enough space (600 MB should be enough) and
  install a complete Debian squeeze installation with fslview::

   sudo debootstrap --include=fslview squeeze /srv/chroots/squeeze http://ftp.us.debian.org/debian

  .. note::
     You might like to adjust the URL to a `Debian mirror`_ closer to you

.. _`Debian mirror`: http://www.debian.org/mirror/list

- Create schroot_ configuration file ``/etc/schroot/chroot.d/squeeze``
  with the following content::

   [squeeze]
   description=Debian squeeze (6.x stable)
   type=directory
   directory=/srv/chroots/squeeze
   users=YOURLOGIN
   aliases=debian,default

  Replace YOURLOGIN with a comma separated list of users who should be
  allowed to access this chroot environment (see ``man schroot.conf``
  for more options, e.g. how to specify whole groups with ``groups=...``, etc.)

- At this point you should already be able to invoke any command
  within the chroot environment, so just create a little shell script
  ``/usr/local/bin/fslview``, make it executable and be all set::

   echo -e '#!/bin/sh\nexport FSLDIR=/usr/share/fsl\nschroot -p -c squeeze /usr/bin/fslview "$@"' > /usr/local/bin/fslview
   chmod a+x /usr/local/bin/fslview

  .. note::
     You might need to become root for the above.

Optional steps
--------------

Although at this point you can run fslview from the chroot-ed
environment, we would suggest a few additional steps.  For some of
them (marked with **chroot-root**) you would need to become root in a
chroot environment via following steps:

- enter chroot using ``schroot -c squeeze -p``

- become root (via ``su`` command, root password should be the same as
  on the main system)

So here are recommended optional additions:

- **chroot-root**: `Enable NeuroDebian repository
  <http://neuro.debian.net/#how-to-use-this-repository>`_. Choose
  ``squeeze`` release and mirror of preference (remove ``sudo`` from
  provided cmdline).

- **chroot-root**: Enable security and functionality updates::

   sed -e 's,squeeze,squeeze-updates,g' /etc/apt/sources.list > /etc/apt/sources.list.d/updates.list
   echo 'deb http://security.debian.org/ stable/updates main' > /etc/apt/sources.list.d/security.list
   apt-get update
   apt-get upgrade

- Make fsl atlases accessible within the chroot environment.  There
  are two ways and you must choose only **one** of them, otherwise
  you might damage your "main" system installation.

  - **chroot-root**: Install atlases packages in the chroot-ed environment::

     apt-get install fsl-atlases

    Although this is the best/correct way it would require additional 200MB of
    space, possibly duplicating what you already have installed in the
    main system.  Also it requires `enabling of NeuroDebian repository
    in chroot environment
    <http://neuro.debian.net/#how-to-use-this-repository>`_.

  - Alternatively you can bind-mount those directories with atlases installed on the "main"
    system within chroot.  For that edit (as root on the "main"
    system) ``/etc/schroot/default/fstab`` and add following entries::

     /usr/share/fsl/data/atlases /usr/share/fsl/data/atlases none rw,bind 0 0
     /usr/share/data             /usr/share/data             none rw,bind 0 0

    You need to be aware of the potential consequences of this second approach:
    Any package that installs files under /usr/share/data will modify files in
    the same directory outside the chroot as well. If you don't want to risk
    that don't use this method and simply install the necessary data packages
    inside the chroot environment too, as describe before.

    .. note::
       Similarly you can bind-mount any other directory you would like
       to make visible in chroot.  Just be careful to not "overlap"
       with system directories in chroot which already carry something.

Also you might like to read ``man schroot`` on how to enable
persistent sessions so that chroot initiation could be done ones
during boot instead of per each fslview invocation

If you have any comments (typos, improvements, etc) -- feel welcome to
leave a comment below, or just email `us@NeuroDebian`_ .

.. _us@NeuroDebian: http://neuro.debian.net/#contacts
