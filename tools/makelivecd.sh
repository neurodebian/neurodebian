#!bin/sh

set -e

# for a fresh build one might want to run:
# sudo rm -rf cache/stages_bootstrap chroot/ config/ scripts/ binary* .stage

# the Debian release to use as a basis for the live-cd
nd_basedist="lenny"
# the NeuroDebian archive key
nd_key="A5D32F012649A5A9"
# packages to be installed
nd_packages="\
amide caret dicomnifti \
fsl fsl-doc fslview fslview-doc \
iceweasel \
lipsia lipsia-doc via-bin \
minc-tools nifti-bin odin praat \
python-mvpa python-nifti python-pyepl \
xmedcon"


lh_config \
  --apt apt \
  --apt-recommends disabled \
  --architecture i386 \
  --binary-images iso \
  --binary-indices none \
  --bootstrap-flavour minimal \
  --categories "main contrib non-free" \
  --debian-installer disabled \
  --distribution ${nd_basedist} \
  --hostname debian \
  --iso-application NeuroDebian \
  --iso-publisher "NeuroDebian; http://neuro.debian.org" \
  --mirror-bootstrap "http://debian.lcs.mit.edu/debian/" \
  --packages-lists xfce \
  --packages "${nd_packages}" \
  --username neuro \
  --win32-loader enabled

# add the NeuroDebian repository to the APT setup
echo "deb http://neuro.debian.net/debian ${nd_basedist} main contrib non-free" \
    > config/chroot_sources/neurodebian.chroot
cp config/chroot_sources/neurodebian.chroot config/chroot_sources/neurodebian.binary
# and the key
gpg --export -a ${nd_key} > config/chroot_sources/neurodebian.chroot.gpg
cp config/chroot_sources/neurodebian.chroot.gpg config/chroot_sources/neurodebian.binary.gpg


# use NeuroDebian package cache
if [ ! -e "cache/packages_bootstrap" ]; then
  mkdir -p cache
  ln -s ../../debian_aptcache/ cache/packages_bootstrap
fi
