family=$1
dist=$2

if [ -z "$family" ]; then
  echo "You need to provide a distribution family ('debian', 'ubuntu'); prefix with 'nd+' to enable the NeuroDebian repository."
  exit 1
fi

if [ -z "$dist" ]; then
  echo "You need to provide a distribution codename (e.g. 'lenny', 'squeeze')."
  exit 1
fi

# basic settings
cowbuilderroot="/home/cowbuilder"
buildplace="${cowbuilderroot}/build"

# default is debian
aptcache="${cowbuilderroot}/debian_aptcache"
components="main contrib non-free"
mirror="http://debian.lcs.mit.edu/debian"

# overwrite necessary bits for ubuntu
if [ "$family" = "ubuntu" ]; then
  aptcache="${cowbuilderroot}/ubuntu_aptcache"
  components="main universe"
  mirror="http://ubuntu.media.mit.edu/ubuntu"
fi

if [ ! -d $aptcache ]; then mkdir $aptcache; fi
