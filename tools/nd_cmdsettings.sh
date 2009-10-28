family=$1
dist=$2

# basic settings
cowbuilderroot="/home/neurodebian"
buildplace="${cowbuilderroot}/build"

# all cuurently supported dists
alldists="nd+debian-sid nd+debian-squeeze nd+debian-lenny \
          nd+ubuntu-hardy nd+ubuntu-intrepid nd+ubuntu-jaunty \
          nd+ubuntu-karmic"

# default is debian
aptcache="${cowbuilderroot}/debian_aptcache"
components="main contrib non-free"
mirror="http://debian.lcs.mit.edu/debian"

# overwrite necessary bits for ubuntu
if [ "${family#nd+}" = "ubuntu" ]; then
  aptcache="${cowbuilderroot}/ubuntu_aptcache"
  components="main universe"
  mirror="http://ubuntu.media.mit.edu/ubuntu"
fi

if [ ! -d $aptcache ]; then mkdir $aptcache; fi
