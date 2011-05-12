
Scientific software usage in neuroscience research
==================================================

.. raw:: html

   <script language="Javascript">
   function xmlhttpPost(strURL) {
       var xmlHttpReq = false;
       var self = this;
       // Mozilla/Safari
       if (window.XMLHttpRequest) {
           self.xmlHttpReq = new XMLHttpRequest();
       }
       // IE
       else if (window.ActiveXObject) {
           self.xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
       }
       self.xmlHttpReq.open('POST', strURL, true);
       self.xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
       self.xmlHttpReq.onreadystatechange = function() {
           if (self.xmlHttpReq.readyState == 4) {
               updatepage(self.xmlHttpReq.responseText);
           }
       }
       self.xmlHttpReq.send(getquerystring());
   }

   function getquerystring() {
       var form     = document.forms['f1'];
       var word = form.word.value;
       qstr = 'w=' + escape(word);  // NOTE: no '?' before querystring
       return qstr;
   }

   function updatepage(str){
       document.getElementById("result").innerHTML = str;
   }
   </script>

   <form name="nss_survey" enctype="application/x-www-form-urlencoded">

Personal background
-------------------

.. raw:: html

   <table>
   <tr class="oddrow">
   <td>

Which country are working in?

.. raw:: html

   </td><td class="response">

.. raw:: html
   :file: select_country.inc

.. raw:: html

   </td></tr><tr><td>

Where are you working?

.. raw:: html

   </td><td class="response">
   <select name="position" size="1">
   <option value="none" selected="selected" label="Select an option"></option>
   <option value="edu_priv" label="Higher education (privately funded)"></option>
   <option value="edu_pub" label="Higher education (publicly funded)"></option>
   <option value="research_priv" label="Research institution (privately funded)"></option>
   <option value="research_pub" label="Research institution (publicly funded)"></option>
   <option value="company" label="Company"></option>
   </select>
   </td></tr><tr class="oddrow"><td>

What is your position?

.. raw:: html

   </td><td class="response">
   <select name="position" size="1">
   <option value="none" selected="selected" label="Select an option"></option>
   <option value="undergrad" label="Undergraduate student"></option>
   <option value="graduate" label="PhD student"></option>
   <option value="postdoc" label="Postdoc"></option>
   <option value="professor" label="Professor/Supervisor"></option>
   <option value="ra" label="Research assistant"></option>
   <option value="researcher" label="Other researcher"></option>
   <option value="sysadmin" label="System administrator"></option>
   </select>
   </td></tr><tr><td>

What type of data are you working with? Please check all items that apply.

.. raw:: html

   </td><td class="response">
   <table><tr><td>
   <input type="checkbox" name="datamod" value="behav" />Behavioral<br />
   <input type="checkbox" name="datamod" value="mri" />MRI/fMRI/DTI<br />
   <input type="checkbox" name="datamod" value="meeg" />EEG/MEG<br />
   </td><td>
   <input type="checkbox" name="datamod" value="pet" />PET/SPECT<br />
   <input type="checkbox" name="datamod" value="ephys" />Electrophysiology<br />
   <input type="checkbox" name="datamod" value="spectro" />Microspectroscopy<br />
   <input type="checkbox" name="datamod" value="other" />
   <input name="other_datamodality" type="text" size="20" maxlength="40">
   </td></tr></table>
   </td></tr><tr class="oddrow"><td>

Are you developing software that is intended to be used by other researchers?

.. raw:: html

   </td><td class="response">
   <span><input type="radio" name="developer" value="yes" />Yes</span>
   <span><input type="radio" name="developer" value="no" checked="checked" />No</span>
   </td>
   </tr>
   </table>

Personal scientific software environment
----------------------------------------

Here are a few questions about your personal scientific software environment
for research activities like data acquisition, computational modeling, and data
analysis. You might be running this on your laptop, desktop, personal
workstation or any other machine where **you decide** what software you are
using, and you typically also have permission to **install it yourself**.  If
you are operating different environments, please describe the one that you find
most productive for your research purposes. If you don't have a machine that
you administer yourself, instead, please indicate what kind of scientific
software environment you would like to be doing your research in.

