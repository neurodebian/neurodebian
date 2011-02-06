.. -*- mode: rst; fill-column: 78 -*-
.. ex: set sts=4 ts=4 sw=4 et tw=79:

.. _project_debtest:

*************************
Thorough testing: DebTest
*************************

Ideally software comes with an exhaustive test suite that can be used to
determine whether this particular software works as expected on the Debian
platform. However, especially for complex software, these test suites are often
resource hungry (CPU time, memory, disk space, network bandwidth) and cannot be
ran at package build time by Debian's buildds. Consequently, test suites are
typically utilized manually and only by the respective packager on a particular
machine, before uploading a new version to the archive.

However, Debian is an integrated system and packaged software typically relies
on functionality provided by other Debian packages (e.g. shared libraries)
instead of shipping duplicates with different versions in every package -- for
many good reasons. Unfortunately, there is also a downside to this: Debian
packages often use versions of 3rd-party tools that are different from those
tested by upstream, and moreover, the actual versions of dependencies might
change frequently between subsequent uploads of a dependent package.  Currently
a change in a dependency that introduces an incompatibility cannot be detected
reliably even if upstream provides a test suite that would have caught the
breakage.  Therefore integration testing heavily relies on users to detect
incorrect functioning and file bug reports. Although there are archive-wide QA
efforts (e.g. constantly rebuilding all packages) these tests can only detect
API/ABI breakage or functionality tested during build-time checks -- they are
not exhaustive for the aforementioned reasons.

This is a proposal to, first of all, package upstream test suites in a way that
they can be used to run expensive archive-wide QA tests. However, this is also
a proposal to establish means to test interactions between software from
multiple Debian packages to provide more thorough continued integration and
regression testing for the Debian systems.


To address these open issues we are working on *DebTest* -- a framework with
conventions and tools that allow Debian to distribute test batteries developed
by upstream or Debian developers. It aims at complementing existing QA efforts
by going beyond single-package, build-time tests and cover interactions between
software from multiple Debian packages to provide more thorough continued
integration and regression testing for the Debian systems DebTest aims to
enable developers and users to perform extensive testing of a deployed Debian
system or a particular software of interest in a uniform fashion.


Status
------

The project is still in an early conceptual stage. We are currently working on
a SPEC_ draft that will be submitted to the Debian community for further
discussion of the desired properties of a more comprehensive testing framework.
Furthermore, we started looking for existing (free) software solutions that
might be used to implement such a framework.

We have already started packaging :ref:`versatile datasets <full_dataset_list>`
that can be used to develop test suites.


.. todo:: DebTest

  * Finish the SPEC_.
  * Initiate discussion.
  * Identify and package relevant neuroscience datasets that can be used to
    develop multi-software regression/pipeline tests.

.. _SPEC: http://git.debian.org/?p=pkg-exppsy/neurodebian.git;a=blob_plain;f=sandbox/proposal_regressiontestframwork.moin


References
----------

* :ref:`full_dataset_list`
* `DebTest discussions on debian-devel <http://lists.debian.org/debian-devel/2011/01/msg00704.html>`_

.. include:: link_names.txt
