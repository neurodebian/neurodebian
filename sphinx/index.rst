.. _WELCOme:

*************
 NeuroDebian
*************

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

  <!-- for dynamic quote update via javascript -->
  <hr />
  <div id="randomquote" title="Feedback from the community">

.. quotes::
   :random: 1

.. raw:: html

  </div><!-- randomquote -->

.. _Ubuntu: http://www.ubuntu.com

.. _repository_howto:
.. _chap_installation:

Get NeuroDebian
===============

Make your selection to enable NeuroDebian on your computer:

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
 <div id="identica_widget"></div>
 <script type="text/javascript">
 $("#identica_widget").liveTwitter('neurodebian',
                                   {service: 'identi.ca',
                                    mode: 'user_timeline',
                                    limit: 10,
                                    rate: 300000});
 </script>

For more news and information see our :ref:`blog <blog>`. Older news items are
available on identi.ca_. Follow us on identi.ca_ (preferred) or twitter_ to
subscribe to the NeuroDebian news.

.. _identi.ca: http://identi.ca/neurodebian
.. _twitter: http://twitter.com/NeuroDebian




.. _support:

Contacts
========

`Email us directly <team@neuro.debian.net>`_ with any "private"
communication.  Otherwise please use our public mailing lists, which
exist not only to provide user-support but also to establish
communication channels within the NeuroDebian community

* neurodebian-users_: Discussions and support of NeuroDebian users

* neurodebian-upstream_: General discussions and knowledge sharing
  among developers of neuroscience software.  We also use it
  to update you with summaries of recent relevant developments in
  Debian project

* neurodebian-devel_: Technical mailing list for discussions on
  NeuroDebian development

You are welcome also to join #neurodebian IRC room on OFTC network if
you have quick questions or want to join a live discussion.

.. _chap_team:

The team
========

`Michael Hanke <http://mih.voxindeserto.de>`_ and `Yaroslav Halchenko
<http://www.onerussian.com>`_ originally started NeuroDebian (formerly the
`Experimental Psychology Debian packaging project
<http://alioth.debian.org/projects/pkg-exppsy>`_) and are the current project
leaders. However, the whole project would not be possible without the work of
over 3,000 Debian_ developers and contributors who are as enthusiastically
building the Debian operating system.
A number of packages that are available from the NeuroDebian repository have
been contributed by various individuals and other teams in Debian, such as
`Debian Med`_ and `Debian Science`_. We want to express our gratitude to all
maintainers_ that help to make Debian_ the ultimate software platform for
neuroscience.

.. _maintainers: pkgs.html#by-maintainer


Acknowledgements
================

We are grateful to `Jim Haxby`_ for his continued support and :ref:`endless supply of
Italian espresso <coffeeart>`.

.. _Jim Haxby: http://haxbylab.dartmouth.edu/ppl/jim.html

Thanks to the following institutions and individuals for hosting a mirror:

* `Department of Psychological and Brain Sciences at Dartmouth College`_
  *[us-nh]* (primary mirror)
* `Department of Experimental Psychology at the University of Magdeburg`_
  *[de-md]*
* `Neurobot at Aristotle University of Thessaloniki, Greece`_ *[gr]*
* `Paul Ivanov`_ *[us-ca]*
* `Medical-image Analysis and Statistical Interpretation lab at Vanderbilt`_
  *[us-tn]*
* `Australia's research and education network (AARNET)
  <http://www.aarnet.edu.au>`_ *[au]*
* Kiyotaka Nemoto (AKA Mr. Lin4Neuro_) *[jp]*
* Iaroslav Iurchenko *[ua]*
* `Nikolaus Valentin Haenel`_ *[de-v]*

If your are interested in mirroring the repository, please see the :ref:`faq`.

