.. -*- mode: rst; fill-column: 78 -*-
.. ex: set sts=4 ts=4 sw=4 et tw=79:

.. _projects:

********************
NeuroDebian Projects
********************

We share a lot of common interests with other teams in Debian.  So we are
actively collaborating with `Debian Med`_ and `Debian Science`_ projects to
improve Debian_ infrastructure and software coverage to fulfil our goals.

This page provides an overview of current and planned NeuroDebian_ projects. Each description
lists a couple of tasks remaining to reach the goal of a
particular project. If you want to contribute, take a look at them and email the
neurodebian-devel_ mailing list with your intention to help.


Expanding coverage
------------------

* :ref:`project_matlab`
* Neuroimaging

  - :ref:`project_afni`
  - :ref:`Packaging SPM8 <project_matlab>`
  - :ref:`project_freesurfer`

* :ref:`project_psychophysics`
* :ref:`project_electrophysiology`
* :ref:`Neural modeling <project_neuralmodeling>`

Please refer to the `complete list of perspective packages
<http://qa.debian.org/wnpp.php?login=team%40neuro.debian.net>`_ which we are
working on (|ITP|\s) or just placed on the radars of Debian project (|RFP|\s).


Infrastructure
--------------

* :ref:`project_debtest`
* :ref:`project_snapshots`
* :ref:`coffeeart`


Cross-platform availability
---------------------------

* :ref:`chap_vm`
* Live CD (`preliminary version <http://neuro.debian.net/debian/live/>`_)
* Cloud computing


Expertise transfer
------------------

* `Best practices for deploying scientific software <https://github.com/neurodebian/SciDeployGuide>`_
* Advise (e.g. on legal, deployment aspects) and contribute upstream projects
* Whenever necessary mentor and sponsor uploads of relevant projects into Debian_


Promotion
---------

* `Publications <http://neuro.debian.net/index.html#publications>`_ and
  promotional materials

  - `Debian / NeuroDebian tri-fold
    <http://neuro.debian.net/_files/brochure_debian-neurodebian.pdf>`_

* Conferences presence of the team presenting Debian_,
  NeuroDebian_, and related work:

  **May 2-6, 2011** `Paradyn/Condor Week <http://www.cs.wisc.edu/condor/ParadynCondorWeek2011>`_, Madison, Wisconsin, USA
    Hanke, M. `Talk: Integrating Condor into the Debian operating system <http://www.cs.wisc.edu/condor/ParadynCondorWeek2011/presentations/hanke-condor-debian.pdf>`__
  **June 26-30, 2011** `HBM 2011 <http://www.humanbrainmapping.org/HBM2011>`_, Québec City, Canada
    Debian/NeuroDebian booth `#108 <http://www.humanbrainmapping.org/files/2011MeetingFiles/Exhibit_Floor_Plan-5_10_2011.PDF>`__
  **July 21-23, 2011** `PsychoPy Workshop and Codesprint <https://scanlab.psych.yale.edu/public/psychopy>`_, New Haven, CT, USA

  **August 25-30, 2011** `EuroSciPy 2011/ Python in NeuroScience <http://www.euroscipy.org/conference/euroscipy2011>`_, Paris, France

     2011/08/27, 16:30 -- 17:00, Scientific track
	     Halchenko, Yaroslav O. `Talk: π's in Debian or Scientific Debian: NumPy,
	     SciPy and beyond <http://www.euroscipy.org/talk/4379>`__
     2011/08/29, 14:00 -- 14:30, Neuroimaging data processing
         Halchenko, Yaroslav O. `Talk: The virtues and sins of PyMVPA <http://pythonneuro.sciencesconf.org/899>`__
     2011/08/30, 10:30 -- 10:45, Workflows and pipelines for data processing
         Hanke, M. `Talk: More than batteries included: NeuroDebian <http://pythonneuro.sciencesconf.org/883>`__
     2011/08/30, 12:00 -- 12:15, Data management and databasing
	     Hanke, M. `Talk: NiBabel: Conductor for a cacophony of neuro-imaging file formats <http://pythonneuro.sciencesconf.org/901>`__

  **September 8, 2011** `INCF Cross-Task Force Hackathon <http://atlasing.incf.org/wiki/Sept8>`_, Boston, MA, USA

  **November 12-16, 2011** `SfN 2011 <http://www.sfn.org/am2011/>`_, Washington, District Columbia, USA
    Booth #3207
  `Invite us <mailto:team@neuro.debian.net>`_

* `Inviting contributions and new members to join the NeuroDebian project
  <https://openhatch.org/+projects/NeuroDebian>`_


..
 Planned projects
 ----------------

..
 Finished projects
 -----------------

 .. toctree::
    :maxdepth: 1

    vm

.. toctree::
   :hidden:
   :maxdepth: 1

   proj_afni
   proj_debtest
   proj_electrophys
   proj_psychophysics
   proj_freesurfer
   proj_matlab
   proj_neuralmodeling
   proj_snapshots
   proj_template
   livecd
   coffeeart


.. include:: link_names.txt
