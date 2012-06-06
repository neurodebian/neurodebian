.. -*- mode: rst; fill-column: 78 -*-
.. ex: set sts=4 ts=4 sw=4 et tw=79:


.. _faq:

**************************
Frequently Asked Questions
**************************

Why NeuroDebian?
----------------

  In the course of our own research endeavors |we| have joined forces to
  develop `PyMVPA -- a Python framework for multivariate pattern analysis of
  neural data <http://www.pymvpa.org>`_.  To conveniently deploy PyMVPA for
  anyone using Debian-derived distributions this package repository was created
  initially.  Besides the PyMVPA_ project |we| collaborate with the `NiPy team
  <http://neuroimaging.scipy.org>`_ on various projects, such as NiBabel_ and
  NiPype_.  Quickly NeuroDebian_ became the ultimate integrated environment for
  all these projects -- and we are constantly working on enriching this
  environment with as many additional relevant software as possible.


Why is NeuroDebian not a Pure Blend?
------------------------------------

  Because there is no need for it to become one, as the existing Debian Pure
  Blends already offer the desired functionality *within* Debian. Similar to
  Pure Blends, NeuroDebian's goal is to provide software for neuroscientists
  using the Debian operating system, and therefore the ultimate goal is to get
  all relevant software **into Debian**.

  However, various reasons exist that prevent a particular software from
  entering Debian. Some are temporary, i.e. a package is already useable, but
  some technical bits do not meet Debian's standards (yet) or a licensing issue
  needs to be resolved first. For some software the licensing is so restrictive
  that it cannot be distributed by Debian, and hence cannot even go into its
  *non-free* branch. Unfortunately, sometimes these issues cannot be solved to
  a degree that is acceptable for Debian. For some other packages Debian itself
  is not ready yet, e.g. huge data packages with neuroscience data (:ref:`with
  sometimes over 1GB <pkg_fsl-first-data>`).

  NeuroDebian aims to be a platform that provides a staging area for
  neuroscience software packages on their way into Debian. All packages are
  properly registered in the relevant `Debian Pure Blends`_, e.g.
  `Debian Science Cognitive Neuroscience`_ or `Debian Med Imaging`_. Inside
  Debian these efforts already provide a suitable framework for this purpose,
  and hence there is no need to establish yet another one.

.. _Debian Pure Blends: http://wiki.debian.org/DebianPureBlends
.. _Debian Science Cognitive Neuroscience: http://blends.alioth.debian.org/science/tasks/neuroscience-cognitive
.. _Debian Med Imaging: http://debian-med.alioth.debian.org/tasks/imaging


I want to help. How do I get involved?
--------------------------------------

  We always need people to help maintaining existing packages. If you need
  some additional software packaged and you want to try it on your own, we would
  be happy to mentor you. We also have a :ref:`list of ongoing and planned
  projects <projects>`, each listing a number of tasks that need to be done.

  If you found something you are interested in, please email the
  neurodebian-devel_ mailing list and let us know about it. Thanks!


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

  NeuroDebian offers backported binary packages for recent Ubuntu releases
  whenever possible. However, since Ubuntu (like many other derivatives) uses
  Debian as its foundation, it is more efficient to spend time maintaining
  packages in Debian, instead of having to directly contribute to countless
  child-distributions.  After the appearance of new packages in Debian, Ubuntu
  typically synchronizes them quickly and they become available in the *Ubuntu
  universe* -- a repository of Debian packages rebuilt for a particular Ubuntu
  release.  We are not constantly rebuilding of all available NeuroDebian
  packages for new Ubuntu releases.  Therefore, you might find some packages
  temporarily being available for older Ubuntu releases only -- until the point
  when a new package version is made and gets built for all currently supported
  releases.


How to create a mirror of the repository?
-----------------------------------------

  The NeuroDebian repository can be mirrored with rsync. If you are interested
  in sponsoring storage space and bandwidth for another mirror, please
  `contact us <team@neuro.debian.net>`_.


How do I get a new neuroscience-related FOSS into (Neuro)Debian?
----------------------------------------------------------------

The goal of NeuroDebian is to package neuroscience software for Debian. Hence
getting software into NeuroDebian means trying to get it into Debian. There are
at least two possibilities to achieve that:

* You can approach packaging it yourself. Start by filing an ITP_ (Intent to
  package) bugreport) and `ask us <team@neuro.debian.net>`_ to mentor your
  upload to Debian_, if you are not a Debian developer.

* `Contact us <team@neuro.debian.net>`_ -- but then it might take a little
  longer, depending on our current workload and interest in a particular
  software.


I have heard that some packages are non-free. Will you charge me for them?
--------------------------------------------------------------------------

  No. The term :term:`non-free` refers to an archive section. NeuroDebian uses
  exactly the same `archive sections as Debian proper
  <http://www.debian.org/doc/debian-policy/ch-archive.html>`_.  The *non-free*
  section contains packages that have certain restrictions regarding **your
  freedom** to employ them for a particular purpose. In contrast, for packages
  in the *main* section your are completely free to do whatever and in whatever
  context you like. Regardless of the actual license or archive section, all
  packages in NeuroDebian are provided free of charge and under the licensing
  terms of the original developers.

.. _sec_pkg_authentication:

What means "The following signatures couldn't be verified..."?
--------------------------------------------------------------

When you start using this repository, you probably get warning messages
like this::

  The following signatures couldn't be verified because
  the public key is not available.

Or you will be asked questions like this over and over::

  WARNING: The following packages cannot be authenticated!
  ...
  Install these packages without verification [y/N]?

This is because your APT installation initially does not know the GPG
key that is used to sign the release files of this repository. It is easy to
make APT happy again. The simplest way is to install the ``neurodebian-keyring``
package that is available from the NeuroDebian repository. Alternatively:

1. Get the key. Either download the `repository key from here
   <_static/neuro.debian.net.asc>`_
   or fetch it from http://wwwkeys.pgp.net (2649A5A9).

2. Now feed the key into APT by invoking::

     apt-key add #file#

   Where `#file#` has to be replaced with the location of the key file you just
   downloaded. You need to have superuser-privileges to do this (either do it
   as root or use sudo).


How can I cite NeuroDebian?
---------------------------

Please cite the following paper:

  Halchenko, Y. O. & Hanke, M. (2012). `Open is not enough. Let’s take the
  next step: An integrated, community-driven computing platform for neuroscience
  <http://www.frontiersin.org/Neuroinformatics/10.3389/fninf.2012.00022/full>`_.
  *Frontiers in Neuroinformatics*, 6:22.


.. include:: link_names.txt
.. include:: substitutions.txt