.. _Department of Psychological and Brain Sciences at Dartmouth College: http://www.dartmouth.edu/~psych
.. _Department of Experimental Psychology at the University of Magdeburg: http://apsy.gse.uni-magdeburg.de
.. _Neurobot at Aristotle University of Thessaloniki, Greece: http://neurobot.bio.auth.gr
.. _Paul Ivanov: http://www.pirsquared.org
.. _Medical-image Analysis and Statistical Interpretation lab at Vanderbilt: https://masi.vuse.vanderbilt.edu
.. _Nikolaus Valentin Haenel: http://haenel.co


Publications
============

Hanke, M. (2012). `Share your tools! But fear the wombat! Seriously.
<http://neuro.debian.net/_files/Hanke_FearTheWombat_Brainhack2012.pdf>`_  *Talk
given at* `Brainhack <http://brainhack.org/2012/04/06/brainhack-2012-unconference>`_ 2012 at the
Max-Planck-Institute for Human Cognitive and Brain Sciences*, Leipzig, Germany.
[`video <http://youtu.be/8t6znEOEDVo>`_]

Hanke, M. (2012). `Computational and cognitive neuroscience boosted by Debian
OR Just using Debian is not enough
<http://neuro.debian.net/_files/Hanke_UsingDebianIsNotEnough_ESRF2012.pdf>`_.
Talk given at the workshop "Debian for Scientific Facilities Days" at the
European Synchrotron Radiation Facility (ESRF), Grenoble, France.

Halchenko, Y. O. & Hanke, M. (2012). `Open is not enough. Let’s take the
next step: An integrated, community-driven computing platform for neuroscience
<http://www.frontiersin.org/Neuroinformatics/10.3389/fninf.2012.00022/full>`_. *Frontiers in Neuroinformatics*,
6:22.

.. raw:: html

  <span id="morepublicationsbutton" class="button" title="Click to toogle more"></span>
  <div id="morepublications">

Hanke, M. (2012). `The why and how of getting packaged
<_files/Hanke_GetPackaged_CodeJam5_2012.pdf>`_.
*Talk given at BrainScaleS CodeJam 5, Convergence in Computational Neuroscience*,
University of Edinburgh, Edinburgh, UK.

Halchenko, Y. O. & Hanke, M. (2012). `Environments for efficient
contemporary research in neuroimaging: PyMVPA and NeuroDebian
<_files/HalchenkoHanke_ContemporaryNeuroimaging_PENN2012.pdf>`_.
*Talk given at the University of Pennsylvania School of Medicine*,
Philadelphia, PA, USA.

Hanke, M. (2012). `Rock solid, brand new, everyday, for free, not a joke:
NeuroDebian <_files/Hanke_NeuroDebian_MPI2012.pdf>`_.
*Talk given at the Max-Planck-Institute for Human Cognitive and Brain
Sciences*, Leipzig, Germany.

Hanke, M. (2011). `More than batteries included: NeuroDebian
<_files/Hanke_NeuroDebian_EuroSciPy2011.pdf>`_.
*Talk given at the Python in Neuroscience satellite of EuroScipy 2011*,
Paris, France.

Halchenko, Y. O. (2011). `π's in Debian or Scientific Debian: NumPy, SciPy and beyond
<_files/Halchenko_EuroScipy11_3_14s_in_Debian.pdf>`_.
*Talk given at* `EuroScipy 2011 <http://www.euroscipy.org/talk/4379>`_,
Paris, France.

Hanke, M. & Halchenko, Y. O. (2011). `Neuroscience runs on GNU/Linux
<http://www.frontiersin.org/Neuroinformatics/10.3389/fninf.2011.00008/full>`_.
*Frontiers in Neuroinformatics, 5:8*.

Hanke, M., Halchenko, Y. O. & Haxby, J. V. (2011). `NeuroDebian -- versatile
platform for brain-imaging research <_files/NeuroDebian_HBM2011.png>`_
*Poster presented at the annual meeting of the Organisation for Human Brain
Mapping*, Quebec City, Canada.

Hanke, M. (2011). `Integrating Condor into the Debian operating system
<_files/Hanke_CondorDebianIntegration_CondorWeek2011.pdf>`_.
*Talk given at* `CondorWeek 2011
<http://www.cs.wisc.edu/condor/CondorWeek2011/wednesday_condor.html>`_,
Madison, Wisconsin, USA.

