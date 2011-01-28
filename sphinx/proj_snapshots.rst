.. -*- mode: rst; fill-column: 78 -*-
.. ex: set sts=4 ts=4 sw=4 et tw=79:

.. _project_snapshots:

***********************************
NeuroDebian repository snapshotting
***********************************

The official Debian snapshotting service (http://snapshot.debian.org) allows
obtaining any version of any software that was ever present in Debian, and
provides a complete state of the Debian archive with all software versions
corresponding to a specific date.  We are going to adopt this service to
provide this functionality for the NeuroDebian repository itself, thus
covering backports of our packages for all supported Debian and Ubuntu
releases, as well as staging packages that have not been accepted into Debian,
but may already be used by researchers.  Used in conjunction with the official
Debian snapshotting repository, it would allow for the reconstruction of
entire research environments or simply for installation of a particular
previous version of a product of interest.


.. _`Debian snapshotting service`: http://snapshot.debian.org/


Status
------

We have adapted http://snapshot.debian.org implementation to snapshot
NeuroDebian repository and snapshotting service was deployed on 2010-10-12.

.. todo:: NeuroDebian snapshotting service

   * Provide web-frontend to access existing snapshots within NeuroDebian
     website.

