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

  Because the is not need for it to become one. NeuroDebian's goal is to
  provide software for neuroscientists using the Debian operating system, and
  therefore the ultimate goal is to get all relevant software **into Debian**.

  However, various reasons exist that prevent a particular software from
  entering Debian. Some are temporary, i.e. a package is already useable, but
  some technical bits do not meet Debian's standard yet, or a licensing issue
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


How to create a mirror of the repository?
------------------------------------

  If you are interested in sponsoring storage space and bandwidth for another
  mirror, please contact michael.hanke@gmail.com.

