Install a package
=================

Step 1
------

*[skip this steps if your are using the NeuroDebian virtual machine or if your
machine is already configured to use this repository]*

.. include:: reposetup.rst

Step 2
------

To install the ``###p###`` package on your system or virtual machine,
open a terminal and execute the following command::

  sudo apt-get install ###p###

.. raw:: html

  <script type="text/javascript">
    function getUrlVars() {
      var vars = {};
      var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
      });
      return vars;
    };

    var pinfo = getUrlVars();

    if ( wasready == undefined ) {var wasready = false};

    $(document).ready(function($) {
       for ( v in pinfo ) {
         var marker = '###' + v + '###';
         $("div.container:contains(" + marker + ")").each(function () {
             $(this).html($(this).html().replace(RegExp(marker, 'g'), pinfo[v]))
           });
       };

       if ( 'non_free' in pinfo ) {
         $('input[name=components][value=full]').prop('checked', true);
       };
       wasready = true;
    });


  </script>


