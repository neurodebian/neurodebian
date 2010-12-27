Dear Electrophysiology Neuroscientists,
=======================================

As you might know, during November 13-17, the NeuroDebian team ran its
first Debian booth at the annual meeting of the `Society for
Neuroscience`_ (SfN2010_) in San Diego, USA.  Our generic report `is
available from NeuroDebian website <http://neuro.debian.net/booth_sfn2010.html>`_.

In this post we want to summarize our findings on the status of Free
and Open Source Software (FOSS) in the domain of
neuro-electrophysiology.

- Majority of electrophysiology researchers are locked into software
  platforms provided by the vendors of the used hardware
- There exist a number of FOSS platforms for all (?) stages necessary
  for setting up the research workflow but their adoption in hindered
  by difficulty to setup and maintain.  That in turn results in the
  absence of a set of commonly accepted and used ultimate FOSS
  solutions in the field
- Majority of FOSS and some of the commercial data acquisition
  solutions use Linux-based systems, relying on an additional stack
  for real-time kernel support (e.g. RTAI_) and often the Comedi_
  library for interfacing with the (most often proprietary) hardware
- Some commercial companies are interested in sharing their products
  as FOSS (e.g. Ripple LLC: Trellis-Neuro) and getting them ready for
  inclusion into Debian
- Many labs develop their solutions and are willing to share but 
- Nearly all researchers using Linux, already use Debian_ (or
  Debian-derived such as Ubuntu_) Linux distribution as the platform
  but primarily rely on manual deployment (download, build, install or
  compose a custom Live media such as DVD or USB) of the 3rd-party and
  their own products

Existing Electrophysiology FOSS
-------------------------------

We have initiated a `Debian Science Electrophysiology task page
<http://blends.alioth.debian.org/science/tasks/electrophysiology>`_
to collect all relevant FOSS for the field and signal their status in
respect to inclusion in Debian distribution or presence of not (yet)
official Debian packages.  The list is constantly growing (and
changing), so if you spot some relevant FOSS absent, please `let us
know <team@neuro.debian.net>`_.

Here is a brief summary listing per application sub-domain:

XXX may be listing is just not needed and duplicate of what could be
found on the tasks page, although there it is not very
structured... so may be it is better to come up with a verbal
description

Data acquisition
~~~~~~~~~~~~~~~~

`Debian Science Data Acquisition task page
<http://blends.alioth.debian.org/science/tasks/dataacquisition>`_
provides similar summary for software such as RTAI_, Xenomai_, Comedi_
which enables data acquisition.

- Nspike -- electrophysiological and behavioral data collection

TODO:
- provide verbal summary on existing solutions
- mention RT-Preempt kernel images being available
- point to 'cooked' solutions on how to build using RTAI-patches
- existing pre-built RTAI kernel packages:
  
  http://www.linuxcnc.org/lucid/
  carries for hardy and lucid
  pointed there from http://hart.sourceforge.net/

Online Frameworks
~~~~~~~~~~~~~~~~~

- Relacs -- framework for closed-loop neurophysiological experiments
- RTXI -- real-time data acquisition and control applications in biological research
- Trellis-Neuro -- interface to neurophysiology data acquisition and stimulation instruments

TODO:
 - pointers to the SfN posters for RTXI, Mehmet's setups


Offline data analysis
~~~~~~~~~~~~~~~~~~~~~

- Chronus -- Matlab toolbox for analysis of neural signals
- KlustaKwik -- spike sorting tool
- Neurodata -- Octave/Matlab suite to analyze data acquired from electrophysiology experiments
- Openelectrophy -- data analysis framework for intra- and extra-cellular recordings
- Sigviewer -- GUI viewer for biosignals such as EEG, EMG, and ECG
- Spike -- information-theoretic spike train analysis techniques
- Stimfit -- viewing and analyzing of electrophysiological data



.. _chap_debian_booth_sfn2010: http://neuro.debian.net/booth_sfn2010.html
.. _blends_neuroscience_electrophysiology: http://blends.alioth.debian.org/science/tasks/electrophysiology

.. _annual meeting: http://www.sfn.org/am2010/
.. _SfN2010: http://www.sfn.org/am2010/
.. _Society for Neuroscience: http://www.sfn.org/
.. _RTAI: https://www.rtai.org
.. _Xenomai: http://www.xenomai.org
.. _Comedi: http://www.comedi.org
.. _Debian: http://www.debian.org
.. _Ubuntu: http://www.ubuntu.com
