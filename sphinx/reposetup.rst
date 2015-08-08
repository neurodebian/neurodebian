Answer a few question and you'll have NeuroDebian running in a few minutes.

.. include:: sources_lists

.. raw:: html

  <div class="nojavascriptinstructions">
  This form requires javascript. If disabled, incomplete instructions are
  displayed below</div>
  <div id="plaininstall-instructions">
  <div class="nojavascriptinstructions">
  Instructions for systems with built-in NeuroDebian built
  </div>

You can enable NeuroDebian by installing the ``neurodebian`` package that
already comes with your operating system. You can do so by, for example,
running this command in a terminal::

  sudo apt-get install neurodebian

Installing this package will automatically configure NeuroDebian as an
additional software repository alongside your standard configuration.

.. raw:: html

  </div> <!-- /#plaininstall-instructions -->

  <div id="repocfg-instructions">
  <div class="nojavascriptinstructions">
  Instructions for Debian-derived systems
  </div>

  <div class="panel panel-default">
  <div class="panel-heading">I want to have...</div>
  <ul class="list-group">
  <li class="list-group-item">
  <div class="radio">
    <label>
      <input type="radio" name="components" value="libre">
          <strong>only</strong> software with guaranteed freedoms.
      <span style=font-size:75%>
          All packages are
          <a href="http://www.debian.org/social_contract#guidelines">DSFG</a>-compliant,
          with permission to use, modify, re-distribute under any condition.
        </span>
    </label>
  </div> <!-- /.radio -->
  </li>
  <li class="list-group-item">
  <div class="radio">
    <label>
      <input type="radio" name="components" value="full">
      all software.<br />
      <span style=font-size:75%>
      Individual packages may have restrictive licenses and you have to
      check license-compliance manually.</span>
    </label>
  </div> <!-- /.radio -->
  </li>
  </ul>
  </div> <!-- /.panel -->
  <div class="reposetup-instructions">

NeuroDebian can be enabled on your system as an additional software repository.
Run the following two commands in a terminal (copy & paste is fine).
This will download the appropriate configuration based on your selection above,
and will also register NeuroDebian's cryptographic key that is used to verify
the integrity of our software packages.

.. raw:: html

  <pre id="code">
  After selecting a release the setup code will be shown here.
  </pre>

Lastly, update the package index and you are ready to install packages::

  sudo apt-get update

You are ready to go -- enjoy NeuroDebian!

.. note::

  Not every package is available for all distributions/releases. For information
  about which package version is available for which release and architecture,
  please have a look at the corresponding package pages.

.. raw:: html

  </div> <!-- end reposetup-instructions -->
  </div> <!-- end repocfg-instructions -->

  <div id="vmsetup-instructions">
  <div class="nojavascriptinstructions">
  Instructions for non-Debian systems
  </div>

On your system NeuroDebian works best as a `virtual appliance`_ (virtual
machine), a program that runs like any other application on your computer.
Today's computers can run such appliances without noticeable performance loss.
To get started:

1. Download this image file (~700 MB):


.. raw:: html

  <div id="vmimagedownload" class="clearfix" style="padding-left:40px;padding-bottom:1em">
  <a href="http://neuro.debian.net/debian/vm/">NeuroDebian images</a>
  </div>

2. Import this image into VirtualBox_. If you do not have VirtualBox_
   installed yet, visit the `VirtualBox download page
   <http://www.virtualbox.org/wiki/Downloads>`_ and get an installer for your
   system (installers for Windows, Linux, Mac and Solaris are available).

3. Finish the configuration by following :ref:`the instructions on setting up
   the virtual appliance <chap_vm>`. `[Virtual machine
   setup video tutorial] <http://www.youtube.com/watch?v=eqfjKV5XaTE>`_

You are ready to go -- enjoy NeuroDebian!

.. note::

  If you want a verified stable (but older) virtual appliances based
  on `Debian 7.8 (wheezy)`_ release, download one of the image files
  listed below.

  * `NeuroDebian 7.8.0 image (32bit)
    <http://neuro.debian.net/debian/vm/NeuroDebian_7.8.0_i386.ova>`_ [~652MB]

  * `NeuroDebian 7.8.0 image (64bit)
    <http://neuro.debian.net/debian/vm/NeuroDebian_7.8.0_amd64.ova>`_ [~650MB]

.. raw:: html

  </div> <!-- end vmsetup-instructions -->

.. _virtual appliance: http://en.wikipedia.org/wiki/Virtual_appliance
.. _VirtualBox: http://www.virtualbox.org

.. raw:: html

  <script type="text/javascript">
  function createvmdownload(rel, mir) {
        var img_version = '8.0.0';
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
        return '<a class="btn btn-primary" role="button" href="' + img_url
               + '">Virtual applicance image</a> <span style="float:right"><a title="Verify authenticity of the MD5SUM file by downloading this file and running `gpg –verify MD5SUMS.gpg`" href="'
               + md5sum_url + '.gpg" class="btn btn-default" role="button">MD5SUM.gpg</a> <a class="btn btn-default" role="button" title="Verify image integrity by dowloading this file and running `md5sum -c MD5SUMS`" href="'
               + md5sum_url
               + '">MD5SUM</a></span>' ;

  };

  function createrepourl(rel, mir, comp) {
    if(mir in mirrors) {
        var retrepo = "wget -O- http://neuro.debian.net/lists/" + rel + "."
         + mir + "." + comp + " | sudo tee /etc/apt/sources.list.d/neurodebian.sources.list\n"
         + "sudo apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9\n";
        return retrepo;
    }

  };

  function update_by_form() {
     var rel = $("#release").val();
     var mir = $("#mirror").val();
     var comp = $('input[name="components"]:checked').val();
     if (rel != '') {
        if (rel in {'sid':'', 'stretch':''}) {
            $('#mirror-input-group').slideUp();
            $('#vmsetup-instructions').slideUp();
            $('#repocfg-instructions').slideUp();
            $('#plaininstall-instructions').slideDown();
        } else {
            $('#plaininstall-instructions').slideUp();
            $('#mirror-input-group').slideDown();
            if (rel in {'win32':'', 'win64':'', 'mac':''}) {
                if (mir != '') {
                    $('#repocfg-instructions').slideUp();
                    $('#vmimagedownload').html(createvmdownload(rel, mir));
                    $('#vmsetup-instructions').slideDown();
                };
            } else {
                $('#vmsetup-instructions').slideUp();
                if (mir != '') {
                    $('#repocfg-instructions').slideDown();
                    if (comp == undefined) {
                      $('.reposetup-instructions').slideUp();
                    } else {
                        $('#code').text(createrepourl(rel, mir, comp));
                        $('.reposetup-instructions').slideDown();
                    };
                };
            };
        };
     }
     else
     {
        $('#mirror-input-group').slideUp();
        $('#repocfg-instructions').slideUp();
        $('#vmsetup-instructions').slideUp();
        $('#plaininstall-instructions').slideUp();
     };
  };

  $(document).ready(function($) {
     update_by_form();
     $('#repocfg-instructions').hide();
     $('.reposetup-instructions').hide();
     $('#vmsetup-instructions').hide();
     $('#plaininstall-instructions').hide();
     $('#mirror-input-group').hide();
     $('#release').change(update_by_form);
     $('#mirror').change(update_by_form);
     $('input[name=components]:radio').change(update_by_form);
  });

  </script>
