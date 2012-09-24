.. _WELCOme:

*********************************************
 The Ultimate Neuroscience Software Platform
*********************************************

NeuroDebian provides a large collection of popular neuroscience research
software for the Debian_ operating system as well as Ubuntu_ and other
derivatives. Popular packages include FSL, Freesurfer, AFNI, PyMVPA and
:ref:`many others <pkglists>`. While we do strive to maintain a high level of
quality, we make no guarantee that a given package works as expected, so use
them at your own risk. If you do encounter problems or would just like to thank
us, simply `send us an email <#contacts>`_.

Learn more about NeuroDebian, the goals of this project, and help us |spread|!

  Halchenko, Y. O. & Hanke, M. (2012). `Open is not enough. Let’s take the
  next step: An integrated, community-driven computing platform for neuroscience
  <http://www.frontiersin.org/Neuroinformatics/10.3389/fninf.2012.00022/full>`_.
  *Frontiers in Neuroinformatics*, 6:22.

.. raw:: html

  <div class="linkmore"><a href="/publications.html">more publications</a></div>
  <div class="clearer"></div>
  <!-- for dynamic quote update via javascript -->
  <hr />
  <div id="randomquote" title="Feedback from the community">

.. quotes::
   :random: 1

.. raw:: html

  </div><!-- randomquote -->
  <div class="linkmore"><a href="/testimonials.html">more testimonials</a></div>

.. _Ubuntu: http://www.ubuntu.com

.. _repository_howto:
.. _chap_installation:

Get NeuroDebian
===============

Choose on which operating system you want to run NeuroDebian, and select a
download server close to you:

.. include:: sources_lists

.. raw:: html

  <div id="reposetup" style="display:none">

To enable NeuroDebian on your system, simply copy and paste the following
commands into a terminal window:

.. raw:: html

  <pre id="code">
  After selecting a release the setup code will be shown here.
  </pre>

Once this is done, you have to update the package index and you are ready to
install packages. Use your favorite package manager, e.g. synaptic, adept. In
the terminal you can use :command:`apt-get`::

  sudo apt-get update
  sudo apt-get install mricron

.. note::

  Not every package is available for all distributions/releases. For information
  about which package version is available for which release and architecture,
  please have a look at the corresponding package pages.

.. raw:: html

  </div> <!-- end reposetup -->

  <div id="vmsetup" style="display:none">

For all non-Debian operating systems the recommended way to deploy NeuroDebian
is a `virtual appliance`_. On all modern hardware (built within the last 3-4
years) a virtual appliance is a convenient solution to run NeuroDebian
simultaneously with the primary operating system -- without noticable
performance loss.

1. Install NeuroDebian by first downloading this image file:

.. raw:: html

  <div id="vmimagedownload">
  <a href="http://neuro.debian.net/debian/vm/">NeuroDebian images</a>
  </div>

2. Once downloaded, import this image into your VirtualBox_ installation. If you
   do not have VirtualBox_ installed yet, visit the `VirtualBox download page
   <http://www.virtualbox.org/wiki/Downloads>`_ that provides installers for
   Windows, Linux, Mac and Solaris.

3. Please read :ref:`the detailed instructions on setting up the virtual
   appliance <chap_vm>` to complete the configuration of your NeuroDebian
   environment.

.. note::

  If you still running an older VirtualBox 3.x, download one of the image files
  listed below. These older releases are distributed as a `zip` file. Please
  extract all files from the `.zip` file, using appropriate software
  for your operating system.

  * `NeuroDebian 6.0.2 image (32bit)
    <http://neuro.debian.net/debian/vm/neurodebian_6.0.2_i386.zip>`_ [~545MB]

  * `NeuroDebian 6.0.2 image (64bit)
    <http://neuro.debian.net/debian/vm/neurodebian_6.0.2_amd64.zip>`_ [~560MB]

.. raw:: html

  </div> <!-- end vmsetup -->

.. _virtual appliance: http://en.wikipedia.org/wiki/Virtual_appliance
.. _VirtualBox: http://www.virtualbox.org

.. _news:

News
====

.. raw:: html

 <script src="_static/jquery.livetwitter.min.js"></script>
 <div id="identica_widget">[News widget has not been loaded yet]</div>
 <script type="text/javascript">
 $("#identica_widget").liveTwitter('neurodebian',
                                   {service: 'identi.ca',
                                    mode: 'user_timeline',
                                    limit: 10,
                                    rate: 300000});
 </script>

.. _identi.ca: http://identi.ca/neurodebian
.. _twitter: http://twitter.com/NeuroDebian


.. raw:: html

  <hr />
  <div id="sitemap">

* **About**
* :ref:`Team <chap_team>`
* :ref:`chap_popularity`
* :ref:`FAQ <faq>`
* :ref:`Blog <blog>`
* :ref:`chap_publications`
* :ref:`testimonials`
* :ref:`coffeeart`

.. start a new list

* **Services**
* :ref:`Software <pkglists>`
* :ref:`Data <pkgs-by_purpose-neuroscience_datasets>`
* :ref:`Appliance <chap_vm>`

