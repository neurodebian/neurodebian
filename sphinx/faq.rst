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
  neural data <http://www.pymvpa.org>`_.  To conveniently deployment PyMVPA for
  anyone using Debian-derived distributions this package repository was created
  initially.  Besides the PyMVPA_ project |we| collaborate with the `NiPy team
  <http://neuroimaging.scipy.org>`_ on various projects, such as NiBabel_ and
  NiPype_.  Quickly NeuroDebian_ became the ultimate integrated environment for
  all these projects. We are now constantly working on enriching this
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
  properly registered with the relevant `Debian Pure Blends`_, e.g.
  `Debian Science Cognitive Neuroscience`_ or `Debian Med Imaging`_. Inside
  Debian these efforts already provide a suitable framework for this purpose,
  and hence there is no need to establish yet another one.

.. _Debian Pure Blends: http://wiki.debian.org/DebianPureBlends
.. _Debian Science Cognitive Neuroscience: http://blends.alioth.debian.org/science/tasks/neuroscience-cognitive
.. _Debian Med Imaging: http://debian-med.alioth.debian.org/tasks/imaging


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
  exactly the same :ref:`archive sections as Debian proper
  <http://www.debian.org/doc/debian-policy/ch-archive.html>`.  The *non-free*
  section contains packages that have certain restrictions regarding **your
  freedom** to employ them for a particular purpose. In contrast, for packages
  in the *main* section your are completely free to do whatever and in whatever
  context you like. Regardless of the actual license or archive section, all
  packages in NeuroDebian are provided free of charge and under the licensing
  terms of the original developers.


.. include:: links_names.rst
.. include:: substitutions.rst
