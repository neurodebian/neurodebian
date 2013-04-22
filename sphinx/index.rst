.. _WELCOme:

*********************************************
 The Ultimate Neuroscience Software Platform
*********************************************

NeuroDebian provides a large collection of popular neuroscience research
software for the Debian_ operating system as well as Ubuntu_ and other
derivatives. Popular packages include FSL, Freesurfer, AFNI, PyMVPA and
:ref:`many others <pkg_tocs>`. While we do strive to maintain a high level of
quality, we make no guarantee that a given package works as expected, so use
them at your own risk. If you do encounter problems or you just like to say
thanks, simply :ref:`send us an email <chap_contacts>`.

Learn more about NeuroDebian, the goals of this project, and help us |spread|!

  Halchenko, Y. O. & Hanke, M. (2012). `Open is not enough. Let’s take the
  next step: An integrated, community-driven computing platform for neuroscience
  <http://www.frontiersin.org/Neuroinformatics/10.3389/fninf.2012.00022/full>`_.
  *Frontiers in Neuroinformatics*, 6:22.

.. raw:: html

  <div class="linkmore"><a href="publications.html" name="publications">more publications</a></div>
  <div class="clearer"></div>
  <!-- for dynamic quote update via javascript -->
  <hr />
  <div id="randomquote" title="Feedback from the community">

.. quotes::
   :random: 1

.. raw:: html

  </div><!-- randomquote -->
  <div class="linkmore"><a href="testimonials.html">more testimonials</a></div>

.. _Ubuntu: http://www.ubuntu.com

.. _repository_howto:
.. _chap_installation:

Get NeuroDebian
===============

.. include:: reposetup.rst

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
 <div class="nojavascriptinstructions">
 The news widget requires javascript
 </div>

.. _identi.ca: http://identi.ca/neurodebian
.. _twitter: http://twitter.com/NeuroDebian


.. raw:: html

  <hr />
  <div id="sitemap">
  <!-- Some anchors to orient users of old-website urls -->
  <a name="acknowledgements"/>
  <a name="contacts"/>
  <a name="the-team"/>
  <a name="debian-installation"/>
  <a name="virtual-machine"/>
  <a name="ways-to-use-neurodebian">&nbsp;</a>

* **About**
* :ref:`The Team <chap_team>`
* :ref:`FAQ <faq>`
* :ref:`Blog <blog>`
* :ref:`chap_popularity`
* :ref:`chap_publications`
* :ref:`chap_acknowledgements`
* :ref:`testimonials`
* :ref:`coffeeart`

.. start a new list

* **Services**
* :ref:`Software <pkg_tocs>`
* :ref:`Data <toc_pkgs_for_release_data>`
* :ref:`Appliance <chap_vm>`

.. start a new list

* **Community**
* :ref:`Contacts <chap_contacts>`
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
   thanks
   popularity
   about
   pkgs
   spread
   vm
   publications
   coffeeart
   photoalbum
   projects
   testimonials
   testimonials-topics
   vm_welcome
   derivatives

.. are these supposed to be visible?
.. toctree::
   :hidden:

   machines
   todo

.. toctree::
   :hidden:
   :glob:

   pkgs/*
   pkglists/*

.. probably should be purged altogether
.. toctree::
   :hidden:

   livecd
   quotes-nihr01
   quotes-nitrc

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

  </script>