.. raw:: html

   <table>
   <tr>
   <td>

What type of hardware are you using?

.. raw:: html

   </td><td class="response">
   <select name="pref_env" size="1">
   <option value="none" selected="selected" label="Select an option"></option>
   <option value="laptop" label="Laptop/Portable device"></option>
   <option value="desktop" label="Commodity desktop"></option>
   <option value="workstation" label="High-performance workstation"></option>
   <option value="cluster" label="Compute cluster"></option>
   <option value="grid" label="Grid/Cloud-computing facility"></option>
   </select>
   </td></tr><tr><td>

What operating system is this environment running on?

.. raw:: html

   </td><td class="response">
   <select name="pref_env" size="1">

.. raw:: html
   :file: select_os_options.inc

.. raw:: html

   </select>
   </td></tr><tr><td>

What fraction of your research activity time do you spend in this software
environment as opposed to any other environment that you migh have access to?

.. raw:: html

   </td><td class="response">
   <select name="pref_time" size="1">
   <option value="none" selected="selected" label="Select an option"></option>
   <option value="notime" label="None/I don't have this environment"></option>
   <option value="little" label="Less then half of the time"></option>
   <option value="most" label="More than half of the time"></option>
   <option value="always" label="All of the time"></option>
   </select>
   </td></tr><tr><td>

How much time do you spend each month on maintaining this environment?  This
includes the time spent on operating system (security) upgrades, as well as
installing and updating scientific software.

.. raw:: html

   </td><td class="response">
   <input name="maint_time" type="text" size="3" maxlength="3"> hours per month
   </td>
   </tr>
   </table>

---------------------------------------------------------------

Please indicate how much you agree to the following statements.

.. raw:: html

   <table>
   <tr><th colspan="2" style="text-align:left;font-weight:normal">

*I prefer this particular scientific software environment because ...*

.. raw:: html

   </th></tr><tr class="oddrow">
   <td class="task">

... the developers of an important research software recommend it

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   </td></tr><tr><td class="task">


... of the variety of available research software for this environment

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   </td></tr><tr class="oddrow"><td class="task">


... of the availibility of commercial support

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   </td></tr><tr><td class="task">


... many of my colleagues use something similar

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   </td></tr><tr class="oddrow"><td class="task">


... it is popular and I can get solutions for problems from web forums and mailing lists

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   </td></tr><tr><td class="task">


... I rely on an particular application that only runs in this environment

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   </td></tr><tr class="oddrow"><td class="task">


... it has adequate support for all required hardware

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   </td></tr><tr><td class="task">


... I have the necessary technical skills to maintain this environment myself

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   </td>
   </tr>
   </table>


Managed scientific software environment
---------------------------------------

The following questions are about a managed environment of scientific software
that is provided to you to carry out computing and data analysis related
research activities. Such an environment is typically managed by **dedicated IT
staff**, and **you don't have permissions to install arbitrary software**. This
environment may be shared by many researchers in a lab, a whole research
institution, or even be publicly accessible. If you have access to multiple
environments of this kind, please describe the one that offers most support for
your particular research purposes.


.. raw:: html

   <table class="questionaire">
   <tr>
   <td>

What type of hardware is this software environment running on?

.. raw:: html

   </td><td class="response">
   <select name="pref_env" size="1">
   <option value="none" selected="selected" label="Select an option"></option>
   <option value="laptop" label="Laptop/Portable device"></option>
   <option value="desktop" label="Commodity desktop"></option>
   <option value="workstation" label="High-performance workstation"></option>
   <option value="cluster" label="Compute cluster"></option>
   <option value="grid" label="Grid/Cloud-computing facility"></option>
   </select>
   </td></tr><tr><td>


What operating system is this environment running on?

.. raw:: html

   </td><td class="response">
   <select name="pref_env" size="1">

.. raw:: html
   :file: select_os_options.inc

.. raw:: html

   </select>
   </td></tr><tr><td>

What fraction of time do you spend in this environment during your research
activities?

