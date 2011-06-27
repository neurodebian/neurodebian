.. _WELCOme:

***********************************************
 Welcome to the Debian Neuroscience Repository
***********************************************

.. quotes::
   :random: 1

This repository provides mostly neuroscience-related packages to be used on
Debian_ systems (or Debian-derivatives like Ubuntu_). It contains both unofficial
or prospective packages which are not (yet) available from the main Debian_
archive, as well as backported or simply rebuilt packages also available
elsewhere. Please see the :ref:`faq` for more information about the goals of
this project, and :ref:`read what people say about it <testimonials>`.
Take a look at the :ref:`list of our current and planned projects <projects>` if
you want to get involved. If you appreciate this service, please |spread|.

.. note::

  This service is provided "as is". There is no guarantee that a package
  works as expected, so use them at your own risk. If you encounter problems,
  please `report <#contacts>`_ them.


.. raw:: html

 <p>
 <a href="pkgs.html"><img border="0" src="_static/package.png" title="Software package list" /></a>
 <a href="pkglists/pkgs-by_release-datasets_(data).html"><img border="0" src="_static/datasets.png" title="Dataset package list" /></a>
 <a href="vm.html"><img border="0" src="_static/machine.png" title="Get NeuroDebian for your non-Debian computer" /></a>
 <a href="debian/pool"><img border="0" src="_static/pool.png" title="Go to the package pool (deep and cold, only for experts)" /></a>
 <a href="projects.html"><img border="0" src="_static/workarea.png" title="Current and planned projects: Get involved!" /></a>
 <a href="blog/index.html"><img border="0" src="_static/rssfeeds.png" title="NeuroDebian Insider Blog" /></a>
 </p>

.. _Ubuntu: http://www.ubuntu.com

.. _news:

News
====

.. raw:: html

 <script src="_static/jquery.livetwitter.min.js"></script>
 <div id="identica_widget"></div>
 <script type="text/javascript">
 $("#identica_widget").liveTwitter('neurodebian',
                                   {service: 'identi.ca',
                                    mode: 'user_timeline',
                                    limit: 10,
                                    rate: 300000});
 </script>

For more news and information see our :ref:`blog <blog>`. Older news items are
available on identi.ca_. Follow us on identi.ca_ (preferred) or twitter_ to
subscribe to the NeuroDebian news.

.. _identi.ca: http://identi.ca/neurodebian
.. _twitter: http://twitter.com/NeuroDebian

.. _repository_howto:



How to use this repository
==========================

To enable the NeuroDebian repository on your system, select your Debian or
Ubuntu release and a repository mirror from the lists below. Upon selection
a short command snippet will be displayed that can be copied and pasted into
a terminal session. These commands will configure the system package manager
with the NeuroDebian repository key and package source information.

.. include:: sources_lists

Once this is done, you have to update the package index and you are ready to
install packages. Use your favorite package manager, e.g. synaptic, adept. In
the terminal you can use :command:`apt-get`::

  sudo apt-get update
  sudo apt-get install mricron

.. note::

  Not every package is available for all distributions/releases. For information
  about which package version is available for which release and architecture,
  please have a look at the corresponding package pages.


.. _chap_installation:

Ways to use NeuroDebian
=======================

Virtual machine
---------------

If you are not running Debian_ on a particular machine a :ref:`chap_vm` is
provided as a convenient testing and evaluation environment.  After a few
simple steps to setup the virtual machine, you will be able to use NeuroDebian_
as an integral part of your existing working environment without any sacrifice.
The virtual machine is also a suitable environment to temporarily deploy
neuroscience software on machines running other operating systems, e.g. for the
purpose of teaching a neuroimaging data analysis course in a multipurpose
computer lab.


Debian installation
-------------------

Having been exposed to the wonders of NeuroDebian_ you are no longer
satisfied with your previous choice of operating system?  We would
recommend installing Debian_ to replace or complement (dual-boot) your
existing OS.  Please visit `"Getting Debian"
<http://www.debian.org/distrib/>`_ to obtain the images for your
hardware architecture and then simply add |repos|.


.. _chap_team:


The team
========

Our main goal is to provide neuroscience FOSS_ for Debian_. Thus the
whole project would not be possible without the work of over 3,000
Debian_ developers and contributors who are as enthusiastically pursuing
a similar goal.  To add our share -- Debian_ packages of FOSS_ for
neuroscience research -- the `Experimental Psychology Debian packaging
project <http://alioth.debian.org/projects/pkg-exppsy>`_ was created
to formally join the forces of

* `Michael Hanke <http://mih.voxindeserto.de>`_
* `Yaroslav Halchenko <http://www.onerussian.com>`_

A number of packages that are now available from the NeuroDebian repository
were not packaged by our team, but similar Debian teams.  Therefore we want to
express particular gratitude to the `Debian Med`_ and `Debian Science`_ teams
for all their work.

.. _support:

Contacts
========

