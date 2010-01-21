NeuroDebian Virtual Machine
===========================

Those, who are not yet running a Debian-based operating system, but are already
tired of fiddling with dozens of neuro-software packages, can get a glimpse of
neuroscience research in a Debian environment via a `virtual machine`_.

.. _virtual machine: http://en.wikipedia.org/wiki/Virtual_machine

NeuroDebian offers a virtual machine that comes preinstalled with a number
of popular neuroscience packages (e.g. AFNI_, Caret_, FSL_, PyMVPA_).

.. _AFNI: http://afni.nimh.nih.gov/afni/
.. _Caret: http://brainvis.wustl.edu/wiki/index.php/Caret:About
.. _FSL: http://www.fmrib.ox.ac.uk/fsl/
.. _PyMVPA: http://www.pymvpa.org

The virtual machine contains an installation of `Debian 5.0 (lenny)`_ with a
GNOME_ desktop environment. All installed software comes from standard Debian
packages, or prospective Debian packages from NeuroDebian -- no custom
installations whatsoever. This means that all contained software is readily
available for any system running a Debian operating system (or recent Ubuntu
releases). The virtual machine can be seen as a showcase of what Debian for
neuroscience research feels like. Moreover, once downloaded this virtual
machine can be kept up to date, just as any other Debian installation. Using
convenient graphical package management tools users, will benefit from security
bugfixed for the whole operating system provided by the Debian project, as well
as software updates for neuroscience-related packages.

.. _Debian 5.0 (lenny): http://www.debian.org/releases/stable
.. _GNOME: http://www.gnome.org/


Installation
------------

First download and install a recent version of VirtualBox_. VirtualBox is a
virtualization software that is freely available for Windows, MacOS X, Solaris,
and Linux. VirtualBox comes with a comprehensive manual that should answer
potential questions regarding installation and maintenance.

.. _VirtualBox: http://www.virtualbox.org

Next, download the most recent version of the NeuroDebian virtual machine from
the `download page`_ (about 1GB download size). The machine is distributed as a
`tar` file. Please extract this file, using appropriate software for your
operating system. Every Linux system comes with the `tar` commandline utility,
and potentially other graphical archivers that can extract this format. MacOS X
users can simply double-click such file to extract it. Windows users can extract
it with, for example, 7zip_.

Once extracted, you'll find a directory with three files. Now start VirtualBox,
and select "Import Appliance" from the file menu.

.. _download page: http://neuro.debian.net/debian/vm
.. _7zip: http://www.7-zip.org/

.. image:: pics/vm_import_app.jpg

The next dialog will ask you to choose a virtual machine. Please navigate to the
extracted NeuroDebian download and select the `NeuroDebian.ovf` file.

.. image:: pics/vm_import_wizard.jpg

You can finished the import wizard by click on *next* a couple of times. There
is no need to change anything, as we will got through the settings in a second.
Importing the virtual machine will take a short while, as it is distributed in
a compressed format that now gets extracted (total extracted size about 3.5
GB).  Once imported, the NeuroDebian virtual machine will appear in the list of
available machines. Do **not** start it yet, but select NeuroDebian and hit the
*Settings* button. In the following dialog you'll have the chance to configure
the machine. You can assign the amount of RAM that should be made available to
it (for serious fMRI data processing, please allow at least 2 GB). If you have
a recent computer with multiple CPU cores, you can also decide how many cores
should be used by the virtual machine. If you have a large screen you should
increase the display memory to 32 MB in the *Display* settings.

.. image:: pics/vm_add_host_folder.jpg

However, most important is the *Shared Folders* setup. Shared folders allow the
virtual machine to access the local harddrive of the host computer. This is an
easy way to access data on a computer with the need to duplicate it or use the
network. The virtual machine is preconfigured to access a shared folder named
labeled "host". Simple click on the *add* button select a folder that shall be
accessible by the machine (e.g. your home directory) and put "host" as the
folder name. Note, the folder name is simply a label. Your directory will not
be renamed.

.. image:: pics/vm_host_folder.jpg

Finally, close the settings dialog. You have now completed the setup, and you
can start the virtual machine by hitting the *Start* button. A new window will
appear that shows the boot process. After a short while the NeuroDebian desktop
will appear. You can now explore the system. The virtual machine is connect
with your host computer, and shares its internet connection. Via this
connection you can update the contained software packages at any time.

.. warning::

  VirtualBox might offer you to upgrade the "guest additions" to version 3.1.2.
  Do **not** do this, since this version is broken, and after the upgrade you
  will now longer be able to use the mouse inside the virtual machine.

.. image:: pics/vm_settings.jpg

The virtual machine logs yourself in automatically. The name of the virtual
machine user is `brain` and the password is `neurodebian`. The *root* password
is also `neurodebian`.

Enjoy!