.. raw:: html

   </td><td class="response">
   <select name="pref_time" size="1">
   <option value="none" selected="selected" label="Select an option"></option>
   <option value="notime" label="None/I don't use this"></option>
   <option value="little" label="Less then half of the time"></option>
   <option value="most" label="More than half of the time"></option>
   <option value="always" label="All of the time"></option>
   </select>
   </td>
   </tr>
   </table>

---------------------------------------------------------------

How much do you agree to the following statements?

.. raw:: html

   <table>
   <tr class="oddrow">
   <td class="task">

This environment provides me with the best available tools for my research.

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   </td></tr><tr><td class="task">

The support staff solves all my technical problems and addresses my demands in
a timely fashion.

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   </td></tr><tr class="oddrow"><td class="task">

There are always enough licenses for essential commerical software tools.

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   </td></tr><tr><td class="task">

I need to deploy additional software to be able to perform my research in this environment.

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   </td></tr><tr class="oddrow"><td class="task">


Using this managed environment is more cost effective than operating a suitable
environment myself.

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   </td></tr><tr><td class="task">

.. raw:: html

   </td>
   </tr>
   </table>

Virtualization
--------------

The following questions are about your usage of systems for hardware
virtualization in your research -- so-called **virtual machines**.
Virtualization is a technology that allows running more than one operating
systems on one machine at the same time.

.. raw:: html

   <table>
   <tr class="oddrow">
   <td class="task">

How often do you use virtual machines for your research purposes?

.. raw:: html

   </td><td class="response">
   <select name="pref_time" size="1">
   <option value="none" selected="selected" label="Select an option"></option>
   <option value="never" label="Never"></option>
   <option value="occasionally" label="Occasionally"></option>
   <option value="often" label="Often"></option>
   <option value="always" label="Exclusively"></option>
   </select><div style="font-size:60%">(skip the remaining questions of this section if "never")</div>
   </td></tr><tr><td class="task">

Which products for virtualization are you using?

.. raw:: html

   </td><td class="response">
   <table><tr><td>
   <input type="checkbox" name="" value="" />VMWare<br />
   <input type="checkbox" name="" value="" />VirtualBox<br />
   <input type="checkbox" name="" value="" />Parallels<br />
   <input type="checkbox" name="" value="" />QEMU<br />
   </td><td>
   <input type="checkbox" name="" value="" />Virtual PC<br />
   <input type="checkbox" name="" value="" />Xen<br />
   <input type="checkbox" name="" value="" />KVM<br />
   <input type="checkbox" name="" value="other" />
   <input name="other_vm" type="text" size="20" maxlength="40">
   </td></tr></table>
   </td></tr><tr class="oddrow"><td>

What **guest operating system** is running inside virtual machine?

.. raw:: html

   </td><td class="response">
   <select name="pref_env" size="1">

.. raw:: html
   :file: select_os_options.inc

.. raw:: html

   </select>
   </td></tr><tr><td>

What **host operating system** are the virtual machines running on?

.. raw:: html

   </td><td class="response">
   <select name="pref_env" size="1">

.. raw:: html
   :file: select_os_options.inc

.. raw:: html

   </select>
   </td></tr><tr><td colspan="2">

What are your reasons for employing virtualization in you research?
Please indicate how much you agree to the following statements.

Generic computing/scripting/programming environments

C/C++
IDL
LISREL
Maple
Mathcad
Mathematica
Matlab
Octave
Perl
Python
R
Ruby
Scilab
SPSS
SCIRun
Shell scripting


Distributed Computing - frameworks and controllers

SGE
Torque/OpenPBS/Maui
Condor
Globus
MPI (any)
IPython


Imaging

3D Slicer
AFNI
Aeskulap
Amide
BIRN Tools
BRAINS Tools
Bioimage Suite
BrainMap
BrainVISA/Anatomist
BrainVoyager
CMTK
Caret
ConnectomeViewer
DSI Studio
DTI-TK
Diffusion Toolkit/Trackvis
FSL
Fiji
FreeSurfer
ITK/SNAP
ImageJ
Invesalius
LONI
Lipsia
MIPAV/JIST
MRIcron
MRtrix
Mango
NiPy/NiTime/DiPy/NiPype
PyMVPA
REST
SPM
V3D
VoxBo

