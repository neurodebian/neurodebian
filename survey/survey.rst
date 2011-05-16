
Scientific software usage in neuroscience research
==================================================

This survey should take about five minutes. Immediately after submission you
will be presented with some statistics on previous responses. Please try to
answer as many questions as you can, but don't worry if you cannot answer all
of them. For feedback email team@neuro.debian.net

.. raw:: html

   <script type="text/javascript" src="../_static/jquery.js"></script> 
   <script type="text/javascript" src="jquery.form.js"></script> 

   <script type="text/javascript">
   // prepare the form when the DOM is ready
   $(document).ready(function() {
       var options = {
           beforeSubmit:  displayStatus,
           success:       showResponse,  // post-submit callback
           // other available options:
           url: "/cgi-bin/surveycollector.cgi",
           type: "post",
           dataType:  "json",
           clearForm: false,
           resetForm: false
       };

       $('#nss_survey').submit(function() {
           $(this).ajaxSubmit(options);
           // !!! Important !!!
           // always return false to prevent standard browser submit and page navigation
           return false;
       }); 
   }); 

   // pre-submit callback 
   function displayStatus(formData, jqForm, options) { 
       $('#server_response').html("<emph>Sending survey data. This may take a few moments...</emph>");
       return true; 
   } 

   function showResponse(data, statusText, xhr, $form)  {
       // reset form if server reports success
       if (data.success == true) {
           //$('#nss_survey').resetForm();
           //$('#submit_button').hide();
           $('#server_response').html("<p><em>Thanks for participating in this survey.</em></p>" + data.results)
       } else {
           $('#server_response').html("");
           alert(data.message);
       }
   }
   </script>
   <form id="nss_survey" action="/cgi-bin/surveycollector.cgi" method="post">


Personal background
-------------------

.. raw:: html

   <table>
   <tr class="oddrow">
   <td>

Which country are you working in?

.. raw:: html

   </td><td class="response">

.. raw:: html
   :file: select_country.inc

.. raw:: html

   </td></tr><tr><td>

Where are you working?

.. raw:: html

   </td><td class="response">
   <select name="bg_employer" size="1">
   <option value="none" selected="selected" label="Select an option">Select an option</option>
   <option value="edu_priv" label="Higher education (privately funded)">Higher education (privately funded)</option>
   <option value="edu_pub" label="Higher education (publicly funded)">Higher education (publicly funded)</option>
   <option value="research_priv" label="Research institution (privately funded)">Research institution (privately funded)</option>
   <option value="research_pub" label="Research institution (publicly funded)">Research institution (publicly funded)</option>
   <option value="company" label="Company">Company</option>
   </select>
   </td></tr><tr class="oddrow"><td>

What is your position?

.. raw:: html

   </td><td class="response">
   <select name="bg_position" size="1">
   <option value="none" selected="selected" label="Select an option">Select an option</option>
   <option value="undergrad" label="Undergraduate student">Undergraduate student</option>
   <option value="graduate" label="PhD student">PhD student</option>
   <option value="postdoc" label="Postdoc">Postdoc</option>
   <option value="professor" label="Professor/Supervisor">Professor/Supervisor</option>
   <option value="ra" label="Research assistant">Research assistant</option>
   <option value="researcher" label="Other researcher">Other researcher</option>
   <option value="sysadmin" label="System administrator">System administrator</option>
   </select>
   </td></tr><tr><td>

What type of data are you working with? Please check all items that apply.

.. raw:: html

   </td><td class="response">
   <table><tr><td>
   <input type="checkbox" name="bg_datamod" value="behav" />Behavioral<br />
   <input type="checkbox" name="bg_datamod" value="mri" />MRI/fMRI/DTI<br />
   <input type="checkbox" name="bg_datamod" value="meeg" />EEG/MEG<br />
   </td><td>
   <input type="checkbox" name="bg_datamod" value="pet" />PET/SPECT<br />
   <input type="checkbox" name="bg_datamod" value="ephys" />Electrophysiology<br />
   <input type="checkbox" name="bg_datamod" value="spectro" />Microspectroscopy<br />
   <input type="checkbox" name="bg_datamod" value="other" />
   <input name="bg_datamod_other" type="text" size="20" maxlength="40">
   </td></tr></table>
   </td></tr><tr class="oddrow"><td>

