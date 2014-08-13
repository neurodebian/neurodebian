First select what kind of operating system you are using, and then choose a
download server close to you:

.. include:: sources_lists

.. raw:: html

  <div class="nojavascriptinstructions">
  This form requires javascript. If disabled, incomplete instructions are
  displayed below</div>
  <div id="repoconfig">
  <div class="nojavascriptinstructions">
  Instructions for Debian-derived systems
  </div>
  <p>Select desired components:<br />
  <table><tr>
  <td><input type="radio" name="components" value="libre"></td>
  <td><strong>only</strong> software with guaranteed freedoms<br />
    <span style=font-size:75%>all packages are
    <a href="http://www.debian.org/social_contract#guidelines">DSFG</a>-compliant,
    with permission to use, modify, re-distribute under any condition</span></td></tr>
  <tr><td><input type="radio" name="components" value="full"></td>
  <td>all software<br />
    <span style=font-size:75%>
    individual packages may have restrictive licenses and you are required to
    check license-compliance manually
    </span></td></tr>
  </table>
  <div class="reposetup">

You can enable NeuroDebian on your system by simply copying and pasting the
following two commands into a terminal window. This will add the NeuroDebian
repository to your native package management system, and you will be able to
install neuroscience software the same way as any other package.

.. raw:: html

  <pre id="code">
  After selecting a release the setup code will be shown here.
  </pre>

Now you can update the package index and you are ready to install packages.
Simply execute the following command in a terminal::

  sudo apt-get update

You are ready to go -- enjoy NeuroDebian!

.. note::

  Not every package is available for all distributions/releases. For information
  about which package version is available for which release and architecture,
  please have a look at the corresponding package pages.

.. raw:: html

  </div> <!-- end reposetup -->
  </div> <!-- end repoconfig -->

  <div id="vmsetup">
  <div class="nojavascriptinstructions">
  Instructions for non-Debian systems
  </div>

For all non-Debian operating systems we recommend to deploy NeuroDebian as a
`virtual appliance`_ (virtual machine) -- this will only take a few minutes.
On all modern hardware (built within
the last 3-4 years) a virtual appliance is a convenient solution to run
NeuroDebian simultaneously with the primary operating system -- without
noticeable performance loss. To start using NeuroDebian:

1. Download this image file:

.. raw:: html

  <div id="vmimagedownload">
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
  on `Debian 6.0 (squeeze)`_ release, download one of the image files
  listed below.

  * `NeuroDebian 6.0.6 image (32bit)
    <http://neuro.debian.net/debian/vm/NeuroDebian_6.0.6_i386.ova>`_ [~559MB]

  * `NeuroDebian 6.0.6 image (64bit)
    <http://neuro.debian.net/debian/vm/NeuroDebian_6.0.6_amd64.ova>`_ [~576MB]

.. raw:: html

  </div> <!-- end vmsetup -->

.. _virtual appliance: http://en.wikipedia.org/wiki/Virtual_appliance
.. _VirtualBox: http://www.virtualbox.org

.. raw:: html

  <script type="text/javascript">
  function createvmdownload(rel, mir) {
        var img_version = '7.4.20140423';
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
     if (rel != '' && mir != '') {
        if (rel in {'win32':'', 'win64':'', 'mac':''}) {
            $('#vmimagedownload').html(createvmdownload(rel, mir));
            $('#vmsetup').slideDown();
            $('#repoconfig').slideUp();
        } else {
            $('#vmsetup').slideUp();
            $('#repoconfig').slideDown();
            if (comp == undefined) {
              $('.reposetup').slideUp();
            } else {
              $('#code').text(createrepourl(rel, mir, comp));
              $('.reposetup').slideDown();
            }
        };
     }
     else
     {
        $('#repoconfig').slideUp();
        $('#vmsetup').slideUp();
     };
  };

  $(document).ready(function($) {
     update_by_form();
     $('#repoconfig').hide()
     $('.reposetup').hide();
     $('#vmsetup').hide()
     $('#release').change(update_by_form);
     $('#mirror').change(update_by_form);
     $('input[name=components]:radio').change(update_by_form);
  });

  </script>
