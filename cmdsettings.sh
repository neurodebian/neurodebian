family=$1
dist=$2

# basic settings
cowbuilderroot="/home/neurodebian"
buildplace="${cowbuilderroot}/build"

# all currently supported dists
allnddists="nd+debian-bullseye nd+debian-bookworm nd+debian-trixie nd+debian-forky nd+debian-sid \
            nd+ubuntu-focal nd+ubuntu-jammy nd+ubuntu-noble nd+ubuntu-plucky"
alldists="$allnddists debian-bullseye debian-bookworm debian-trixie debian-forky debian-sid"

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
