.. -*- mode: rst; fill-column: 78 -*-
.. ex: set sts=4 ts=4 sw=4 et tw=79:

.. _chap_machines:

**********************
NeuroDebian "Machines"
**********************

We maintain few boxes of different architectures to help us and upstream
projects to troubleshoot problems found with maintained software.  They should
be accessible via ssh, but mention that access is guarded by fail2ban_ so in
case of a few unsuccessful login attempts you might get banned for a few
minutes before you can try to login again.

+---------------------------+-------------------------------------------------+
| Hostname                  | Architecture and SSH fingerprint                |
+---------------------------+-------------------------------------------------+
| vagus.cns.dartmouth.edu   | sparc TI (UltraSparc II, BlackBird)             |
|                           | a6:8a:fe:a0:63:5c:8d:93:c8:23:99:e5:b8:8c:4b:74 |
+---------------------------+-------------------------------------------------+

Howto use them
==============

When you login you get into Debian stable which might lack needed for your
software build depends, so you would need to switch to a sid (Debian unstable)
chroot which is updated from time to time and which has needed build
dependencies pre-installed for you::

  schroot

should get you into such chroot (if you add -p switch it would preserve
your environment if you happen to forward X etc)


Tools
=====

Obviously build dependencies necessary for your software should have got
preinstalled both in stable (if available) and sid chroot whenever you asked
for the access.

Persistent sessions
-------------------

You might like to use screen_ for persistent session.  Alternatively you might
like just to sshfs that directory back to your local box and do editing in the
environment you like and just build/test on a remote box -- but connection
must be reasonably fast.  Also there is tightvnc if you like to carry
persistent GUI session (you would need to tunnel it via ssh)

Building
--------

ccache_ (in sid chroot as well) to possibly expedite rebuilding.


.. include:: link_names.txt
