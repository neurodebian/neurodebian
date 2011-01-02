.. -*- mode: rst; fill-column: 78 -*-
.. ex: set sts=4 ts=4 sw=4 et tw=79:

.. _project_matlab:

*********************************
Integrating Matlab-based software
*********************************

There is a vast amount of Matlab-based software for neuro-imaging and
psychological research. For various reasons, such software has not been
considered for integration into Debian in the past. However, recent advances of
the Octave_ project allow running a significant number of Matlab tools without
a proprietary environment.

To ease the transition to a completely open-source research environment, we are
following a two-fold approach. On one hand we start packaging all relevant
Octave-compatible software for Debian. On the other hand we work on a proper
integration of (still) Matlab-only software.

The latter shall be achieved by establishing an adaptor Debian package that can
represent local Matlab installations to the Debian package management system.
Moreover, this package provides helper tools that ease building MEX extensions
from source during package installation with a local Matlab and therefor allow
for inclusion of such packages into Debian 'contrib' suite (given an appropriate
licence).

The goal is to provide researchers with fully functional Matlab software, that
can be used with Matlab on Debian systems, while benefiting from all advantages
of Debian integration. However, at the same time researchers should have the
possibility to seamlessly switch to Octave_ whenever possible or necessary (e.g.
a laptop being out of reach of a university's license server), and eventually
completely migrate to Octave when full compatibility for a particular software
is achieved.

This effort includes talking to upstream projects about the possibility to run
with Octave, as well as developing patches to achieve compatibility.

.. _Octave: http://www.gnu.org/software/octave

Status
------

A :ref:`Matlab-adaptor package <pkg_matlab>` draft is ready and available from
NeuroDebian.

Packaging of individual Matlab-based software has started. This includes
:ref:`SPM <pkg_matlab-spm8>` and :ref:`Fieldtrip <pkg_fieldtrip>` (see
references_ for more packages). Expanding the coverage is planned.

.. todo:: Integrating Matlab-based software

   * Finish packaging of fieldtrip which is necessary to complete the packaging
     of SPM.
   * Adapt the packaging of `dynare <http://packages.debian.org/sid/dynare-matlab>`_
     in Debian to use the new adaptor package. Once this is done and reviewed by
     its maintainers the adaptor package can be submitted for inclusion into
     Debian proper.

References
----------

* `SPM packaging progress <http://bugs.debian.org/592390>`_ report.
* `Fieldtrip packaging progress <http://bugs.debian.org/605492>`_ report.
* `EEGLab packaging progress <http://bugs.debian.org/605739>`_ report.
* `PsychToolbox packaging progress <http://bugs.debian.org/606557>`_ report.

