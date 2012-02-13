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
the proprietary environment.

To ease the transition to a completely open-source research environment, we are
following a two-fold approach. On one hand we start packaging all relevant
Octave-compatible software for Debian. On the other hand we work on a proper
integration of (still) Matlab-only software.

The latter shall be achieved by providing a support Debian package that can
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
with Octave, as well as developing patches to achieve such compatibility.

.. _Octave: http://www.gnu.org/software/octave

Status
------

A :ref:`Matlab-support package <pkg_matlab-support>` is available starting from
Debian 7.0 (wheezy) and Ubunty 11.10 (oneiric). Backports for older releases can
be obtained from NeuroDebian.

Packaging of individual Matlab-based software has started. An
:ref:`SPM <pkg_matlab-spm8>` package is ready, and a preliminary package of
:ref:`EEGLAB <pkg_matlab-eeglab11>` is available from NeuroDebian.
An upcoming :ref:`Fieldtrip <pkg_fieldtrip>` package is work-in-progress (see
references_ for more packages). Further expansion of the coverage is planned.

.. todo:: Integrating Matlab-based software

   * Finish packaging of fieldtrip which is necessary to complete the packaging
     of SPM.
   * Create :ref:`matlab-psychtoolbox-3 <pkg_matlab-psychtoolbox-3>` to
     complement :ref:`octave-psychtoolbox-3 <pkg_octave-psychtoolbox-3>`.
   * Create :ref:`matlab-biosig <pkg_matlab-biosig>` to
     complement :ref:`octave-biosig <pkg_octave-biosig>`.

References
----------

* `SPM packaging progress <http://bugs.debian.org/592390>`_ report.
* `Fieldtrip packaging progress <http://bugs.debian.org/605492>`_ report.
* `EEGLab packaging progress <http://bugs.debian.org/605739>`_ report.
* `PsychToolbox packaging progress <http://bugs.debian.org/606557>`_ report.