Are you developing software that is intended to be used by other researchers?

.. raw:: html

   </td><td class="response">
   <span><input type="radio" name="bg_developer" value="yes" />Yes</span>
   <span><input type="radio" name="bg_developer" value="no" checked="checked" />No</span>
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
   <tr class="oddrow">
   <td>

What fraction of your research activity time do you spend in this software
environment as opposed to any other environment that you migh have access to?

.. raw:: html

   </td><td class="response">
   <select name="pers_time" size="1">
   <option value="none" selected="selected" label="Select an option">Select an option</option>
   <option value="notime" label="None/I don't have this environment">None/I don't have this environment</option>
   <option value="little" label="Less then half of the time">Less then half of the time</option>
   <option value="most" label="More than half of the time">More than half of the time</option>
   <option value="always" label="All of the time">All of the time</option>
   </select>
   </td></tr><tr><td>

What type of hardware are you using?

.. raw:: html

   </td><td class="response">
   <select name="pers_hardware" size="1">
   <option value="none" selected="selected" label="Select an option">Select an option</option>
   <option value="laptop" label="Laptop/Portable device">Laptop/Portable device</option>
   <option value="desktop" label="Commodity desktop">Commodity desktop</option>
   <option value="workstation" label="High-performance workstation">High-performance workstation</option>
   <option value="cluster" label="Compute cluster">Compute cluster</option>
   <option value="grid" label="Grid/Cloud-computing facility">Grid/Cloud-computing facility</option>
   </select>
   </td></tr><tr class="oddrow"><td>

What operating system is this environment running on?

.. raw:: html

   </td><td class="response">
   <select name="pers_os" size="1">

.. raw:: html
   :file: select_os_options.inc

.. raw:: html

   </select>
   </td></tr><tr><td>

How much time do you spend each month on maintaining this environment?  This
includes the time spent on operating system (security) upgrades, as well as
installing and updating scientific software.

.. raw:: html

   </td><td class="response">
   <input name="pers_maint_time" type="text" size="3" maxlength="3"> hours per month
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
   <div class="rating">Definitely agree<br /><input type="radio" name="pers_r1" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="pers_r1" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="pers_r1" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="pers_r1" value="0" /></div>
   </td></tr><tr><td class="task">


... of the variety of available research software for this environment

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="pers_r2" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="pers_r2" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="pers_r2" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="pers_r2" value="0" /></div>
   </td></tr><tr class="oddrow"><td class="task">


... of the availibility of commercial support

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="pers_r3" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="pers_r3" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="pers_r3" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="pers_r3" value="0" /></div>
   </td></tr><tr><td class="task">


... many of my colleagues use something similar

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="pers_r4" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="pers_r4" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="pers_r4" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="pers_r4" value="0" /></div>
   </td></tr><tr class="oddrow"><td class="task">


... it is popular and I can get solutions for problems from web forums and mailing lists

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="pers_r5" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="pers_r5" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="pers_r5" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="pers_r5" value="0" /></div>
   </td></tr><tr><td class="task">


... I rely on a particular application that only runs in this environment

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="pers_r6" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="pers_r6" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="pers_r6" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="pers_r6" value="0" /></div>
   </td></tr><tr class="oddrow"><td class="task">


... it has adequate support for all required hardware

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="pers_r7" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="pers_r7" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="pers_r7" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="pers_r7" value="0" /></div>
   </td></tr><tr><td class="task">


