# Copyright (c) 2017, Yaroslav O. Halchenko. All rights reserved. MIT license
#
# The purpose of the Singularity environment is to provide a relatively full
# suite of tools provided primarily by Debian/NeuroDebian for runnin various
# neuroimaging analyses.
#
# Notes:
#  - Due to  https://github.com/singularityware/singularity/issues/471
#    bootstrapping leads to non-usable/non-removable-without-reboot
#    image due to some rogue run away processes.
#    This line could help to kill them but should be used with caution
#    since could kill other unrelated processes
#
#      grep -l loop /proc/*/mountinfo | sed -e 's,/proc/\(.*\)/.*,\1,g' | while read pid; do sudo kill $pid; done
#
# Set size to be 12000 on singularity-hub
#
# Changelog
# ---------
# 2.2
#  - fresh annex with patched git to avoid "Out of memory, getdelim failed" bug
#  - added some tools useful for debugging (gdb)
#  - additional mountpoints (/scratch)
#  - (note) pip is not installed on purpose, use the one within virtualenv(s)
# 2.x
#  - switch to stretch
#  - TODO make reproducible
#  - bids-validator from 0.22
#  - Added ants, convert3d
#
# TODOs
# -----
# - package bids-validator

BootStrap: debootstrap
OSVersion: stretch
MirrorURL: http://http.debian.net/debian/
#MirrorURL: http://smaug.datalad.org:3142/debian/

# so if image is executed we just enter the environment
%runscript
    echo "Welcome to the NeuroDebian v 2.2 (Debian stretch) environment"
    echo "Please source /etc/fsl/fsl.sh if you need FSL, /etc/afni/afni.sh if you need AFNI"
    /bin/bash

%post
    echo "Configuring the environment"
    sed -i -e 's, main$, main contrib non-free,g' /etc/apt/sources.list
    # For build-dep
    # sed -i -e 's,^deb \(.*\),deb \1\ndeb-src \1,g' /etc/apt/sources.list
    apt-get update
    apt-get -y install eatmydata 
    eatmydata apt-get -y install vim wget strace gdb valgrind time ncdu gnupg curl procps
    # eatmydata apt-get -y build-dep git
    wget -q -O/tmp/nd-configurerepo https://raw.githubusercontent.com/neurodebian/neurodebian/4d26c8f30433145009aa3f74516da12f560a5a13/tools/nd-configurerepo
    bash /tmp/nd-configurerepo
    chmod a+r -R /etc/apt
    eatmydata apt-get -y install git git-annex-standalone datalad python-nipype virtualenv dcm2niix python-dcmstack python-configparser python-funcsigs python-pytest connectome-workbench python-mvpa2 python-nilearn fsl-core fsl-atlases fsl-first-data mricron afni fsleyes ants convert3d heudiconv

    # for bids-validator
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
       eatmydata apt-get install -y nodejs
    npm install -g bids-validator@0.22.0
    chmod a+rX -R /usr/lib/node_modules/

    chmod a+rX -R /etc/apt/sources.list.d
    rm -rf /tmp/* /var/tmp/*
    apt-get clean

    # and wipe out apt lists since not to be used RW for further tuning
    # find /var/lib/apt/lists/ -type f -delete
    # /usr/bin/find /var/lib/apt/lists/ -type f -name \*Packages\* -o -name \*Contents\*
    # complicates later interrogation - thus disabled

    # Create some additional bind mount directories present on various compute boxes we have
    # access to, to ease deployment
    mkdir -p /afs /inbox /ihome /opt /data /backup /apps /srv /scratch
    chmod a+rX /afs /inbox /ihome /opt /data /backup /apps /srv /scratch
