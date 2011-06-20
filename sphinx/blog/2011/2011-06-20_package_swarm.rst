:date: 2011-06-20 20:00:00
:tags: debian, neuroscience, download stats

Package swarm
=============

We are working on integrating neuroscience research software into the Debian
operating system for almost six years now. Occasionally looking at the
repository web server logs, we knew that a growing number of people were
using the packages from http://neuro.debian.net for their Debian and Ubuntu
machines. However, we never really looked deeper.

For our upcoming `booth at HBM2011`_ we need something like a presentation or
slides that could run in a loop on a big screen to attract people. It would
need to be visually appealing, but also informative. As slides are rather boring,
we looked into creating an animation -- a visualization of our repository
download statistics.

There are many boring ways to visualize this type of data, but there is also at
least one that is cool enough to yield an appealing, almost mystical,
animation: code_swarm_. This great software can visualize somewhat "social"
processes based on commit statistics of source code repositories. It extracts
information on who is working on which files of a project at any given point in
time, and visualizes similarities in these patterns. People that work on the
same files in temporal proximity cluster together, and files that are modified
by the same people cluster together. From all this information code_swarm
generates `beautiful animations`_.

Download statistics are not that different from commit statistics. Instead of
"Who is modifying what?" it is simply: "Who is downloading what?" So we gathered
all Apache logs of binary package downloads from our repository over the last
two years. We converted the data so that the corresponding source package,
became the "author" of a commit/download, and encoded the associated IPv4
address (the last 8 bit truncated) together with the target distribution as the
"modified file". And code_swarm did the rest (try watching in 480p or above):

.. raw:: html

  <iframe title="YouTube video player"
          class="youtube-player"
          type="text/html"
          width="640"
          height="375"
          src="http://www.youtube.com/embed/dp42rrkrNBI?hd=1"
          frameborder="0"></iframe>

Few notes on the video: The animation shows some spikes in the download
activity. Most of the big ones are related to new releases of FSL_. FSL is
undoubtedly our most popular package. First and foremost, because it is one of
*the* standard tools for brain-imaging research, but also, because upstream
completely relies on NeuroDebian for deploying FSL on the Debian platform.

It looks like the majority of our downloads comes from countless Ubuntu
machines -- maybe laptops and desktops with dynamic IPs. However, there are
also fairly/large deployments of Debian 6.0 (white) and Ubuntu 10.04 (light
blue) with static addresses -- probably labs at research institutions. Watch
for the large "stars" towards the end.

You might have noticed the yellow dots. These are downloads from the *data*
suite of the NeuroDebian which we use to improve space-efficiency of our
repository. This suite has packages (sometimes the size of 1GB in compressed
form) that can be installed on any Debian or Ubuntu release and contain only
data of various types and formats. Of course many applications depend on these
packages, hence you can see some dots constantly changing color between yellow
and one of the release colors.

PS: OpenShot_ became an amazing video editor!

.. _booth at HBM2011: http://www.debian.org/events/2011/0626-hbm
.. _code_swarm: http://code.google.com/p/codeswarm/
.. _beautiful animations: http://www.michaelogawa.com/code_swarm/
.. _openshot: http://packages.debian.org/sid/openshot
.. _fsl: http://packages.debian.org/sid/fsl