... I have the necessary technical skills to maintain this environment myself

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="pers_r8" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="pers_r8" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="pers_r8" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="pers_r8" value="0" /></div>
   </td>
   </tr>
   </table>


Managed scientific software environment
---------------------------------------

The following questions are about a managed environment of scientific software
that is provided to you to carry out computing and data analysis. Such an
environment is typically managed by **dedicated IT staff**, and **you don't
have permissions to install arbitrary software**. This environment may be
shared by many researchers in a lab, a whole research institution, or even be
publicly accessible. If you have access to multiple environments of this kind,
please describe the one that offers most support for your particular research
purposes.


.. raw:: html

   <table class="questionaire">
   <tr class="oddrow">
   <td>

What fraction of time do you spend in this environment during your research
activities?

.. raw:: html

   </td><td class="response">
   <select name="man_time" size="1">
   <option value="none" selected="selected" label="Select an option">Select an option</option>
   <option value="notime" label="None/I don't use this">None/I don't use this</option>
   <option value="little" label="Less then half of the time">Less then half of the time</option>
   <option value="most" label="More than half of the time">More than half of the time</option>
   <option value="always" label="All of the time">All of the time</option>
   </select>
   </td></tr><tr><td>

What type of hardware is this software environment running on?

.. raw:: html

   </td><td class="response">
   <select name="man_hardware" size="1">
   <option value="none" selected="selected" label="Select an option">Select an option</option>
   <option value="laptop" label="Laptop/Portable device">Laptop/Portable device</option>
   <option value="desktop" label="Commodity desktop">Commodity desktop</option>
   <option value="workstation" label="High-performance workstation">High-performance workstation</option>
   <option value="cluster" label="Compute cluster">Compute cluster</option>
   <option value="grid" label="Grid/Cloud-computing facility">Grid/Cloud-computing facility</option>
   </select>
   </td></tr><tr class="oddrow"><td>


What operating system is this environment running on?

.. raw:: html

   </td><td class="response">
   <select name="man_os" size="1">

.. raw:: html
   :file: select_os_options.inc

.. raw:: html

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

This environment provides me with the best available tools for my research

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="man_r1" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="man_r1" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="man_r1" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="man_r1" value="0" /></div>
   </td></tr><tr><td class="task">

The support staff solves all my technical problems and addresses my demands in
a timely fashion

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="man_r2" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="man_r2" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="man_r2" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="man_r2" value="0" /></div>
   </td></tr><tr class="oddrow"><td class="task">

There are always enough licenses for essential commerical software tools

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="man_r3" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="man_r3" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="man_r3" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="man_r3" value="0" /></div>
   </td></tr><tr><td class="task">

I need to deploy additional software to be able to perform my research in this environment

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="man_r4" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="man_r4" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="man_r4" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="man_r4" value="0" /></div>
   </td></tr><tr class="oddrow"><td class="task">


Using this managed environment is more cost effective than operating a suitable
environment myself

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="man_r5" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="man_r5" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="man_r5" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="man_r5" value="0" /></div>
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
   <select name="virt_time" size="1">
   <option value="none" selected="selected" label="Select an option">Select an option</option>
   <option value="never" label="Never">Never</option>
   <option value="occasionally" label="Occasionally">Occasionally</option>
   <option value="often" label="Often">Often</option>
   <option value="always" label="Exclusively">Exclusively</option>
   </select><div style="font-size:60%">(skip the remaining questions of this section if "never")</div>
   </td></tr><tr><td class="task">

Which products for virtualization are you using?

.. raw:: html

   </td><td class="response">
   <table><tr><td>
   <input type="checkbox" name="virt_prod" value="vmware" />VMWare<br />
   <input type="checkbox" name="virt_prod" value="virtualbox" />VirtualBox<br />
   <input type="checkbox" name="virt_prod" value="parallels" />Parallels<br />
   <input type="checkbox" name="virt_prod" value="qemu" />QEMU<br />
   </td><td>
   <input type="checkbox" name="virt_prod" value="virtualpc" />Virtual PC<br />
   <input type="checkbox" name="virt_prod" value="xen" />Xen<br />
   <input type="checkbox" name="virt_prod" value="kvm" />KVM<br />
   <input type="checkbox" name="virt_prod" value="other" />
   <input name="virt_other" type="text" size="20" maxlength="40">
   </td></tr></table>
   </td></tr><tr class="oddrow"><td>

