family=$1
dist=$2

# basic settings
cowbuilderroot="/home/neurodebian"
buildplace="${cowbuilderroot}/build"

# all currently supported dists
allnddists="nd+debian-squeeze nd+debian-wheezy nd+debian-sid \
            nd+ubuntu-hardy nd+ubuntu-karmic nd+ubuntu-lucid nd+ubuntu-maverick nd+ubuntu-natty nd+ubuntu-oneiric nd+ubuntu-precise"
alldists="$allnddists debian-squeeze debian-wheezy debian-sid"

# default is debian
aptcache="${cowbuilderroot}/debian_aptcache"
components="main contrib non-free"
mirror="http://debian.lcs.mit.edu/debian"

# overwrite necessary bits for ubuntu
if [ "${family#nd+}" = "ubuntu" ]; then
  aptcache="${cowbuilderroot}/ubuntu_aptcache"
  components="main universe multiverse"
  mirror="http://ubuntu.media.mit.edu/ubuntu"
fi

if [ ! -d $aptcache ]; then mkdir -p $aptcache; fi
