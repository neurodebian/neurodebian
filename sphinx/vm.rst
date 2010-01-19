Standart Debian install

hostname: neurodebian
domain: ''

all file in one partition

root: not there
user: brain
pwd: neurodebian


Do a minimal install
--------------------

make separte vdi images for

* /
* /tmp
* /var/cache/apt
* swap

just base system, run selection, but no tasks


install new stuff
-----------------

Add sources.list for backports and neurodebian

wget -O - http://backports.org/debian/archive.key | apt-key add -
wget -O - http://neuro.debian.net.asc | apt-key add -

install kernel 2.6.27 (or later) from backports to have support for OpenGL
direct rendering in VirtualBox

# a basic desktop
aptitude install \
 alacarte desktop-base evince file-roller gcalctool gdm gksu gnome-core
 gnome-keyring gnome-utils gnome-volume-manager gnome-mount gthumb
 bash-completion less mc gnome-themes

# cleanup unwanted stuff
# video drivers (all but vesa)
aptitude purge $(apt-cache search --names-only --installed xserver-xorg-video | grep xserver-xorg-video | cut -d ' ' -f 1,1) xserver-xorg-video-vesa+
# random stuff
aptitude purge radeontool sound-juicer

# prepare for kernel module building (guest additions)
aptitude install module-assistant
module-assistant prepare
bash /media/cdrom/VBoxLinuxAdditions-amd64.run (need 2.6.27+ kernel for direct rendering)

#make sure that xorg.conf has 'vboxvideo' as device driver and also
echo "vboxvideo" >> /etc/modules

# make user brain allowed to execute sudo without a password
adduser brain sudo
visudo
# and uncomment the respective line at the end of the file
# (make sure there is nothing below it

# configure shared folders
mkdir /mnt/host
mount -t vboxsf host /mnt/host
# better put the following into the session startup config of the user
sudo mount -t vboxsf -o defaults,uid=brain,gid=brain host /mnt/host


# neuro-stuff
aptitude install afni afni-atlases amide caret dicomnifti fsl fsl-atlases lipsia
 minc-tools odin psychopy python-mvpa python-pyepl

# general scientifically useful stuff
aptitude install ipython

mkdir -p .config/backgrounds
cp /mnt/host/.config/awesome/hotbrain.png .config/backgrounds/

#change menu icon
sudo cp /mnt/host/hacking/neurodebian/artwork/icon.svg /usr/share/icons/Mist/scalable/places/start-here.svg


Deploy
------

# shrink VDI image by writting to a new (unfragmented) image
# target VDI needs to have proper partition table and MBR
# XXX maybe 'dd' could be used on the fuse-mounted VDIs
sudo ~/vdfuse-v60 -f ~/.VirtualBox/HardDisks/NeuroDebian.vdi mnt/src
sudo ~/vdfuse-v60 -f ~/.VirtualBox/HardDisks/nd_test.vdi mnt/dest
sudo mount -o loop mnt/src/Partition1 src
sudo mount -o loop mnt/dest/Partition1 dest
rsync -vxaHD --delete --exclude=src/dev --exclude=src/proc --exclude=src/tmp src dest