What **guest operating system** is running inside virtual machine?

.. raw:: html

   </td><td class="response">
   <select name="virt_guest_os" size="1">

.. raw:: html
   :file: select_os_options.inc

.. raw:: html

   </select>
   </td></tr><tr><td>

What **host operating system** are the virtual machines running on?

.. raw:: html

   </td><td class="response">
   <select name="virt_host_os" size="1">

.. raw:: html
   :file: select_os_options.inc

.. raw:: html

   </select>
   </td></tr><tr><td colspan="2">

What are your reasons for employing virtualization in you research?
Please indicate how much you agree to the following statements

.. raw:: html

   </td></tr><tr class="oddrow"><td class="task">

I can run software that is otherwise incompatible with my system

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="virt_r1" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="virt_r1" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="virt_r1" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="virt_r1" value="0" /></div>
   </td></tr><tr><td class="task">

I have the ability to easily create a snapshot of my whole analysis environment

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="virt_r2" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="virt_r2" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="virt_r2" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="virt_r2" value="0" /></div>
   </td></tr><tr class="oddrow"><td class="task">


I can take my complete analysis environment with me and run it on different
machines

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="virt_r3" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="virt_r3" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="virt_r3" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="virt_r3" value="0" /></div>
   </td></tr><tr><td class="task">

The performance of a virtual machine is sufficient for routine application in my
research

.. raw:: html

   </td><td class="response">
   <div class="rating">Definitely agree<br /><input type="radio" name="virt_r4" value="3" /></div>
   <div class="rating">Mostly agree<br /><input type="radio" name="virt_r4" value="2" /></div>
   <div class="rating">Mostly disagree<br /><input type="radio" name="virt_r4" value="1" /></div>
   <div class="rating">Definitely disagree<br /><input type="radio" name="virt_r4" value="0" /></div>
   </td>
   </tr>
   </table>


Resources for scientific software
---------------------------------

Where do you obtain scientific software that you employ in your research? Please
check all items that apply

.. raw:: html

   <table class="questionaire">
   <tr class="oddrow">
   <td class="response"><input type="checkbox" name="software_resource" value="vendor" /></td><td>

Directly from vendor or project website

.. raw:: html

   </td></tr><tr><td class="response"><input type="checkbox" name="software_resource" value="retailer" /></td><td>

Retailer

.. raw:: html

   </td></tr><tr class="oddrow"><td class="response"><input type="checkbox" name="software_resource" value="os" /></td><td>

Comes with the operating system

.. raw:: html

   </td></tr><tr><td class="response"><input type="checkbox" name="software_resource" value="cpan" /></td><td>

`Comprehensive Perl Archive Network (CPAN) <http://www.cpan.org>`_

.. raw:: html

   </td></tr><tr class="oddrow"><td class="response"><input type="checkbox" name="software_resource" value="cran" /></td><td>

`Comprehensive R Archive Network (CRAN) <http://cran.r-project.org>`_

.. raw:: html

   </td></tr><tr><td class="response"><input type="checkbox" name="software_resource" value="epel" /></td><td>

`Extra Packages for Enterprise Linux (EPEL) <http://fedoraproject.org/wiki/EPEL>`_

.. raw:: html

   </td></tr><tr class="oddrow"><td class="response"><input type="checkbox" name="software_resource" value="fink" /></td><td>

`Fink <http://www.finkproject.org>`_

.. raw:: html

   </td></tr><tr><td class="response"><input type="checkbox" name="software_resource" value="freebsdports" /></td><td>

