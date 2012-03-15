:date: 2012-03-09 18:00:00
:tags: neuroscience, software, imaging, fsl, condor, distributed computing

.. _chap_parallelize_fsl_with_condor:

Parallelizing FSL -- without the pain
=====================================

FSL_ is a very popular analysis suite for neuroimaging data. Unfortunately,
right out of the box FSL's routines do not make good use of today's multi-core
machines.  Consequently, researchers using FSL on individual workstations have
difficulties harnessing the computing power of their equipment.

.. _FSL: http://www.fmrib.ox.ac.uk/fsl/

However, it is not the case that FSL doesn't support modern computing
environments. It is actually one of very few packages that come with built-in
support for running computations on a cluster back-end. Unfortunately, it relies
on the GridEngine_ software (formerly Sun, now from Oracle) to be installed
locally, and configured properly. This is a task that is known to be
non-trivial and can cause serious headache in a neuroscientist. While FSL has
been ported to use other batch systems, such as Torque_, none of them is much
easier to deploy.

.. _GridEngine: http://www.oracle.com/us/products/tools/oracle-grid-engine-075549.html
.. _Torque: http://www.adaptivecomputing.com/products/torque.php

What would be helpful is a batch system that can be easily installed without
complicated configuration procedures. Preferably, such a system is powerful
enough to scale across multiple machines, whenever the demand for computing
power increases. At NeuroDebian_ we looked at a number of projects and found
Condor_ to be the most versatile tools, yet still straightforward to use in a
single-machine scenario.

.. _NeuroDebian: http://neuro.debian.net
.. _Condor: http://research.cs.wisc.edu/condor/

Over the past two years we have been working on getting Condor packaged for
Debian. We are now very proud to announce that, a few days ago, Condor has been
accepted as an `official Debian package`_ (in Debian experimental for the time
being). NeuroDebian, as usual, `provides backports`_ of Condor for numerous
Debian and Ubuntu releases.

.. _official Debian package: http://packages.debian.org/condor
.. _provides backports: http://neuro.debian.net/pkgs/condor.html

With the availability of Condor packages, parallelizing FSL on a local
workstation is now possible by following a simple four-step procedure.


1. Configure your machine to use the NeuroDebian repository
-----------------------------------------------------------

[ if you are already a NeuroDebian user you can skip this step ]

Go to http://neuro.debian.net and follow the setup instructions given on the
front-page. This means selecting your Debian or Ubuntu release, select a package
repository mirror close to you, and run the little shell script snippet that is
presented to you. After having updated you package lists you are ready to go.

If you are not running Debian or Ubuntu on your machine, you can also install
the `NeuroDebian virtual machine`_ which is able to utilize multiple CPU-cores.
The remaining setup steps apply to VM users as well.

.. _NeuroDebian virtual machine: http://neuro.debian.net/vm.html


2. Install FSL
--------------

[ if you already have the latest FSL package version, you can skip this too ]

Open a terminal and install FSL being running the command::

  % sudo apt-get install fsl

Of course you can also use any graphical package manager front-end (e.g.
software center). The terminal commands are simply used for clarity and
simplicity.

Check what version of FSL got installed. Any version from 4.1.9-2 onwards is
fine. If you got an older version, you either haven't succeeded doing step 1,
or you are running a version of Debian or Ubuntu that is too old, and you would
need to upgrade it first.


3. Install Condor
-----------------

Install Condor with::

  % sudo apt-get install condor

Any Condor package version from 7.7.4-1 onwards comes with all necessary
features. During installation a few question will be asked. You should enable
the Debconf-based configuration and ask for a "Personal Condor" installation
(see screenshots).

.. image:: pics/blog/condor_install1.png

.. image:: pics/blog/condor_install2.png


Now you have a fully functional Condor installation that advertises one compute
slot per detected CPU-core on your machine. You can display the current status
with the ``condor_status`` command. On a dual-core machine this could look like
this::

  % condor_status

  Name               OpSys      Arch   State     Activity LoadAv Mem   ActvtyTime

  slot1@meiner       LINUX      INTEL  Owner     Idle     0.320  1972  0+00:00:04
  slot2@meiner       LINUX      INTEL  Owner     Idle     0.000  1972  0+00:00:05
                       Total Owner Claimed Unclaimed Matched Preempting Backfill

           INTEL/LINUX     2     2       0         0       0          0        0

                 Total     2     2       0         0       0          0        0

By default, Condor will only run jobs when the machine is idle. If you want to
run jobs immediately when they are submitted you need to change the
configuration slightly. To do this run::

  % sudo dpkg-reconfigure condor

This will again ask a number of questions. Leave everything on the respective
defaults, but enable running jobs regardless of other machine activity (see
screen shot below).

.. image:: pics/blog/condor_install3.png


4. Enjoy parallelized FSL
-------------------------

Now you are ready to make use of Condor with FSL. Source the configuration
from ``/etc/fsl/fsl.sh`` as usual::

  % . /etc/fsl/fsl.sh

Whenever you want FSL to parallelize jobs through Condor, simply set the
:envvar:`FSLPARALLEL` environment variable to ``condor`` and run FSL as usual::

  % export FSLPARALLEL=condor

You can check whether the setup is working by running ``condor_q`` to see the
list of submitted/running jobs. Running the FEAT part of the FSL-FEEDS test
suite could look like this::

  % condor_q

  -- Submitter: meiner : <127.0.0.1:52379> : meiner
   ID      OWNER            SUBMITTED     RUN_TIME ST PRI SIZE CMD
     1.0   michael         3/9  14:47   0+00:00:07 R  0   0.7  zsh -c /usr/share/
     2.0   michael         3/9  14:47   0+00:00:00 H  0   0.7  zsh -c /usr/share/
     3.0   michael         3/9  14:47   0+00:00:01 R  0   0.0  cluster2_sentinel.
     4.0   michael         3/9  14:47   0+00:00:00 H  0   0.7  zsh -c /usr/share/
     5.0   michael         3/9  14:47   0+00:00:01 R  0   0.0  cluster4_sentinel.
     6.0   michael         3/9  14:47   0+00:00:00 H  0   0.7  zsh -c /usr/share/
     7.0   michael         3/9  14:47   0+00:00:01 R  0   0.0  cluster6_sentinel.
     8.0   michael         3/9  14:47   0+00:00:00 H  0   0.7  zsh -c /usr/share/
     9.0   michael         3/9  14:47   0+00:00:01 R  0   0.0  cluster8_sentinel.
    10.0   michael         3/9  14:47   0+00:00:00 H  0   0.7  zsh -c /usr/share/
    11.0   michael         3/9  14:47   0+00:00:01 R  0   0.0  cluster10_sentinel

  11 jobs; 0 completed, 0 removed, 0 idle, 6 running, 5 held, 0 suspended


Done
----

There is obviously much more that could be said about other exciting features
of Condor, but we will leave this for another blog post in the future. As a
little teaser we could mention that the Debian Condor package comes with an
emulator of SGE's ``qsub``. Through this adaptor many software that can make use
of SGE can also be used with Condor, for example NiPyPE_...

.. _NiPyPE: http://nipy.sourceforge.net/nipype/

If you are now keen on exploring the possibilities of Condor, take a look at the
manual that comes in the ``condor-doc`` package.