Hanke, M. & Halchenko, Y. O. (2010). :ref:`Report from the Debian booth at
SfN2010 <chap_debian_booth_sfn2010>`. *Annual meeting of the Society for
Neuroscience*, San Diego, USA.

Halchenko, Y. O., Hanke, M., Haxby, J. V., Pollmann, S. & Raizada, R. D.
(2010). `Having trouble getting your Nature paper? Maybe you are not using the
right tools? <_files/NeuroDebian_SfN2010.png>`_ *Poster presented at the
annual meeting of the Society for Neuroscience*, San Diego, USA.

Hanke, M., Halchenko, Y. O. (2010). `Debian: The ultimate platform for
neuroimaging research <_files/HankeHalchenko_NeuroDebianDebConf10.pdf>`_.
*Talk given at* DebConf10_, New York City, USA. [video:
`low resolution <http://meetings-archive.debian.net/pub/debian-meetings/2010/debconf10/low/1310_1310_Debian_The_ultimate_platform_for_neuroimaging_research.ogv>`_,
`high resolution <http://meetings-archive.debian.net/pub/debian-meetings/2010/debconf10/high/1310_1310_Debian_The_ultimate_platform_for_neuroimaging_research.ogv>`_]

Hanke, M., Halchenko, Y. O., Haxby, J. V. & Pollmann, S. (2010). `Improving
efficiency in cognitive neuroscience research with NeuroDebian
<_files/NeuroDebian_CNS2010.pdf>`_. *Poster presented at the annual
meeting of the Cognitive Neuroscience Society*, Montréal, Canada.

Halchenko, Y. O., Hanke, M. (2009). `An ecosystem of neuroimaging,
statistical learning, and open-source software to make research more
efficient, more open, and more fun
<_files/HalchenkoHanke_FossEcosystemDC09.pdf>`_. *Talk given at*
`Dartmouth College`_, New Hampshire, USA.

.. raw:: html

  </div>

.. _DebConf10: http://debconf10.debconf.org/
.. _Dartmouth College: http://www.dartmouth.edu/

Popularity
==========

.. raw:: html

 <p><img border="0" src="_files/nd_subscriptionstats.png" title="Statistics of new repository subscriptions for all supported releases. Note: subscription is only done once per machine." /></p>

Popularity Contest
------------------

We encourage you to participate in the `popularity
contest <http://popcon.debian.org>`_ (popcon), which anonymously
collects the list of packages you installed/use on your system.
Collecting such statistics is of particular importance for research
software projects as a prove of an existing user-base.  If upon
installation of the system you rejected the invitation to participate
you can always change your decision by running::

 sudo dpkg-reconfigure popularity-contest

.. note::

   If you are deploying multiple systems through cloning, to not have
   all systems considered as one, it would be necessary to re-generate
   the random MY_HOSTID.  Following commands ran as root should do it
   (as root) without any interactive dialog::

    sed -i -e 's,PARTICIPATE *= *.no.,PARTICIPATE="yes",g' -e '/^ *MY_HOSTID/d' /etc/popularity-contest.conf
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure popularity-contest

In addition to popcon pages for your "core" distribution (e.g. `Debian
<http://popcon.debian.org/>`__ or `Ubuntu
<http://popcon.ubuntu.com/>`__) you can see/get statistics for
submissions to `NeuroDebian <http://neuro.debian.net/popcon/>`__ and
know that you are already contributing back to the community.


.. toctree::
   :hidden:

   blog/index
   faq
   pkgs
   spread
   vm
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

.. include:: link_names.txt
.. include:: substitutions.txt

.. raw:: html

  <script type="text/javascript">
  $(document).ready(function($) {
    setInterval(function(){
      $.get('testimonials.html', function(data) {
          var quotes = $("blockquote", data);
          var idx = Math.floor(quotes.length * Math.random());
          $('#randomquote').html(quotes[idx]);
      }); // update callback
    }, 60000); // set interval
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