`FreeBSD ports <http://www.freebsd.org/ports/science.html>`_

.. raw:: html

   </td></tr><tr class="oddrow"><td class="response"><input type="checkbox" name="software_resource" value="incf" /></td><td>

`International neuroinformatics Coordinating Facility (INCF) Research Tools <http://www.incf.org/resources/research-tools>`_

.. raw:: html

   </td></tr><tr><td class="response"><input type="checkbox" name="software_resource" value=macports"" /></td><td>

`Macports <http://www.macports.org>`_

.. raw:: html

   </td></tr><tr class="oddrow"><td class="response"><input type="checkbox" name="software_resource" value="matlabcentral" /></td><td>

`Matlab Central <http://www.mathworks.com/matlabcentral>`_

.. raw:: html

   </td></tr><tr><td class="response"><input type="checkbox" name="software_resource" value="neurodebian" /></td><td>

`NeuroDebian <http://neuro.debian.net>`_

.. raw:: html

   </td></tr><tr class="oddrow"><td class="response"><input type="checkbox" name="software_resource" value="nitrc" /></td><td>

`Neuroimaging Informatics Tools and Resources Clearinghouse (NITRC) <http://www.nitrc.org>`_

.. raw:: html

   </td></tr><tr><td class="response"><input type="checkbox" name="software_resource" value="pypi" /></td><td>

`Python Package Index (PyPi) <http://pypi.python.org>`_

.. raw:: html

   </td></tr><tr class="oddrow"><td class="response"><input type="checkbox" name="software_resource" value="pythonbundles" /></td><td>

Python bundles: `Enthought Python <http://www.enthought.com/products/index.php>`_, `Python(x,y) <http://www.pythonxy.com/>`_

.. raw:: html

   </td></tr><tr><td class="response"><input type="checkbox" name="software_resource" value="sourceforge" /></td><td>

`Sourceforge <http://www.sourceforge.net>`_

.. raw:: html

   </td></tr><tr class="oddrow"><td class="response"><input type="checkbox" name="software_resource" value="other" /></td><td>
   <input name="software_resource_other" type="text" size="40" maxlength="200">
   </td></tr></table>

Software selection
------------------

Please select all software that you are using in your research.

Generic computing/scripting/programming environments
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. raw:: html

   <table class="questionaire"><tr>
   <td class="response"><input type="checkbox" name="sw_general" value="cpp" />C/C++</td>
   <td class="response"><input type="checkbox" name="sw_general" value="idl" />IDL</td>
   <td class="response"><input type="checkbox" name="sw_general" value="labview" />LabVIEW</td>
   <td class="response"><input type="checkbox" name="sw_general" value="lisrel" />LISREL</td>
   <td class="response"><input type="checkbox" name="sw_general" value="maple" />Maple</td>
   <td class="response"><input type="checkbox" name="sw_general" value="mathcad" />Mathcad</td>
   </tr><tr class="oddrow">
   <td class="response"><input type="checkbox" name="sw_general" value="mathematica" />Mathematica</td>
   <td class="response"><input type="checkbox" name="sw_general" value="matlab" />Matlab</td>
   <td class="response"><input type="checkbox" name="sw_general" value="octave" />Octave</td>
   <td class="response"><input type="checkbox" name="sw_general" value="perl" />Perl</td>
   <td class="response"><input type="checkbox" name="sw_general" value="python" />Python</td>
   <td class="response"><input type="checkbox" name="sw_general" value="r" />R</td>
   </tr><tr>
   <td class="response"><input type="checkbox" name="sw_general" value="ruby" />Ruby</td>
   <td class="response"><input type="checkbox" name="sw_general" value="scilab" />Scilab</td>
   <td class="response"><input type="checkbox" name="sw_general" value="spss" />SPSS</td>
   <td class="response"><input type="checkbox" name="sw_general" value="scirun" />SCIRun</td>
   <td class="response"><input type="checkbox" name="sw_general" value="shell" />Shell scripting</td>
   </tr></table>

