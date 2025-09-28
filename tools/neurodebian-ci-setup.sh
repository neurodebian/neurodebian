#!/bin/bash

# A universal helper to enable NeuroDebian repository for CI environments
# (originally Travis, then also GitHub Actions).
#
# Its purpose to remove all repetative actions from various CI
# workflows spread across projects and gain control in the future to point to
# an alternative, more appropriate for CI deployments, ND mirror.

# for the protocol
set -xe
set -o pipefail

touch /i-am-root 2>/dev/null && { rm "/i-am-root"; sudo=""; } || sudo="sudo"

# Update packaging
$sudo apt-get update -qq

# To troubleshoot failing connections to neurodebian and ensure presence of needed tools
$sudo apt-get install -y net-tools traceroute coreutils wget curl gnupg dirmngr
$sudo traceroute -T neuro.debian.net
echo "Request non-existing uniq file to ease tracking this connection (for troubleshooting)"
rseed=$RANDOM

ci_details=""
[ -z "${GITHUB_REPOSITORY:-}${GITHUB_RUN_ID:-}" ] || \
    ci_details+=":${GITHUB_REPOSITORY/\//--}-job:$GITHUB_RUN_ID"
[ -z "${TRAVIS_REPO_SLUG:-}${TRAVIS_JOB_NUMBER:-}" ] || \
    ci_details+=":$TRAVIS_REPO_SLUG-job:$TRAVIS_JOB_NUMBER"

echo "Date: $(date)     Seed: $rseed"
wget -q -O/dev/null --user-agent "Wget ($ci_details)" \
    "http://neuro.debian.net/_files/neurodebian-ci-setup.sh" || :

# Figure out what Ubuntu release environment is based on
$sudo apt-get install -y lsb-release
cat /etc/lsb-release
source /etc/lsb-release

# Fetch the apt sources for the currently preferred mirror
wget -O- "http://neuro.debian.net/lists/${DISTRIB_CODENAME}.us-nh.full" | $sudo tee /etc/apt/sources.list.d/neurodebian.sources.list

if [ -e "/etc/apt/trusted.gpg.d/" ]; then
    # new way -- just dump keyring there from our site copy
    $sudo wget -q -O/etc/apt/trusted.gpg.d/neuro.debian.net.asc http://neuro.debian.net/_static/neuro.debian.net.asc 
else
    # add old key old way
    $sudo apt-key adv --recv-keys --keyserver hkps://keyserver.ubuntu.com 0xA5D32F012649A5A9 \
    || { wget -q -O- http://neuro.debian.net/_static/neuro.debian.net.asc | $sudo apt-key add -; }
fi

$sudo apt-get update -qq

# And provide a summary over which repositories are currently available
$sudo apt-cache policy           # What is actually available?
