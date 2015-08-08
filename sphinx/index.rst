.. _WELCOme:

.. raw:: html

    <div id="myCarousel" class="carousel slide" data-ride="carousel">
      <!-- Indicators -->
      <ol class="carousel-indicators">
        <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
        <li data-target="#myCarousel" data-slide-to="1"></li>
        <li data-target="#myCarousel" data-slide-to="2"></li>
      </ol>
      <div class="carousel-inner">
        <div class="item active">
          <!--<img src="pics/carus_7T_CBBS_Image_DMahler.jpg" alt="fMRI scanner">-->
          <div class="container">
            <div class="carousel-caption">
              <h1>Community-driven</h1>
              <p>Halchenko, Y. O. &amp; Hanke, M. (2012).
              Open is not enough. Let’s take the next step: An integrated,
              community-driven computing platform for neuroscience
              <em>Frontiers in Neuroinformatics</em>, 6:22.</p>
              <p><a class="btn btn-primary"
              href="http://www.frontiersin.org/Neuroinformatics/10.3389/fninf.2012.00022/full"
              target="_blank"
              role="button">Learn more &raquo;</a></p>
            </div>
          </div>
        </div>
        <div class="item">
          <!--<img src="pics/carus_jennyboat.jpg" alt="Shrimp boat">-->
          <div class="container">
            <div class="carousel-caption">
              <h1>Testimonial</h1>
              <p id="randomquote"></p>
              <p><a class="btn btn-primary" href="testimonials.html" role="button">Read more &raquo;</a></p>
            </div>
          </div>
        </div>
        <div class="item">
          <div class="container">
            <div class="carousel-caption">
              <h1>News &amp; Updates</h1>
              <a class="twitter-timeline" href="https://twitter.com/NeuroDebian"
                  data-widget-id="360194288006606848"
                  data-link-color="#820430"
                  height="130px"
                  data-show-replies="false"
                  data-chrome="noheader nofooter transparent">Tweets by @NeuroDebian</a>
               <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>

              <div class="nojavascriptinstructions">The news widget requires javascript</div>
              <p><a class="btn btn-primary" href="https://twitter.com/NeuroDebian" role="button" target="_blank">See time line &raquo;</a></p>
            </div>
          </div>
        </div>
      </div>
      <a class="left carousel-control" href="#myCarousel" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span></a>
      <a class="right carousel-control" href="#myCarousel" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span></a>
    </div><!-- /.carousel -->

NeuroDebian provides a large collection of popular neuroscience research
software for the Debian_ operating system as well as Ubuntu_ and other
derivatives. Popular packages include :ref:`AFNI <binary_pkg_afni>`,
:ref:`FSL <binary_pkg_fsl-complete>`, :ref:`PyMVPA <binary_pkg_python-mvpa2>` and
:ref:`many others <pkg_tocs>`. While we do strive to maintain a high level of
quality, we make no guarantee that a given package works as expected, so use
them at your own risk. If you do encounter problems or you just like to say
thanks, simply :ref:`send us an email <chap_contacts>`.

.. _Ubuntu: http://www.ubuntu.com

.. _repository_howto:
.. _chap_installation:

Get NeuroDebian
===============

.. include:: reposetup.rst

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

  <div class="row center-block">
  <div class="col-xs-3">

* About

  * :ref:`The Team <chap_team>`
  * :ref:`FAQ <faq>`
  * :ref:`Blog <blog>`
  * :ref:`chap_popularity`
  * :ref:`chap_publications`
  * :ref:`chap_acknowledgements`
  * :ref:`testimonials`
  * :ref:`coffeeart`

.. start a new list

.. raw:: html

  </div> <!-- .col-xs-3 -->
  <div class="col-xs-3">

* Services

  * :ref:`Software <pkg_tocs>`
  * :ref:`Data <toc_pkgs_for_release_data>`
  * :ref:`Appliance <chap_vm>`
  * :ref:`Mirrors <chap_mirrors_stats>`

.. start a new list

.. raw:: html

  </div> <!-- .col-xs-3 -->
  <div class="col-xs-3">

* Community

  * :ref:`Contacts <chap_contacts>`
  * :ref:`Mailing lists <chap_mailinglists>`
  * `OpenHatch <https://openhatch.org/+projects/NeuroDebian>`_
  * `Identi.ca <http://identi.ca/neurodebian>`_
  * `Twitter <http://twitter.com/NeuroDebian>`_
  * `Google+ <https://plus.google.com/104292290917252528951>`_
  * `YouTube <http://www.youtube.com/neurodebian>`_
  * `GitHub <https://github.com/neurodebian>`_

.. start a new list

.. raw:: html

  </div> <!-- .col-xs-3 -->
  <div class="col-xs-3">

* Related

  * `Debian <http://www.debian.org>`_
  * `Debian Med <http://www.debian.org/devel/debian-med>`_
  * `INCF <http://software.incf.org/software/neurodebian>`_
  * `NITRC <http://www.nitrc.org/projects/neurodebian>`_

.. raw:: html

  </div> <!-- .col-xs-3 -->
  </div><!-- /.row -->


.. toctree::
   :hidden:

   blog/index
   faq
   thanks
   popularity
   spread
   publications
   coffeeart
   photoalbum
   projects
   testimonials
   derivatives

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