Distributed computing - frameworks and controllers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. raw:: html

   <table class="questionaire"><tr>
   <td class="response"><input type="checkbox" name="sw_dc" value="sge" />SGE</td>
   <td class="response"><input type="checkbox" name="sw_dc" value="torque" />Torque/OpenPBS/Maui</td>
   <td class="response"><input type="checkbox" name="sw_dc" value="condor" />Condor</td>
   <td class="response"><input type="checkbox" name="sw_dc" value="globus" />Globus</td>
   <td class="response"><input type="checkbox" name="sw_dc" value="mpi" />MPI (any)</td>
   <td class="response"><input type="checkbox" name="sw_dc" value="ipython" />IPython</td>
   </tr></table>

Imaging
~~~~~~~

.. raw:: html

   <table class="questionaire"><tr>
   <td class="response"><input type="checkbox" name="sw_img" value="3dslicer" />3D Slicer</td>
   <td class="response"><input type="checkbox" name="sw_img" value="afni" />AFNI</td>
   <td class="response"><input type="checkbox" name="sw_img" value="aeskulap" />Aeskulap</td>
   <td class="response"><input type="checkbox" name="sw_img" value="amide" />Amide</td>
   </tr><tr class="oddrow">
   <td class="response"><input type="checkbox" name="sw_img" value="birn" />BIRN Tools</td>
   <td class="response"><input type="checkbox" name="sw_img" value="brainstools" />BRAINS Tools</td>
   <td class="response"><input type="checkbox" name="sw_img" value="bioimgsuite" />Bioimage Suite</td>
   <td class="response"><input type="checkbox" name="sw_img" value="brainmap" />BrainMap</td>
   </tr><tr>
   <td class="response"><input type="checkbox" name="sw_img" value="brainvisa" />BrainVISA/Anatomist</td>
   <td class="response"><input type="checkbox" name="sw_img" value="brainvoyager" />BrainVoyager</td>
   <td class="response"><input type="checkbox" name="sw_img" value="cmtk" />CMTK</td>
   <td class="response"><input type="checkbox" name="sw_img" value="caret" />Caret</td>
   </tr><tr class="oddrow">
   <td class="response"><input type="checkbox" name="sw_img" value="connectomviewer" />ConnectomeViewer</td>
   <td class="response"><input type="checkbox" name="sw_img" value="dsi" />DSI Studio</td>
   <td class="response"><input type="checkbox" name="sw_img" value="dtitk" />DTI-TK</td>
   <td class="response"><input type="checkbox" name="sw_img" value="trackvis" />Diffusion Toolkit/Trackvis</td>
   </tr><tr>
   <td class="response"><input type="checkbox" name="sw_img" value="fsl" />FSL</td>
   <td class="response"><input type="checkbox" name="sw_img" value="fiji" />Fiji</td>
   <td class="response"><input type="checkbox" name="sw_img" value="freesurfer" />FreeSurfer</td>
   <td class="response"><input type="checkbox" name="sw_img" value="itksnap" />ITK-SNAP</td>
   </tr><tr class="oddrow">
   <td class="response"><input type="checkbox" name="sw_img" value="imagej" />ImageJ</td>
   <td class="response"><input type="checkbox" name="sw_img" value="invesalius" />Invesalius</td>
   <td class="response"><input type="checkbox" name="sw_img" value="loni" />LONI</td>
   <td class="response"><input type="checkbox" name="sw_img" value="lipsia" />Lipsia</td>
   </tr><tr>
   <td class="response"><input type="checkbox" name="sw_img" value="mango" />Mango</td>
   <td class="response"><input type="checkbox" name="sw_img" value="mipav" />MIPAV/JIST</td>
   <td class="response"><input type="checkbox" name="sw_img" value="mni" />MNI tools</td>
   <td class="response"><input type="checkbox" name="sw_img" value="mricron" />MRIcron</td>
   </tr><tr class="oddrow">
   <td class="response"><input type="checkbox" name="sw_img" value="mrtrix" />MRtrix</td>
   <td class="response"><input type="checkbox" name="sw_img" value="mvpa" />Matlab MVPA toolbox</td>
   <td class="response"><input type="checkbox" name="sw_img" value="nibabel" />NiBabel/PyNIfTI</td>
   <td class="response"><input type="checkbox" name="sw_img" value="nipy" />NiPy/NiTime/DiPy/NiPype</td>
   </tr><tr>
   <td class="response"><input type="checkbox" name="sw_img" value="pymvpa" />PyMVPA</td>
   <td class="response"><input type="checkbox" name="sw_img" value="rest" />REST</td>
   <td class="response"><input type="checkbox" name="sw_img" value="spm" />SPM</td>
   <td class="response"><input type="checkbox" name="sw_img" value="v3d" />V3D</td>
   </tr><tr class="oddrow">
   <td class="response"><input type="checkbox" name="sw_img" value="voxbo" />VoxBo</td>
   </tr></table>

