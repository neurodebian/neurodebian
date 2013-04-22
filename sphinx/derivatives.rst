.. -*- mode: rst; fill-column: 78 -*-
.. ex: set sts=4 ts=4 sw=4 et tw=79:

.. _chap_derivatives:

*************************
NeuroDebian "Derivatives"
*************************

.. replace with icons eventually

`Live CD/USB Media`_ | `Virtual Appliances`_ | `Cloud Solutions`_

NeuroDebian_ is not a *Linux distribution* in a traditional sense because we
are working within Debian_ project thus not providing our custom installer
etc.  But we are a Linux-distribution providing a repository of up-to-date
builds and maintaining a :ref:`chap_vm` deployment of Debian.  Because of the
openness and modularity of Debian other enthusiasts develop customized
derivative solutions to address their particular needs.

This page presents some of such *derivative* projects which are tuned for
particular domains of application in neuroscience and rely on NeuroDebian_ as
the origin of necessary tools.

.. note::

   These projects are not maintained by NeuroDebian_ team.  Please direct all
   you support inquiries to respective authors/maintainers.

Live CD/USB Media
=================

USB Stick for Computational Neuroscience by Cengiz Günay
--------------------------------------------------------

+---------------------------+-------------------------------------------------------+
|**Author**                 | Cengiz Günay <cengique AT users.sf.net>               |
+---------------------------+-------------------------------------------------------+
|**Homepage**               | TBA                                                   |
+---------------------------+-------------------------------------------------------+
|**Purpose**                | Computational neuroscience tools for course-work      |
+---------------------------+-------------------------------------------------------+
|**Features**               | - Persistent Storage                                  |
|                           | - Based on Ubuntu_ 11.04                              |
+---------------------------+-------------------------------------------------------+
|**Pre-installed Software** | NeuroDebian                                           |
|                           |  XPPAUT_ 6.11b, python-brian_                         |
|                           | Custom:                                               |
|                           |  Genesis_ 2.3, Neuron_ 7.2, XPPAUT_ 6.10              |
+---------------------------+-------------------------------------------------------+
|**Download**               | TBA                                                   |
+---------------------------+-------------------------------------------------------+
|**References**             | TBA                                                   |
+---------------------------+-------------------------------------------------------+


Lin4Neuro
---------

+---------------------------+-------------------------------------------------------+
|**Author**                 | Kiyotaka Nemoto <kiyotaka@nemotos.net>                |
+---------------------------+-------------------------------------------------------+
|**Homepage**               | http://www.nemotos.net/lin4neuro/                     |
+---------------------------+-------------------------------------------------------+
|**Purpose**                | Neuroimaging tools for course-work                    |
+---------------------------+-------------------------------------------------------+
|**Features**               | - Datasets and tutorials from C.Rorden (mricron_)     |
|                           | - Both 32- and 64-bit images                          |
|                           | - Based on Ubuntu_ 10.04 LTS and Xubuntu_ 12.04 LTS   |
+---------------------------+-------------------------------------------------------+
|**Pre-installed Software** | NeuroDebian                                           |
|                           |  AFNI_, AMIDE, Caret_, FSL_, LIPSIA_, mricron_, etc.  |
|                           | Custom:                                               |
|                           |  3DSlicer, Ginkgo CADx, MINC, MRIConvert, Virtual MRI |
+---------------------------+-------------------------------------------------------+
|**Download**               | http://www.nemotos.net/l4n-iso/ [~2GB]                |
+---------------------------+-------------------------------------------------------+
|**References**             | http://www.biomedcentral.com/1471-2342/11/3           |
+---------------------------+-------------------------------------------------------+


Virtual Appliances
==================

XNAT
----

+---------------------------+-------------------------------------------------------+
|**Author**                 | Satrajit Ghosh <satra@mit.edu>                        |
+---------------------------+-------------------------------------------------------+
|**Homepage**               | http://datasharing.incf.org/ni/Install_XNAT           |
+---------------------------+-------------------------------------------------------+
|**Purpose**                | XNAT_ deployment                                      |
+---------------------------+-------------------------------------------------------+
|**Features**               | - XNAT_ 1.5                                            |
|                           | - 64-bit only                                         |
|                           | - Based on NeuroDebian VM appliance                   |
+---------------------------+-------------------------------------------------------+
|**Pre-installed Software** | Custom:                                               |
|                           |  XNAT_                                                |
+---------------------------+-------------------------------------------------------+
|**Download**               | `XNAT 1.5.0 NeuroDebian VM <xnat_vm_image>`_          |
+---------------------------+-------------------------------------------------------+

.. _xnat_vm_image: http://neuro.debian.net/_files/contrib/NeuroDebian_6.0.2+XNAT1.5.0-1_amd64.ova


JIST Development Virtual Machine
--------------------------------

http://www.nitrc.org/projects/jist


Cloud Solutions
===============

NeuroCloud
----------

http://gow.epsrc.ac.uk/ViewGrant.aspx?GrantRef=EP/I016856/1

..  * INCF Cloud App?

..  * NITRC?


.. include:: link_names.txt
