#!/bin/bash

# A universal helper to enable NeuroDebian repository for a travis
# environment.
#
# Its purpose to remove all repetative actions from various .travis.yml spread
# across projects and gain control in the future to point  to an alternative,
# more appropriate for travis deployments, mirror.

# for the protocol
set -xe

# Update packaging
sudo apt-get update -qq

# To troubleshoot failing connections to neurodebian
sudo apt-get install net-tools traceroute coreutils
sudo traceroute -T neuro.debian.net
echo "Request non-existing uniq file to ease tracking this connection (for troubleshooting)"
echo "Date: `date`     Seed: $rseed"
rseed=$RANDOM
wget -q -O- http://neuro.debian.net/_files/neurodebian-travis.sh-$RANDOM-repo:$TRAVIS_REPO_SLUG-job:$TRAVIS_JOB_NUMBER || :

# Figure out what Ubuntu release travis environment is based on
sudo apt-get install lsb-release
cat /etc/lsb-release
source /etc/lsb-release

# Fetch the apt sources for the currently preferred mirror
wget -O- http://neuro.debian.net/lists/${DISTRIB_CODENAME}.us-nh.full | sudo tee /etc/apt/sources.list.d/neurodebian.sources.list
#wget -O- http://neuro.debian.net/lists/${DISTRIB_CODENAME}.de-md.full | sudo tee -a /etc/apt/sources.list.d/neurodebian.sources.list
sudo apt-key adv --recv-keys --keyserver pool.sks-keyservers.net 2649A5A9 \
 || { wget -q -O- http://neuro.debian.net/_static/neuro.debian.net.asc | sudo apt-key add -; }
sudo apt-get update -qq

# And provide a summary over which repositories are currently available
sudo apt-cache policy           # What is actually available?
