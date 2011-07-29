:date: 2011-06-15 10:00:00
:tags: neuroscience, grant

.. note::

   We would like to thank everyone who sent us a letter of support --
   altogether with previous submission we have received 64
   letters. *Thank you very much*.

   We have (re-)submitted the grant proposal on July 1st before the
   deadline and hope to hear from the NIH late Fall 2011.  If you
   still want to express your support or just share your positive (or
   negative) experience, please comment on the
   :ref:`testimonials` page.

NeuroDebian needs your support
==============================

The NeuroDebian Team is asking for your support.  We are hoping to obtain
funding for continued maintenance, development and expansion of the project.
An initial grant proposal has already been reviewed and we are about to
resubmit to address reviewer comments (PI `Dr. James V. Haxby`_; NIH program
announcement PAR-08-010_: Continued Development and Maintenance of Software
(R01)).

.. _Dr. James V. Haxby: http://haxbylab.dartmouth.edu/ppl/jim.html
.. _PAR-08-010: http://grants.nih.gov/grants/guide/pa-files/par-08-010.html

Please see the abstract and specific aims at the end for a more
detailed description of the updated project proposal.

We need to address two main reviewer concerns:

1. **Proof of the state of the project**

   We previously failed to convince the reviewers that our efforts
   **already** help researchers to maintain a productive research
   software environment with minimal effort.  Therefore, if you are
   using NeuroDebian, and you feel that it is beneficial for your
   research activities, we would appreciate your letter of support
   describing: Why did you start using NeuroDebian? What do you use it
   for?

2. **Feasibility of virtual environments for software deployment**

   The reviewers argued that using a virtual environment (i.e. a virtual
   machine, VM) is not a feasible solution to the problem of deploying an
   integrated platform, like NeuroDebian, on the two major non-GNU/Linux
   operating systems (Windows and Mac OS). Therefore, we would appreciate your
   letter of support, if you rely on a VM to run or evaluate research software.
   Such letter would preferably describe why you use a VM, and could offer a
   short summary of the VM experience in your research activities.

We also appreciate letters on other aspects of the proposal, and would be
delighted to see requests for any particular functionality included in them.

If you would like to see the NeuroDebian project to continue its development,
we would be thankful if you send your "Letter of Support" via email_
(preferably a PDF) or fax (+1 (603) 646-1419) to provide additional weight for
our application.  For your convenience, we have composed a generic `letter
template`_.

.. _email: team@neuro.debian.net
.. _letter template: http://neuro.debian.net/_files/letter_of_support_template.txt

If you have previously provided us a letter of support, and either
want to retract or alter it, based on the updated project description,
please email us.

