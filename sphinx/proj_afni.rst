.. -*- mode: rst; fill-column: 78 -*-
.. ex: set sts=4 ts=4 sw=4 et tw=79:

.. _project_afni:

**************
Packaging AFNI
**************

:ref:`AFNI <pkg_afni>` is an environment for processing and displaying
functional MRI data.  It provides a complete analysis toolchain, including 3D
cortical surface models, and mapping of volumetric data (SUMA).

Packaging AFNI for Debian is part of our general efforts to provide
comprehensive neuro-imaging research support.

Status
------

A fully functional package is available from the NeuroDebian repository.
Current work focuses on continuously tracking upstream development and making
the package fit for Debian proper.

To ease development a `Git repository`_ has been created that contains the
history of AFNI development since 1998. Because upstream doesn't expose a
version control system the repository is populated with daily snapshots of the
sources.

A new CMake-based build-system has been developed for AFNI.

.. _Git repository: http://git.debian.org/?p=pkg-exppsy/afni.git

.. todo:: AFNI packaging

   * Refurbish the afni-data package to meet Debian standards.
   * Push remaining patches upstream. A first wave has been submitted, but not
     yet adopted. It remains uncertain if the CMake buildsystem gets accepted.
   * Perform a final license check. Lots of 3rd-party code has already been
     removed from the package to allow for legal redistribution (e.g. edges3D
     library).
   * Develop a test suite for AFNI. We received a suitable dataset to implement
     a test running a full retinotopic mapping analysis.

References
----------

* `Debian ITP bug report <http://bugs.debian.org/409849>`_ with information on
  the packaging progress.
* `Git repository`_ with the full source code and the Debian packaging.
* `List of patches <http://git.debian.org/?p=pkg-exppsy/afni.git;a=tree;f=debian/patches;hb=HEAD>`_
  applied to the Debian package (i.e. the difference to the upstream AFNI
  source code).
