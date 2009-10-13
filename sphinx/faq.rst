.. -*- mode: rst; fill-column: 78 -*-
.. ex: set sts=4 ts=4 sw=4 et tw=79:
  ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
  #
  #   See COPYING file distributed along with the PyMVPA package for the
  #   copyright and license terms.
  #
  ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###


.. _faq:

**************************
Frequently Asked Questions
**************************


Why is NeuroDebian not a Pure Blend?
------------------------------------

  Because there is not need for it to become one, as the existing Debian Pure
  Blends already offer the desired functionality *within* Debian. Similar to
  Pure Blends, NeuroDebian's goal is to provide software for neuroscientists
  using the Debian operating system, and therefore the ultimate goal is to get
  all relevant software **into Debian**.

  However, various reasons exist that prevent a particular software from
  entering Debian. Some are temporary, i.e. a package is already useable, but
  some technical bits do not meet Debian's standard yet or a licensing issue
  needs to be resolved first. For some software the licensing is so restrictive
  that it cannot be distributed by Debian, and hence cannot even go into its
  *non-free* branch. Unfortunately, sometimes these issues cannot be solved to
  a degree that is acceptable for Debian. For some other packages Debian itself
  is not ready yet, e.g. huge data packages with neuroscience data (:ref:`with
  sometimes over 1GB <pkg_fsl-first-data>`) 

  NeuroDebian aims to be a platform that provides a staging area for
  neuroscience software packages on their way into Debian. All packages are
  properly registered with the relevant `Debian Pure Blends`_, e.g.
  `Debian-Science Cognitive Neuroscience`_ or `Debian-Med Imaging`_. Inside
  Debian these efforts already provide a suitable framework for this purpose,
  and hence there is now need to establish yet another one.

.. _Debian Pure Blends: http://wiki.debian.org/DebianPureBlends
.. _Debian-Science Cognitive Neuroscience: http://blends.alioth.debian.org/science/tasks/neuroscience-cognitive
.. _Debian-Med Imaging: http://debian-med.alioth.debian.org/tasks/imaging


When does a package migrate from NeuroDebian into Debian proper?
----------------------------------------------------------------

  In short: When it is ready. The longer answer is that there is nothing
  special to packages in NeuroDebian in comparison to packages conducted
  elsewhere.  Packaging efforts are announced to Debian via ITPs_ and the
  packaging itself is available in some version control system -- typically in
  the Git repositories of the `pkg-exppsy group on Debian's Alioth server`_, or
  another VCS, or on http://mentors.debian.net.

  The only difference is that a particular package becomes available through the
  NeuroDebian repository before it has passed all checks for compliance with
  Debian's standards. But even after a package becomes part of Debian the
  NeuroDebian repository continues to provide binary packages of new versions
  for a certain set of Debian and Ubuntu releases (aka backports).

.. _ITPs: http://www.debian.org/devel/wnpp
.. _pkg-exppsy group on Debian's Alioth server: http://alioth.debian.org/projects/pkg-exppsy/


Debian, Debian, Debian -- What about Ubuntu?
--------------------------------------------

  NeuroDebian offers backported binary package for recent Ubuntu releases
  whenever possible. However, since Ubuntu is a rather thin shell around Debian
  it is more efficient to spend time packaging for Debian. After the appearance
  of new packages in Debian, Ubuntu typically synchronizes them quickly and
  they become available in the *Ubuntu universe* -- a repository of Debian
  packages rebuilt for a particular Ubuntu release.


How to create a mirror of the repository?
-----------------------------------------

  The NeuroDebian repository can be mirrored with rsync If you are interested
  in sponsoring storage space and bandwidth for another mirror, please contact
  pkg-exppsy-maintainers@lists.alioth.debian.org.