.. start a new list

* **Community**
* :ref:`Mailing lists <chap_mailinglists>`
* `OpenHatch <https://openhatch.org/+projects/NeuroDebian>`_
* `Identi.ca <http://identi.ca/neurodebian>`_
* `Twitter <http://twitter.com/NeuroDebian>`_
* `Google+ <https://plus.google.com/104292290917252528951>`_
* `YouTube <http://www.youtube.com/neurodebian>`_
* `GitHub <https://github.com/neurodebian>`_

.. start a new list

* **Related**
* `Debian <http://www.debian.org>`_
* `Debian Med <http://www.debian.org/devel/debian-med>`_
* `INCF <http://software.incf.org/software/neurodebian>`_
* `NITRC <http://www.nitrc.org/projects/neurodebian>`_

.. raw:: html

  </div><div class="clearer"></div>
  <hr />


.. toctree::
   :hidden:

   blog/index
   faq
   pkgs
   spread
   vm
   publications
   coffeeart
   photoalbum
   projects
   testimonials
   testimonials-topics

.. probably should be purged altogether
.. toctree::
   :hidden:

   booth_sfn2010
   datasets
   livecd
   quotes-nihr01
   quotes-nitrc
   sources_lists
   vm_welcome
   dump

.. include:: link_names.txt
.. include:: substitutions.txt

.. raw:: html

  <script type="text/javascript">
  $(document).ready(function($) {
    //setInterval(function(){
      $.get('testimonials.html', function(data) {
          var quotes = $("blockquote", data);
          var idx = Math.floor(quotes.length * Math.random());
          $('#randomquote').html(quotes[idx]);
      }); // update callback
    //}, 60000); // set interval
  }); // doc ready
  //$("h1").html("NeuroDebian <span style=\"font-size:14px\">&mdash; the ultimate neuroscience software platform</span>")

  function foldbuttontoggle(foldname) {
      var foldid = '#' + foldname;
      var buttonid = foldid + 'button';
      $(buttonid).on('click', function() {
        $('#' + foldname).slideToggle();
        if ($(buttonid).html() == "↓↓↓") {
          $(buttonid).html("&uarr;&uarr;&uarr;");
        }
        else {
          $(buttonid).html("&darr;&darr;&darr;");
        }
      });
      $(foldid).slideUp();
      $(buttonid).html("&darr;&darr;&darr;");
  };

  function createvmdownload(rel, mir) {
        var img_version = '6.0.5';
        var img_suffix;
        var base_url;
        var img_url;
        var md5sum_url;
        if (rel == 'win32') {
            img_suffix = 'i386';
        } else {
            img_suffix = 'amd64';
        };
        if(mir in mirrors) {
            base_url = mirrors[mir] + '/vm/';
            img_url = base_url + 'NeuroDebian_' + img_version + '_' + img_suffix + '.ova';
            md5sum_url = base_url + 'MD5SUMS';
        } else {
            return 'Internal error';
        };
        return '<blockquote><a href="' + img_url
               + '">Virtual applicance image</a> [<a title="Verify image integrity by dowloading this file and running `md5sum -c MD5SUMS`" href="'
               + md5sum_url
               + '">MD5SUM</a>, <a title="Verify authenticity of the MD5SUM file by downloading this file and running `gpg –verify MD5SUMS.gpg`" href="'
               + md5sum_url + '.gpg">MD5SUM.gpg</a>]</blockquote>' ;

  };

  function createrepourl(rel, mir) {
    if(rel in rel2name && mir in mirrors) {

        var retrepo = "wget -O- http://neuro.debian.net/lists/" + rel2name[rel] + "."
         + mir + " | sudo tee /etc/apt/sources.list.d/neurodebian.sources.list\n"
         + "sudo apt-key adv --recv-keys --keyserver pgp.mit.edu 2649A5A9\n";
        return retrepo;
    }

  };
  function updateout(rel, mir) {
     if (rel != '' && mir != '') {
        if (rel in {'win32':'', 'win64':'', 'mac':''}) {
            $('#vmimagedownload').html(createvmdownload(rel, mir));
            $('#vmsetup').slideDown();
            $('#reposetup').slideUp();
        } else {
            $('#code').text(createrepourl(rel, mir));
            $('#reposetup').slideDown();
            $('#vmsetup').slideUp();
        };
     }
     else
     {
        $('#reposetup').slideUp();
        $('#vmsetup').slideUp();
     };
  };
   $('#release').change(function() {
     var singleValues = $("#release").val();
     var mirrorVal = $("#mirror").val();
     updateout(singleValues, mirrorVal);
   });
   $('#mirror').change(function() {
     var singleValues = $("#release").val();
     var mirrorVal = $("#mirror").val();
     updateout(singleValues, mirrorVal);
   });

  $(document).ready(function($) {
     updateout($("#release").val(), $("#mirror").val());
  });

  foldbuttontoggle('morepublications');


  </script>