Data management
~~~~~~~~~~~~~~~

.. raw:: html

   <table class="questionaire"><tr>
   <td class="response"><input type="checkbox" name="sw_datamanage" value="xnat" />XNAT/PyXNAT/...</td>
   <td class="response"><input type="checkbox" name="sw_datamanage" value="hid" />Human Imaging Database (HID)</td>
   </tr></table>

Neural systems modeling
~~~~~~~~~~~~~~~~~~~~~~~

.. raw:: html

   <table class="questionaire"><tr>
   <td class="response"><input type="checkbox" name="sw_neusys" value="brian" />Brian</td>
   <td class="response"><input type="checkbox" name="sw_neusys" value="iqr" />iqr</td>
   <td class="response"><input type="checkbox" name="sw_neusys" value="iNVT" />iNVT</td>
   <td class="response"><input type="checkbox" name="sw_neusys" value="neuron" />NEURON</td>
   <td class="response"><input type="checkbox" name="sw_neusys" value="nest" />NEST</td>
   <td class="response"><input type="checkbox" name="sw_neusys" value="genesis" />Genesis</td>
   <td class="response"><input type="checkbox" name="sw_neusys" value="moose" />Moose</td>
   <td class="response"><input type="checkbox" name="sw_neusys" value="pcsim" />PCSIM</td>
   <td class="response"><input type="checkbox" name="sw_neusys" value="pynn" />PyNN</td>
   <td class="response"><input type="checkbox" name="sw_neusys" value="topographica" />Topographica</td>
   </tr></table>

Electrophysiology, MEG/EEG
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. raw:: html

   <table class="questionaire"><tr>
   <td class="response"><input type="checkbox" name="sw_electro" value="besa" />BESA</td>
   <td class="response"><input type="checkbox" name="sw_electro" value="biosig" />BioSig</td>
   <td class="response"><input type="checkbox" name="sw_electro" value="brainstorm" />BrainStorm</td>
   <td class="response"><input type="checkbox" name="sw_electro" value="chronus" />Chronus</td>
   <td class="response"><input type="checkbox" name="sw_electro" value="eeglab" />EEGLAB</td>
   <td class="response"><input type="checkbox" name="sw_electro" value="elekta" />Elekta Neuromag</td>
   </tr><tr class="oddrow">
   <td class="response"><input type="checkbox" name="sw_electro" value="fieldtrip" />Fieldtrip</td>
   <td class="response"><input type="checkbox" name="sw_electro" value="klustakwik" />KlustaKwik</td>
   <td class="response"><input type="checkbox" name="sw_electro" value="loreta" />LORETA/sLORETA</td>
   <td class="response"><input type="checkbox" name="sw_electro" value="mne" />MNE suite</td>
   <td class="response"><input type="checkbox" name="sw_electro" value="neuroexplorer" />NeuroExplorer</td>
   <td class="response"><input type="checkbox" name="sw_electro" value="openmeeg" />OpenMEEG</td>
   </tr><tr>
   <td class="response"><input type="checkbox" name="sw_electro" value="openelectrophy" />Openelectrophy</td>
   <td class="response"><input type="checkbox" name="sw_electro" value="rtxi" />RTXI</td>
   <td class="response"><input type="checkbox" name="sw_electro" value="relacs" />Relacs</td>
   <td class="response"><input type="checkbox" name="sw_electro" value="trellis" />?Trellis-neuro</td>
   </tr></table>

