
Computing environments in neuroscience research
===============================================

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

General
-------

Subfield of neuroscience: ``MRI, EEG, MEG, electrophys. ...``
Position: ``undergraduate, phd student, postdoc, professor/supervisor, sysadmin``
employer: ``higher education (private/public funding), research facility
(private/public funding, company)``
country: ``long list``
do you develop software intended to be used by other researchers: ``yes, no``

Personal computing environment
------------------------------

Here are a few questions about your preferred computing environment for
research activities like data acquisition and data analysis. This might be your
laptop, desktop, personal workstation or any other machine where **you decide**
what software you are using, and you have permission to install it yourself.
If you are using multiple environment, please describe the one that you find
most productive for research purposes. If you don't have access to a machine
for research purposes that you administer yourself, instead, please indicate
what kind of environment you would like to be doing your research in.

Do you have it: ``yes, no``

Type: ``laptop, commodity desktop, dedicated workstation,
compute cluster, grid/cloud computing environment``

Operating system: ``detailed choice, long list``

I prefer this environment because is offers (check all items that apply):

``checkboxes (variety of available software; hardware support; ...)``


Institutionally provided computing environment
----------------------------------------------

The following questions are about
What your employer offers.

Do you use it: ``yes, no``

Type: ``laptop, commodity desktop, dedicated workstation,
compute cluster, grid/cloud computing environment``

Operating system: ``detailed choice, long list``

I dislike (check all items that apply):

``checkboxes (limited set of available software; slow admin response; ...)``



Virtualization
--------------

Do you use it? ``yes, no``

IF
~~

What solution: ``multi select vbox, vmware, kvm, xem, qemu``
On what host system: ``detailed list``
With what guest system ``detailed list``

Why do you use it: ``multi select``

  - Otherwise software incompatible with my system
  - Flexible snapshots
  - Portable (test developed software across platforms)

What fraction of computing task do you do in a VM?

Do you do computing on clusters?
Do you do computing in a cloud?


Software usage
--------------

What software are you using in your research?

? Do you use real-time Linux kernel? if yes, which: ``multi select RTAI, Xenomai, RT_Linux``


General purpose computing
~~~~~~~~~~~~~~~~~~~~~~~~~

``check boxes``

Matlab, R, Python, Octave, ...

``various collections of software for various purposes``


NeuroDebian
-----------

Do you use NeuroDebian repository: ``yes, no``

....


.. raw:: html

   <input value="Go" type="button" onclick='JavaScript:xmlhttpPost("/cgi-bin/surveycollector.cgi")'></p>
   <div id="result"></div>
   </form>


Thanks
