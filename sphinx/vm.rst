.. _chap_vm:

NeuroDebian Virtual Machine
===========================

.. quotes::
   :random: 1
   :tags: vm

For those who are not yet running a Debian-based operation system we offer a
`virtual machine`_ that can be used with `VirtualBox`_, allowing users to benefit
from a Debian-based research environment on other operating systems.
This virtual machine initially comes as a compact Debian installation that can,
once installed, be equipped with a large variety of neuroscience software with
just a few mouse clicks (e.g. AFNI_, Caret_, FSL_, PyMVPA_).

.. _virtual machine: http://en.wikipedia.org/wiki/Virtual_machine
.. _AFNI: http://afni.nimh.nih.gov/afni/
.. _Caret: http://brainvis.wustl.edu/wiki/index.php/Caret:About
.. _FSL: http://www.fmrib.ox.ac.uk/fsl/
.. _PyMVPA: http://www.pymvpa.org


Downloads
---------

* `NeuroDebian 6.0.1 image (32bit)
  <http://neuro.debian.net/debian/vm/neurodebian_6.0.1_i386.zip>`_ [~560MB]

  *This image should work on virtually all systems that are supported by*
  VirtualBox_ *and can be used whenever the, otherwise preferable, 64bit image
  is not compatible with a host machine.*

* `NeuroDebian 6.0.1 image (64bit)
  <http://neuro.debian.net/debian/vm/neurodebian_6.0.1_amd64.zip>`_ [~570MB]

  *This image only works on 64bit host machines with active hardware
  virtualization support. The should include all recent Apple hardware and most
  64bit Windows systems.*

.. note::

  You can verify that you have downloaded archives correctly using
  `md5sums -c MD5SUMS
  <http://neuro.debian.net/debian/vm/MD5SUMS>`_ . You can also verify
  the authenticity of the `MD5SUMS
  <http://neuro.debian.net/debian/vm/MD5SUMS>`_ itself using `gpg
  --verify MD5SUMS.gpg
  <http://neuro.debian.net/debian/vm/MD5SUMS.gpg>`_ signed with
  NeuroDebian archive key.

* `VirtualBox download page <http://www.virtualbox.org/wiki/Downloads>`_ (Windows, Linux, Mac,
  Solaris)

  *This webpage offers installers of the VirtualBox application, as well as the
  documentation.*


Documentation
-------------

The virtual machine contains an installation of `Debian 6.0 (squeeze)`_ with a
GNOME_ desktop environment. All installed software comes from standard Debian
packages, or prospective Debian packages from NeuroDebian. This means that all
contained software is readily available for any system running a Debian
operating system (or a recent Ubuntu release). The virtual machine can be seen
as a showcase of what Debian for neuroscience research feels like. Moreover,
once downloaded this virtual machine can be kept up to date, just as any other
Debian installation. Using convenient graphical package management tools users
will benefit from security bug fixes provided by the Debian project for the
whole operating system, as well as from software updates for
neuroscience-related packages.

.. _Debian 6.0 (squeeze): http://www.debian.org/releases/squeeze
.. _GNOME: http://www.gnome.org/


Installation
~~~~~~~~~~~~

The following video shows how to get the NeuroDebian virtual machine running
on your machine. The installation is shown for Mac OS X. It should, however, be
very similar on a Windows box. If you cannot watch the video, please take a
look at the written instructions below.

.. raw:: html

  <iframe title="YouTube video player"
          class="youtube-player"
          type="text/html"
          width="640"
          height="375"
          src="http://www.youtube.com/embed/eqfjKV5XaTE?hd=1"
          frameborder="0"></iframe>

First download and install a recent version of VirtualBox_. VirtualBox is a
virtualization software that is freely available for Windows, MacOS X, Solaris,
and Linux. VirtualBox comes with a comprehensive manual that should answer
potential questions regarding installation and maintenance.

.. _VirtualBox: http://www.virtualbox.org

Next, download the most recent version of the NeuroDebian virtual machine from
the Downloads_ section. The machine is distributed as a zip file. Please
extract this file, using appropriate software for your operating system.
Once extracted, start VirtualBox and select "Import Appliance" from the file
menu.

.. image:: pics/vm_import_app.jpg

The next dialog will ask you to choose a virtual machine. Please navigate to the
extracted NeuroDebian download and select the `.ovf` file.

.. image:: pics/vm_import_wizard.jpg

You can finish importing of NeuroDebian by clicking on *next* a couple of
times.  There is no need to change anything, as we will get through the
settings in a second.  Importing of the virtual machine will take a short
while, as it is distributed in a compressed format that now gets extracted
(total extracted size about 2 GB).  Once imported, the NeuroDebian virtual
machine will appear in the list of available machines. Do **not** start it yet,
but select NeuroDebian and hit the *Settings* button. In the following dialog
you'll have a chance to configure the machine. You can assign the amount of RAM
that should be made available to it (for serious fMRI data processing, please
allow at least 2 GB). If you have a recent computer with multiple CPU cores,
you can also decide how many cores should be used by the virtual machine. If
you have a large screen you should increase the display memory to 32 MB in the
*Display* settings.

.. image:: pics/vm_add_host_folder.jpg

However, most important is the *Shared Folders* setup. Shared folders allow the
virtual machine to access the local harddrive of the host computer. This is an
easy way to access data on the computer without duplicating it or using the
network to access it. The virtual machine is preconfigured to access a shared
folder named labeled "host".  Click on the *add* button to select a folder that
shall be accessible by the machine (e.g. your home directory) and put "host" as
the folder name. Note, the folder name is simply a label. Your directory will
not be renamed.

.. image:: pics/vm_host_folder.jpg

Finally, close the settings dialog. You have now completed the setup, and you
can start the virtual machine by hitting the *Start* button. A new window will
appear showing the boot process. After a short while the NeuroDebian desktop
will appear, and a setup wizard will guide your through the final steps of the
configuration. You can now explore the system. The virtual machine is connected
with your host computer, and shares its Internet connection. Via this
connection you can update the contained software packages at any time.

.. image:: pics/vm_settings.jpg

The virtual machine logs yourself in automatically. The name of the virtual
machine user is `brain` and the password is `neurodebian`. The *root* password
is also `neurodebian`. In most cases, however, you should not be forced to type
the password, since `sudo` is configured to work without it.

.. note::

  For increased security you might want to change the default password. You can
  do so by opening a terminal window and running the ``passwd`` command.


Working with the virtual machine
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The next video is a demonstration of some basic desktop integration features.
It shows how to use the virtual machine in full-screen and seamless mode, shared
folder access, software installation, as well as suspending and resuming the
virtual machine.

.. raw:: html

  <iframe title="YouTube video player"
          class="youtube-player"
          type="text/html"
          width="640"
          height="375"
          src="http://www.youtube.com/embed/OV7fYSEoOeQ?hd=1"
          frameborder="0"></iframe>


Troubleshooting
~~~~~~~~~~~~~~~

I cannot hear sounds played in the virtual machine.

  By default the sound is muted. To enable playback launch the mixer applet by
  clicking on the mixer icon in the task bar. Unmute the master volume control.
  Now click on the "Volume control" to load the channel mixer dialog. Unmute
  the "Master" and "PCM" channels and raise the volume as desired. You should
  now be able to hear sounds played within the virtual machines through your
  host computer's speakers.
