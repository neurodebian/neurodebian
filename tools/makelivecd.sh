#!bin/sh

set -e

# for a fresh build one might want to run:
# sudo rm -rf cache/stages_bootstrap chroot/ config/ scripts/ binary* .stage

# the Debian release to use as a basis for the live-cd
nd_basedist="squeeze"
# the NeuroDebian archive key
nd_key="A5D32F012649A5A9"
# packages to be installed
nd_packages="\
gnome-core mc evince bash-completion ntpdate file-roller gnome-utils \
gnome-themes eog vim \
software-center gdebi gedit-plugins gnome-media synaptic menu less \
amide caret dicomnifti \
fsl fsl-doc fslview fslview-doc \
iceweasel \
lipsia lipsia-doc via-bin \
minc-tools nifti-bin odin praat \
python-mvpa python-nifti python-pyepl \
xmedcon \
neurodebian-keyring
"


lb config \
  --apt apt \
  --apt-recommends disabled \
  --architecture i386 \
  --archive-areas "main contrib non-free" \
  --binary-images iso-hybrid \
  --binary-indices none \
  --bootstrap-flavour minimal \
  --debian-installer disabled \
  --distribution ${nd_basedist} \
  --hostname neurodebian \
  --iso-application "NeuroDebian Live" \
  --iso-preparer "NeuroDebian v.6.0.0; http://neuro.debian.net" \
  --iso-publisher "NeuroDebian project; http://neuro.debian.net" \
  --mirror-bootstrap "http://debproxy:9999/debian/" \
  --packages "${nd_packages}" \
  --repositories "http://neuro.debian.net/debian" \
  --username brain \
  --win32-loader enabled

  # --mirror-bootstrap "http://debian.lcs.mit.edu/debian/" \
  # --packages-lists xfce \

# May be
# Deploy 1:1 copy of the running Live system
# --debian-installer live

# Would be nice to have it utterly useful, but rescue is too bloated, may be
# at least forensics
# --packages-lists 

## add the NeuroDebian repository to the APT setup
#echo "deb http://neuro.debian.net/debian ${nd_basedist} main contrib non-free" \
#    > config/chroot_sources/neurodebian.chroot
#cp config/chroot_sources/neurodebian.chroot config/chroot_sources/neurodebian.binary
## and the key
#gpg --export -a ${nd_key} > config/chroot_sources/neurodebian.chroot.gpg
#cp config/chroot_sources/neurodebian.chroot.gpg config/chroot_sources/neurodebian.binary.gpg
#

## use NeuroDebian package cache
#if [ ! -e "cache/packages_bootstrap" ]; then
#  mkdir -p cache
#  ln -s ../../debian_aptcache/ cache/packages_bootstrap
#fi
