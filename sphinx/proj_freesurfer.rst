.. -*- mode: rst; fill-column: 78 -*-
.. ex: set sts=4 ts=4 sw=4 et tw=79:

.. _project_freesurfer:

********************
Packaging FreeSurfer
********************

:ref:`FreeSurfer <pkg_freesurfer>` is a set of tools for analysis and
visualization of structural and functional brain imaging data. It contains a
fully automatic structural stream for processing cross sectional and
longitudinal data.  Packaging of FreeSurfer for Debian is a part of our
general efforts to provide comprehensive neuro-imaging research support.

Status
------

The majority of FreeSurfer 5.1.0 has been released under seems to be
|DFSG|-compliant |FOSS| license terms on 24 May 2011.  We have started working
on packaging.  Following has been done

* modularization of the FreeSurfer distribution into code and data components

* FreeSurfer 5.1.0 |FOSS| code made available from our `FreeSurfer GitHub
  <https://github.com/neurodebian/freesurfer>`_ repository

* :file:`debian/patches` contains a series of patches primarily to

  - rely on system-provided libraries where applicable
  - in general replace static inclusion with dynamic linking thus
    greatly decreasing size of distributed binaries and making deployment more modular

.. todo:: FreeSurfer packaging

   * Collect and provide all required libraries to link against
   * Decide on further separation in to binary packages
   * Decide on how to ship "freesurfer-cuda" (depends on non-free materials,
     so cannot be build by the source in Debian `main` component)
   * Investigate possibility to deprecate/replace functionality dependent on
     antique libraries which might have been or soon will be removed from
     Debian (e.g. xview)


References
----------

* `Debian ITP bug report <http://bugs.debian.org/628183>`_ with additional
  information on the packaging progress.
* `FreeSurfer GitHub`_ with the full source code and the Debian packaging
* http://surfer.nmr.mgh.harvard.edu/fswiki/NextGenCode

.. include:: link_names.txt