Brain-computer interface
~~~~~~~~~~~~~~~~~~~~~~~~

.. raw:: html

   <table class="questionaire"><tr>
   <td class="response"><input type="checkbox" name="sw_bci" value="bci2000" />BCI2000</td>
   <td class="response"><input type="checkbox" name="sw_bci" value="openvibe" />OpenVIBE</td>
   <td class="response"><input type="checkbox" name="sw_bci" value="pyff" />Pyff</td>
   </tr></table>

Hardware interface/Data acquisition
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. raw:: html

   <table class="questionaire"><tr>
   <td class="response"><input type="checkbox" name="sw_acq" value="comedi" />Comedi</td>
   <td class="response"><input type="checkbox" name="sw_acq" value="epics" />EPICS</td>
   <td class="response"><input type="checkbox" name="sw_acq" value="mx" />MX</td>
   </tr></table>

Real-time solutions
~~~~~~~~~~~~~~~~~~~

.. raw:: html

   <table class="questionaire"><tr>
   <td class="response"><input type="checkbox" name="sw_rt" value="rtai" />RTAI</td>
   <td class="response"><input type="checkbox" name="sw_rt" value="xenomai" />Xenomai</td>
   <td class="response"><input type="checkbox" name="sw_rt" value="rtlinux" />RTLinux</td>
   <td class="response"><input type="checkbox" name="sw_rt" value="preempt_rt" />PREEMPT_RT</td>
   </tr></table>

Psychophysics/Experiment control
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. raw:: html

   <table class="questionaire"><tr>
   <td class="response"><input type="checkbox" name="sw_psychphys" value="dmdx" />DMDX</td>
   <td class="response"><input type="checkbox" name="sw_psychphys" value="eprime" />E-Prime</td>
   <td class="response"><input type="checkbox" name="sw_psychphys" value="presentation" />Presentation</td>
   <td class="response"><input type="checkbox" name="sw_psychphys" value="psychopy" />PsychoPy</td>
   <td class="response"><input type="checkbox" name="sw_psychphys" value="pyepl" />PyEPL</td>
   <td class="response"><input type="checkbox" name="sw_psychphys" value="psychtoolbox" />Psychtoolbox</td>
   </tr><tr class="oddrow">
   <td class="response"><input type="checkbox" name="sw_psychphys" value="psytoolkit" />Psytoolkit</td>
   <td class="response"><input type="checkbox" name="sw_psychphys" value="opensesame" />OpenSesame</td>
   <td class="response"><input type="checkbox" name="sw_psychphys" value="visionegg" />VisionEgg</td>
   <td class="response"><input type="checkbox" name="sw_psychphys" value="tscope" />Tscope</td>
   </tr></table>

Other
~~~~~

.. raw:: html

   <table class="questionaire"><tr>
   <td class="response"><input type="checkbox" name="sw_other" value="other" />
   <input name="sw_other_name" type="text" size="40" maxlength="200"> <span style="font-size:70%">(comma-separated list)</span></td>
   </tr></table>

---------------------------------------------------------------

.. raw:: html

   <input id="submit_button" value="Submit survey" type="submit">
   <div id="server_response"></div>
   </form>