`Email us directly <team@neuro.debian.net>`_ with any "private"
communication.  Otherwise please use our public mailing lists, which
exist not only to provide user-support but also to establish
communication channels within the NeuroDebian community

* neurodebian-users_: Discussions and support of NeuroDebian users

* neurodebian-upstream_: General discussions and knowledge sharing
  among developers of the neuroscience software.  We will also use it
  to update you with summaries of recent relevant developments in
  Debian project

* neurodebian-devel_: Technical mailing list for discussions on
  NeuroDebian development

You are welcome also to join #neurodebian IRC room on OFTC network if
you have quick questions or want to join a live discussion.

Acknowledgements
================

We are grateful to `Jim Haxby`_ for his continued support and :ref:`endless supply of
Italian espresso <coffeeart>`.

.. _Jim Haxby: http://haxbylab.dartmouth.edu/ppl/jim.html

Thanks to the following institutions and individuals for hosting a mirror:

* `Department of Psychological and Brain Sciences at Dartmouth College`_
  *[us-nh]* (primary mirror)
* `Department of Experimental Psychology at the University of Magdeburg`_
  *[de]*
* `Neurobot at Aristotle University of Thessaloniki, Greece`_ *[gr]*
* `Paul Ivanov`_ *[us-ca]*
* `Medical-image Analysis and Statistical Interpretation lab at Vanderbilt`_
  *[us-tn]*

If your are interested in mirroring the repository, please see the :ref:`faq`.

.. _Department of Psychological and Brain Sciences at Dartmouth College: http://www.dartmouth.edu/~psych
.. _Department of Experimental Psychology at the University of Magdeburg: http://apsy.gse.uni-magdeburg.de
.. _Neurobot at Aristotle University of Thessaloniki, Greece: http://neurobot.bio.auth.gr
.. _Paul Ivanov: http://www.pirsquared.org
.. _Medical-image Analysis and Statistical Interpretation lab at Vanderbilt: https://masi.vuse.vanderbilt.edu


Publications
============

Hanke, M. & Halchenko, Y. O. (Accepted). Neuroscience runs on GNU/Linux.
*Frontiers in Neuroinformatics*.

Hanke, M. (2011). `Integrating Condor into the Debian operating system
<_files/Hanke_CondorDebianIntegration_CondorWeek2011.pdf>`_.
*Talk given at* `CondorWeek 2011
<http://www.cs.wisc.edu/condor/CondorWeek2011/wednesday_condor.html>`_,
Madison, Wisconsin, USA.

Hanke, M. & Halchenko, Y. O. (2010). :ref:`Report from the Debian booth at
SfN2010 <chap_debian_booth_sfn2010>`. *Annual meeting of the Society for
Neuroscience*, San Diego, USA.

Halchenko, Y. O., Hanke, M., Haxby, J. V., Pollmann, S. & Raizada, R. D.
(2010). `Having trouble getting your Nature paper? Maybe you are not using the
right tools? <_files/NeuroDebian_SfN2010.png>`_ *Poster to be presented at the
annual meeting of the Society for Neuroscience*, San Diego, USA.

Hanke, M., Halchenko, Y. O. (2010). `Debian: The ultimate platform for
neuroimaging research <_files/HankeHalchenko_NeuroDebianDebConf10.pdf>`_.
*Talk given at* DebConf10_, New York City, USA. [video:
`low resolution <http://meetings-archive.debian.net/pub/debian-meetings/2010/debconf10/low/1310_1310_Debian_The_ultimate_platform_for_neuroimaging_research.ogv>`_,
`high resolution <http://meetings-archive.debian.net/pub/debian-meetings/2010/debconf10/high/1310_1310_Debian_The_ultimate_platform_for_neuroimaging_research.ogv>`_]

Hanke, M., Halchenko, Y. O., Haxby, J. V. & Pollmann, S. (2010). `Improving
efficiency in cognitive neuroscience research with NeuroDebian
<_files/NeuroDebian_CNS2010.pdf>`_. *Poster presented at the annual
meeting of the Cognitive Neuroscience Society*, Montréal, Canada.

Halchenko, Y. O., Hanke, M. (2009). `An ecosystem of neuroimaging,
statistical learning, and open-source software to make research more
efficient, more open, and more fun
<_files/HalchenkoHanke_FossEcosystemDC09.pdf>`_. *Talk given at*
`Dartmouth College`_, New Hampshire, USA.

.. _DebConf10: http://debconf10.debconf.org/
.. _Dartmouth College: http://www.dartmouth.edu/


.. toctree::
   :hidden:

   faq
   pkgs
   spread
   vm
   coffeeart
   photoalbum
   projects
   testimonials

.. probably should be purged altogether
.. toctree::
   :hidden:

   booth_sfn2010
   datasets
   livecd
   quotes-nihr01
   quotes-nitrc
   sources_lists
   vm_welcome

.. include:: link_names.txt
.. include:: substitutions.txt
