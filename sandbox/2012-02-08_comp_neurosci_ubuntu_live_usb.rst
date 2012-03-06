:date: 2012-02-08 19:02:00
:tags: neuroscience, computational neuroscience, ubuntu, software, live cd, usb disk, linux distribution

.. _chap_comp_neurosci_ubuntu_live_usb:

A Live Ubuntu/NeuroDebian USB Stick for Computational Neuroscience
====================================================================

 .. image:: screenshot-genesis-neuron-xpp.png
	:width: 150px
	:alt: View of the desktop running GENESIS, Neuron and XPPAUT
	:align: right
	:target: screenshot-genesis-neuron-xpp.png

I prepared an `Ubuntu 11.04`_/NeuroDebian_ live image with computational neuroscience tools for mainly use in USB sticks. This live image will let you run a full `Live Ubuntu Linux`_ system **without installing anything on your hard drives**, and it includes `persistent storage`_ that **maintains new files and packages across reboots**. The system is bundled with several computational neuroscience tools like GENESIS_, NEURON_ and XPPAUT_. It is made to fit in USB sticks of size >1GB. To use it, you will have to restart your PC with the USB stick inserted. After you turn on your computer, you will possibly also need to bring up your boot menu and choose to boot from the USB stick (most likely by pressing F10 or F12). 

.. _`Ubuntu 11.04`: http://help.ubuntu.com/11.04/ubuntu-help/index.html
.. _GENESIS: http://www.genesis-sim.org/GENESIS/
.. _NEURON: http://neuron.duke.edu/
.. _XPPAUT: http://www.math.pitt.edu/~bard/xpp/xpp.html
.. _NeuroDebian: http://neuro.debian.net
.. _`Live Ubuntu Linux`: http://help.ubuntu.com/community/LiveCd
.. _`persistent storage`: http://help.ubuntu.com/community/LiveCD/Persistence

*Note: You do not have to reboot your computer if you have a virtual machine* (e.g., `VirtualBox <http://www.virtualbox.org>`_, `VMware <http://www.vmware.com/>`_, etc.) *and you can point it boot from the USB stick.*

.. warning:: 
 In general, a USB stick is not preferable media for a day-to-day use of Linux because flash memory has a short lifetime (on the order of about several months to a year, based on usage). In addition to the chance of hardware failure over a long time frame, the Ubuntu Live CD also has a tendency to slowly `get corrupted over time`_, but with special care taken, it can be used safely. 

As a first precaution, the USB stick should be routinely backed up. You can also copy your files over to your hard drive. To improve performance, it is even possible to transfer the persistent storage to your hard drive. See below for details.

.. _`get corrupted over time`: http://bugs.launchpad.net/ubuntu/+source/upstart/+bug/125702

.. attention::
 RULES FOR KEEPING YOUR FILES SAFE:

 1. NEVER YANK OUT THE USB STICK WHILE UBUNTU IS RUNNING. PERFORM PROPER "SHUTDOWN" FIRST.

 2. REGULARLY BACKUP DATA FROM USB STICK ONTO HARD DRIVE

*Disclaimer: I take no responsibility over lost data whatsoever. By using this image, you assume all responsibility of your data.*

Installing the ISO image onto a USB flash drive:
------------------------------------------------
Download the ISO image from the `NeuroDebian Derivatives page`_. Use a
utility like UNetBootin_ to install the ISO image on your USB
drive. Keep the persistent space setting at zero, as otherwise it
will overwrite our image. *Simply extracting the ISO would not work as
the media needs to be set to bootable.*

.. _UNetBootin: http://unetbootin.sourceforge.net/
.. _`NeuroDebian Derivatives page`: http://neuro.debian.net/derivatives.html

Copying files to your hard drives:
-----------------------------------
Open the file browser by clicking on the home icon in the left sidebar on the Desktop. In the file browser window, you should be able to see your hard drives on the left sidebar. When you click on them, they will be "mounted" (i.e., become visible) and show up as directories under /media. Then, you can copy files back and forth.

Backing up the persistent storage that holds your files:
--------------------------------------------------------
Do this routinely to save your new files on the USB stick:

1. While running your favorite PC operating system, insert USB stick 

2. Copy file "casper-rw" on your Desktop, preferably with a date

To restore it, copy it back on the USB and make sure it's named "casper-rw"

Transferring the persistent storage to your hard drive:
---------------------------------------------------------------

1. While running any host operating system, insert USB stick 

2. Copy file "casper-rw" to the root of one of your hard disks (e.g. C:\\casper-rw). Ubuntu will find it and use it from there. Keep on making backups of it as it can still get corrupted over time.

3. Delete or rename "casper-rw" to something else on the USB stick so your hard disk copy is used.

4. At any time, you can copy your hard disk copy back onto the USB stick

What to do in case of corruption and boot failure:
--------------------------------------------------------
You can either:

1a. Copy your backed up "casper-rw" file onto the USB disk. You will lose your changed files since last backup.

1b. Boot the USB stick by choosing a non-persistent boot option from the Ubuntu boot disk and perform a filesystem check. Once you get a terminal. Issue:

::

 $ sudo su -

Which should give you root access. And then run the disk check:

::

 # e2fsck -p /cdrom/casper-rw

Press "y" and enter for the questions that it asks. Should not ask
more than 10-20 of them. After this you should be able to reboot back
into the Live Ubuntu.

Installing Ubuntu completely on your hard drive for dual booting
----------------------------------------------------------------
Click on the "Install Ubuntu 11.04" link on the Desktop and follow the instructions.

Other troubleshooting:
----------------------
This Live USB Stick is completely based on a Ubuntu 11.04 Live CD
distribution. Please refer to their thorough documentation for further
issues: https://help.ubuntu.com/community/LiveCD

.. admonition:: Revision History

 *v2*, by CG on 2012-03-06
  Included the NeuroDebian repository, and installed
  XPPAUT and python-brian (with all python dependencies for
  computational modeling) packages.

 *v1*, by CG on 2012-01-31
  Initial version with manual installations of GENESIS, NEURON and
  XPPAUT onto Ubuntu 11.04 Live CD.  

.. admonition:: Created by...

  | Created for use at the `Emory University <http://www.emory.edu>`_ BIO450/IBS534 Computational Neuroscience Course by Cengiz Gunay <cgunay AT emory.edu>, <cengique AT users.sf.net>

 .. image:: CC_by_3.0_88x31.png
	:alt: Creative Commons License
	:align: left
	:target: http://creativecommons.org/licenses/by/3.0/

 This Live Comp Neurosci Ubuntu/NeuroDebian USB Stick contains free and open-source software provided by Ubuntu GNU/Linux and NeuroDebian_ repositories, which are distributed with their own respective licenses. The distribution of this image with the added computational neuroscience tools is licensed by Cengiz Gunay under a `Creative Commons Attribution 3.0 Unported License <http://creativecommons.org/licenses/by/3.0/>`_. This means you can customize and redistribute this image as long as you say that you originally took it from here.



