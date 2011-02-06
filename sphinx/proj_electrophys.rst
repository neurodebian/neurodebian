.. -*- mode: rst; fill-column: 78 -*-
.. ex: set sts=4 ts=4 sw=4 et tw=79:

.. _project_electrophysiology:

*****************
Electrophysiology
*****************

The majority of the electrophysiology research community in neuroscience is
`locked-in` the proprietary software solutions which accompanying data
acquisition hardware.  That impairs their ability to adopt novel data analysis
methodologies and experimental setups.  There already exist a variety of
primarily Linux-based FOSS_ solutions in this domain.  But software
development and dissemination is often impaired by the absence of the efforts
centralization and existing problems with the support of the core components
by the used operating systems.  Nevertheless, Debian_ and its derivatives
already dominate as the operating systems of choice by such projects.

We are planing to help addressing existing issues in the core necessary
components provided by Debian_ to help upstream authors with streamlining
their development.  Furthermore we are planing to package some popular
deployment-ready |FOSS| solutions and make them an integral part of Debian_.

Status
------

We have collected information on interesting and alive projects in this domain
within neuroscience-electrophysiology_ task page.  To gather information on
the needs of the researchers interested in this field we have researched
researchers demands while helding a :ref:`Debian booth at SfN10 conference
<chap_debian_booth_sfn2010>`.  To further elaborate the work plan, we have
initiated discussions with upstream authors (private correspondence and on
neurodebian-devel_, neurodebian-upstream_ mailing lists).

.. todo:: Electrophysiology coverage

   * Help to ensure adequate status in Debian of the necessary core components,
     e.g. Comedi, RTAI (see DBTS: 606122, 608091, 609633):
   * Consider packaging prebuilt kernels with RTAI patches/support to make
     available from NeuroDebian repository

.. _606122: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=606122
.. _608091: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=608091
.. _609633: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=609633

..
 .. _: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=


References
----------

* RTAI_
* Comedi_
* `Debian-Science Electrophysiology task page <http://blends.alioth.debian.org/science/tasks/electrophysiology>`_.
* `Debian-Science Data acquisition task page <http://blends.alioth.debian.org/science/tasks/dataacquisition>`_.
* `Debian-Science Brain-Computer Interface task page <http://blends.alioth.debian.org/science/tasks/bci>`_.
* NeuralEnsemble_


.. include:: link_names.txt