We would appreciate if we receive your letter of support within a
week, so we are still on time with the resubmission and ready to
dedicate ourselves to HBM 2011 (visit us at booth #108).

Thank you very much in advance for your support,

the NeuroDebian team


Proposal Abstract
-----------------

Complex software systems play a more and more important role in neuroscience
research and managing an appropriate research environment is becoming
increasingly difficult. `NeuroDebian <http://neuro.debian.net>`_ is a turnkey
research software platform for all aspects of the neuroscientific research
process. It takes the ideas of the Neuroimaging Tools and Resources
Clearinghouse (`NITRC <http://www.nitrc.org>`_, on maximizing research
transparency and methods sharing, one step further, by providing a
comprehensive suite of readily usable and fully integrated software with a
robust testing and deployment infrastructure. Consequently, it improves
interoperability among the tools and frees researchers from the burden of
tedious installation or upgrade procedures. That, in turn, positively affects
their availability for actual research activities, as well as their motivation
to test new analysis tools and stay connected with the latest methodological
developments in the field.

Over the past six years, NeuroDebian has integrated dozens of neuroscience
software tools into the `Debian operating system <http://www.debian.org>`_,
making its current version, Debian 6.0, the first operating system world-wide
with comprehensive built-in support for MRI-based neuro-imaging research. In
close collaboration with the Debian community and all involved neuroscience
research groups we have provided middleware support for users and developers –
consulting developers regarding release practices and legal aspects and
streamlining technical support of NeuroDebian users. This joint effort has been
well received by the research community, and, according to a recent survey,
GNU/Linux-based systems are now the most common computing platform in
neuroscience, and NeuroDebian is the most popular software resource dedicated
to neuroscience.

To further contribute to the dissemination of new methods, the NeuroDebian
project aims to expand its coverage of software and to assure robust operation
across a wide variety of deployment scenarios. Developing an environment with a
large number of tightly integrated neuroscience software tools will allow for
testing efforts that continuously verify software interoperability. We will
develop a framework to derive a comprehensive description of a NeuroDebian
analysis environment, and offer anyone the building blocks to, later on,
reincarnate an identical copy, thus addressing an essential aspect of
reproducible research. By means of virtualization solutions we will offer
researchers the tools to take advantage of NeuroDebian on non-GNU/Linux
operating systems, and advanced computing platforms (e.g., distributed and
cloud computing) for efficient large-scale data analysis and modeling.

By fostering proven and efficient practices of the free and open-source
software community in neuroscience, NeuroDebian will help to assure the
availability and continued usefulness of existing software.


Specific aims
-------------

This project aims to further improve integration of neuroscience
software into the larger free and open source software community by
adopting standards and practices that have proven to yield a maximum
of quality and productivity. To this end, we will keep working closely
with a large number of neuroscience software developers, as well as
the Debian community. In particular we aim to achieve:

Aim 1: Ongoing maintenance of neuroscientific software in (Neuro)Debian
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NeuroDebian currently maintains over 30 software projects, from
single-purpose tools to complex analysis suites. All integrated
software requires timely response to bug reports, and software
updates. We aim to continue to offer reliable and prompt service in
providing an efficient research environment.

Aim 2: Increased coverage of neuroscientific research tools
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To enhance the utility of NeuroDebian for a wide range of research
applications we will

a) extend software coverage beyond (f)MRI/DTI-based neuroimaging to
   tools for intra/extra-cellular recording and modeling, EEG/MEG,
   and data management: e.g., BrainVisa/Anatomist, Camino, DTI-TK,
   FreeSurfer, NEURON, XNAT, and other software that becomes
   available during the project lifetime;
b) integrate essential Matlab-based open-source software: e.g.,
   BrainStorm, EEGLAB, Fieldtrip, PsychToolbox, SPM;
c) facilitate work on increasing the compatibility of Matlab-based
   neuroscience tools with alternative open-source computing
   platforms – such as Octave – to improve their availability in
   high-throughput, and cloud computing environments and loosen
   dependencies on proprietary systems;
d) mentor interested developers in maintaining their software in
   Debian by themselves.

Aim 3: Quality and interoperability assurance
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Independent research software tools evolve at their own pace. This
poses a challenge for heterogeneous computing environments. To
assure reliability and interoperability without stagnation we will

a) exercise available test batteries on recent and upcoming releases
   of Debian and Ubuntu to assure robust performance and inform
   developers about upcoming changes before researchers are affected;
b) develop new test suites for common heterogeneous analysis
   pipelines and run them routinely to assure proper functioning and
   ongoing compatibility of all involved tools;
c) make developed test suites readily available to users so they can
   verify correct operation of their particular research
   environments.

Aim 4: Sustained availability of software and precise re-creation of complete research environments
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The scientific workﬂow frequently requires re-analyses of data with
particular versions of software, for example, to revise a manuscript
or to reproduce a study. We will

a) employ Debian’s existing software archive snapshotting framework
   to preserve and distribute all previous and current versions of
   supported software in NeuroDebian;
b) build on Debian’s package management systems, to develop tools to
   describe a particular analysis environment (with all versioned
   dependencies) to be able to reconstruct it at any later point in
   time – by anyone – given access to the specification and to the
   software archive snapshots.

Aim 5: Broad availability of NeuroDebian on common and advanced computing platforms
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A NeuroDebian-based system is not bound to computers solely running
Debian. We will

a) provide binary packages for Debian-derived operating systems
   (e.g., Ubuntu);
b) provide a virtual appliance allowing deployment of NeuroDebian in
   a virtualized environment on proprietary operating systems
   (e.g., Microsoft Windows and Mac OS X), as well as on other
   non-Debian GNU/Linux distributions;
c) provide NeuroDebian system images for cloud and high-throughput
   computing that are compatible with popular service providers and
   environments, such as Amazon EC2, and Condor.
