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
  --debian-installer disabled \
  --distribution ${nd_basedist} \
  --hostname debian \
  --iso-application NeuroDebian \
  --iso-publisher "Debian Experimental Psychology Project; http://alioth.debian.org/projects/pkg-exppsy" \
  --mirror-bootstrap "http://ftp.uni-magdeburg.de/aftp/projects/linux/debian/" \
  --packages-lists lxde \
  --categories "main contrib non-free" \
  --username neuro \
  --packages "${nd_packages}"

# add the NeuroDebian repository to the APT setup
echo "deb http://apsy.gse.uni-magdeburg.de/debian ${nd_basedist} main contrib non-free" \
    > config/chroot_sources/neurodebian.chroot
cp config/chroot_sources/neurodebian.chroot config/chroot_sources/neurodebian.binary
# and the key
gpg --export -a ${nd_key} > config/chroot_sources/neurodebian.chroot.gpg
cp config/chroot_sources/neurodebian.chroot.gpg config/chroot_sources/neurodebian.binary.gpg
