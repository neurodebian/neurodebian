Standard Debian install

hostname: neurodebian
domain: ''

all file in one partition

root: not there
user: brain
pwd: neurodebian


Do a minimal install
--------------------

All files in one partition/
just base system, run selection, but no tasks (not even 'Standard system')


install new stuff
-----------------

Add sources.list for backports and neurodebian
wget -O /etc/apt/sources.list.d/neuro.debian.net.list http://neuro.debian.net/_static/neurodebian.lenny.us.sources.list
echo "deb http://www.backports.org/debian lenny-backports main contrib non-free" >> /etc/apt/sources.list.d/backports.org.list
wget -O - http://backports.org/debian/archive.key | apt-key add -
wget -O - http://neuro.debian.net/_static/neuro.debian.net.asc | apt-key add -

install kernel 2.6.27 (or later) from backports to have support for OpenGL
direct rendering in VirtualBox
(and deinstall the old one, after a successfull reboot)

# a basic desktop
aptitude install \
 alacarte desktop-base evince file-roller gcalctool gdm gksu gnome-core
 gnome-keyring gnome-utils gnome-volume-manager gnome-mount gthumb
 bash-completion less mc gnome-themes etckeeper git-core gitk ntpdate

# cleanup unwanted stuff
# video drivers (all but vesa)
aptitude purge $(apt-cache search --names-only --installed xserver-xorg-video | grep xserver-xorg-video | cut -d ' ' -f 1,1) xserver-xorg-video-vesa+
# random stuff
aptitude purge radeontool sound-juicer

# setup etckeeper
etckeeper init

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
# (make sure there is nothing below it)

# configure shared folders
mkdir /mnt/host
mount -t vboxsf host /mnt/host
# better put the following into the session startup config of the user
sudo mount -t vboxsf -o defaults,uid=brain,gid=brain host /mnt/host


# neuro-stuff
aptitude install afni afni-atlases amide caret dicomnifti fsl fsl-atlases lipsia
 minc-tools odin psychopy python-mvpa python-pyepl

# general scientifically useful stuff
aptitude install ipython python-h5py


user config
-----------
# put use home dir in git to be able to track changes
git init

mkdir -p /home/brain/.config/backgrounds
cp /mnt/host/.config/awesome/hotbrain.png /home/brain/.config/backgrounds/

#change menu icon
sudo cp /mnt/host/hacking/neurodebian/artwork/icon.svg /usr/share/icons/Mist/scalable/places/start-here.svg


Deploy
------

# shrink VDI image by writting to a new (unfragmented) image
# target VDI needs to have proper partition table and MBR

# clone HDD
#dd if=dev/hda of=/dev/hdb bs=512 count=1
# fixing bits extended partition is empty -> create swap partition
#fdisk /dev/hdb
#mkswap /dev/hdb5
#mkfs.ext3 -m 1 /dev/hdb1
#tune2fs -c 100 /dev/hdb1


cd /tmp
cp /home/neurodebian/vm/nd_plainpartition.vdi nd_hdd.vdi
mkdir -p vbdev/src vbdev/dest vbmnt/src vbmnt/dest

# get access to disks inside the VDIs
sudo vdfuse -f /home/neurodebian/vm/nd_master.vdi vbdev/src/
sudo vdfuse -f nd_hdd.vdi vbdev/dest/



# mount partititions
sudo mount -o loop vbdev/src/Partition1 vbmnt/src
sudo mount -o loop vbdev/dest/Partition1 vbmnt/dest

# now extract files from src, filter, and move to dest
sudo rsync -xaHD --delete \
  --exclude=dev \
  --exclude=proc \
  --exclude=tmp \
  --exclude=var/cache/apt \
  --exclude=var/log/* \
  --exclude=etc/.git \
  --exclude=home/brain/.git \
  --exclude=var/lib/apt/lists \
  vbmnt/src/ vbmnt/dest/

sudo umount vbmnt/dest
sudo umount vbmnt/src
sudo umount vbdev/dest
sudo umount vbdev/src