Data management

XNAT/PyXNAT/...
Human Imaging Database (HID)

Neural Systems Modeling

Brian
iqr
iNVT
NEURON
NEST
Genesis
Moose
PCSIM
PyNN

Electrophysiology

BioSig
BrainStorm
Chronus
EEGLAB
Fieldtrip
LORETA/sLORETA
OpenMEEG
Openelectrophy
RTXI
Relacs
?Trellis-neuro

Brain-computer interface

BCI2000
OpenVIBE
Pyff

Hardware interface/Data acquisition

Comedi
EPICS
MX

Real-time solutions

RTAI
Xenomai
RTLinux
PREEMPT_RT

Psychophysics/Experimental Control

E-Prime
Presentation
PsychoPy
PyEPL
Psychtoolbox
Psytoolkit
OpenSesame
VisionEgg
Tscope


.. raw:: html

   </td></tr><tr class="oddrow"><td class="task">

I can run software that is otherwise incompatible with my system.

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   </td></tr><tr><td class="task">

I have the ability to easily create snapshot of my whole analysis environment.

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   </td></tr><tr class="oddrow"><td class="task">


I can take my complete analysis environment with me and run in on different
machines.

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="inst_r1" value="yes" /></div>
   </td>
   </tr>
   </table>


Resources for scientific software
---------------------------------

Where do you obtain scientific software that you employ in your research? Please
check all items that apply.

.. raw:: html

   <table class="questionaire">
   <tr class="oddrow">
   <td class="response"><input type="checkbox" name="software_resource" value="pet" /></td><td>

Directly form vendor or project website

.. raw:: html

   </td></tr><tr><td class="response"><input type="checkbox" name="software_resource" value="" /></td><td>

Retailer

.. raw:: html

   </td></tr><tr class="oddrow"><td class="response"><input type="checkbox" name="software_resource" value="" /></td><td>

`Extra Packages for Enterprise Linux (EPEL) <http://fedoraproject.org/wiki/EPEL>`_

.. raw:: html

   </td></tr><tr><td class="response"><input type="checkbox" name="software_resource" value="" /></td><td>

`Fink <http://www.finkproject.org>`_

.. raw:: html

   </td></tr><tr class="oddrow"><td class="response"><input type="checkbox" name="software_resource" value="" /></td><td>

`FreeBSD ports <http://www.freebsd.org/ports/science.html>`_

.. raw:: html

   </td></tr><tr><td class="response"><input type="checkbox" name="software_resource" value="" /></td><td>

`International neuroinformatics Coordinating Facility (INCF) Research Tools <http://www.incf.org/resources/research-tools>`_

.. raw:: html

   </td></tr><tr class="oddrow"><td><input type="checkbox" name="software_resource" value="" /></td><td>

`Macports <http://www.macports.org>`_

.. raw:: html

   </td></tr><tr><td class="response"><input type="checkbox" name="software_resource" value="" /></td><td>

`NeuroDebian <http://neuro.debian.net>`_

.. raw:: html

   </td></tr><tr class="oddrow"><td class="response"><input type="checkbox" name="software_resource" value="" /></td><td>

`Neuroimaging Informatics Tools and Resources Clearinghouse (NITRC) <http://www.nitrc.org>`_

.. raw:: html

   </td></tr><tr><td class="response"><input type="checkbox" name="software_resource" value="" /></td><td>

`Python Package Index (PyPi) <http://pypi.python.org>`_

.. raw:: html

   </td></tr><tr class="oddrow"><td class="response"><input type="checkbox" name="software_resource" value="" /></td><td>

`Sourceforge <http://www.sourceforge.net>`_

.. raw:: html

   </td></tr><tr><td class="response"><input type="checkbox" name="software_resource" value="other" /></td><td>
   <input name="other_resource" type="text" size="40" maxlength="200">
   </td></tr></table>

Software selection
------------------

.. raw:: html

   <input value="Go" type="button"
          onclick='JavaScript:xmlhttpPost("/cgi-bin/surveycollector.cgi")'>

   <div id="result"></div>
   </form>



