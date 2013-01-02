.. _support:

Contacts
========

`Email us directly <team@neuro.debian.net>`_ with any "private"
communication.  Otherwise please use our public mailing lists, which
exist not only to provide user-support but also to establish
communication channels within the NeuroDebian community

.. _chap_mailinglists:

* neurodebian-users_: Discussions and support of NeuroDebian users

* neurodebian-upstream_: General discussions and knowledge sharing
  among developers of neuroscience software.  We also use it
  to update you with summaries of recent relevant developments in
  Debian project

* neurodebian-devel_: Technical mailing list for discussions on
  NeuroDebian development

You are welcome also to join #neurodebian IRC room on OFTC network if
you have quick questions or want to join a live discussion.

.. _chap_team:

The team
========

`Michael Hanke <http://mih.voxindeserto.de>`_ and `Yaroslav Halchenko
<http://www.onerussian.com>`_ originally started NeuroDebian (formerly the
`Experimental Psychology Debian packaging project
<http://alioth.debian.org/projects/pkg-exppsy>`_) and are the current project
leaders. However, the whole project would not be possible without the work of
over 3,000 Debian_ developers and contributors who are as enthusiastically
building the Debian operating system.
A number of packages that are available from the NeuroDebian repository have
been contributed by various individuals and other teams in Debian, such as
`Debian Med`_ and `Debian Science`_. We want to express our gratitude to all
maintainers_ that help to make Debian_ the ultimate software platform for
neuroscience.

.. _maintainers: pkgs.html#by-maintainer


Acknowledgements
================

We are grateful to `Jim Haxby`_ for his continued support and :ref:`endless supply of
Italian espresso <coffeeart>`.

.. _Jim Haxby: http://haxbylab.dartmouth.edu/ppl/jim.html

Thanks to the following institutions and individuals for hosting a mirror:

* `Department of Psychological and Brain Sciences at Dartmouth College`_
  *[us-nh]* (primary mirror)
* `Department of Experimental Psychology at the University of Magdeburg`_
  *[de-md]*
* `Neurobot at Aristotle University of Thessaloniki, Greece`_ *[gr]*
* `Paul Ivanov`_ *[us-ca]*
* `Medical-image Analysis and Statistical Interpretation lab at Vanderbilt`_
  *[us-tn]*
* `Australia's research and education network (AARNET)
  <http://www.aarnet.edu.au>`_ *[au]*
* Kiyotaka Nemoto (AKA Mr. Lin4Neuro_) *[jp]*
* Iaroslav Iurchenko *[ua]*
* `Nikolaus Valentin Haenel`_ *[de-v]*
* `INCF G-Node at Ludwig-Maximilians-Universität München <http://www.g-node.org>`_ *[de-m]*

If your are interested in mirroring the repository, please see the :ref:`faq`.

.. _Department of Psychological and Brain Sciences at Dartmouth College: http://www.dartmouth.edu/~psych
.. _Department of Experimental Psychology at the University of Magdeburg: http://apsy.gse.uni-magdeburg.de
.. _Neurobot at Aristotle University of Thessaloniki, Greece: http://neurobot.bio.auth.gr
.. _Paul Ivanov: http://www.pirsquared.org
.. _Medical-image Analysis and Statistical Interpretation lab at Vanderbilt: https://masi.vuse.vanderbilt.edu
.. _Nikolaus Valentin Haenel: http://haenel.co

.. _chap_popularity:

Popularity
==========

.. raw:: html

 <p><img border="0" src="_files/nd_subscriptionstats.png" title="Statistics of new repository subscriptions for all supported releases. Note: subscription is only done once per machine." /></p>

Popularity Contest
------------------

We encourage you to participate in the `popularity
contest <http://popcon.debian.org>`_ (popcon), which anonymously
collects the list of packages you installed/use on your system.
Collecting such statistics is of particular importance for research
software projects as a prove of an existing user-base.  If upon
installation of the system you rejected the invitation to participate
you can always change your decision by running::

 sudo dpkg-reconfigure popularity-contest

.. note::

   If you are deploying multiple systems through cloning, to not have
   all systems considered as one, it would be necessary to re-generate
   the random MY_HOSTID.  Following commands ran as root should do it
   (as root) without any interactive dialog::

    sed -i -e 's,PARTICIPATE *= *.no.,PARTICIPATE="yes",g' -e '/^ *MY_HOSTID/d' /etc/popularity-contest.conf
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure popularity-contest

In addition to popcon pages for your "core" distribution (e.g. `Debian
<http://popcon.debian.org/>`__ or `Ubuntu
<http://popcon.ubuntu.com/>`__) you can see/get statistics for
submissions to `NeuroDebian <http://neuro.debian.net/popcon/>`__ and
know that you are already contributing back to the community.


