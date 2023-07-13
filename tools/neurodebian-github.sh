#!/bin/bash

# A universal helper to enable NeuroDebian repository for a GitHub Actions
# environment.
#
# Its purpose to remove all repetative actions from various GitHub Actions
# workflows spread across projects and gain control in the future to point to
# an alternative, more appropriate for GitHub Actions deployments, mirror.

# for the protocol
set -xe

# Update packaging
sudo apt-get update -qq

# To troubleshoot failing connections to neurodebian
sudo apt-get install net-tools traceroute coreutils
sudo traceroute -T neuro.debian.net
echo "Request non-existing uniq file to ease tracking this connection (for troubleshooting)"
rseed=$RANDOM
echo "Date: `date`     Seed: $rseed"
wget -q -O- http://neuro.debian.net/_files/neurodebian-travis.sh-$RANDOM-repo:${GITHUB_REPOSITORY/\//--}-job:$GITHUB_RUN_ID || :

# Figure out what Ubuntu release GitHub environment is based on
sudo apt-get install lsb-release
cat /etc/lsb-release
source /etc/lsb-release

# Fetch the apt sources for the currently preferred mirror
wget -O- http://neuro.debian.net/lists/${DISTRIB_CODENAME}.us-nh.full | sudo tee /etc/apt/sources.list.d/neurodebian.sources.list
#wget -O- http://neuro.debian.net/lists/${DISTRIB_CODENAME}.de-md.full | sudo tee -a /etc/apt/sources.list.d/neurodebian.sources.list
sudo apt-key adv --recv-keys --keyserver hkps://keyserver.ubuntu.com 0xA5D32F012649A5A9 \
 || { wget -q -O- http://neuro.debian.net/_static/neuro.debian.net.asc | sudo apt-key add -; }
sudo apt-get update -qq

# And provide a summary over which repositories are currently available
sudo apt-cache policy           # What is actually available?
