.. -*- mode: rst; fill-column: 78 -*-
.. ex: set sts=4 ts=4 sw=4 et tw=79:

.. _chap_popularity:

*********************
Popularity Statistics
*********************

Repository subscriptions
========================

.. raw:: html

 <p><img border="0" src="_files/nd_subscriptionstats.png" title="Statistics of new repository subscriptions for all supported releases. Note: subscription is only done once per machine." /></p>

Popularity Contest
==================

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


