Help
====

This page will help you determine the most appropriate channel for your
request or your contribution. Please tell us a little bit about your
particular issue.

.. raw:: html

  <div class="nojavascriptinstructions">
  <div class="alert alert-danger" role="alert">
  <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
  <span class="sr-only">Error:</span>
  This page requires javascript. If disabled, incomplete instructions are
  displayed below</div>
  </div>

  <div id="issuescopepanel" class="panel panel-default">
  <div class="panel-heading">My issue is...</div>
  <ul class="list-group">
  <li class="list-group-item">
  <div class="radio">
    <label>
      <input type="radio" name="issuescope" value="specific">
          ... relatively <strong>specific</strong> to, or concerned with a particular piece of software.
    </label>
  </div> <!-- /.radio -->
  </li>
  <li class="list-group-item">
  <div class="radio">
    <label>
      <input type="radio" name="issuescope" value="general">
      ... of a more <strong>general</strong> scope.
    </label>
  </div> <!-- /.radio -->
  </li>
  </ul>
  </div> <!-- /.panel -->

  <div id="issuenaturepanel" class="panel panel-default">
  <div class="panel-heading">The nature of my issue is...</div>
  <ul class="list-group">
  <li class="list-group-item">
  <div class="radio">
    <label>
      <input type="radio" name="issuenature" value="technical">
        ... rather <strong>technical</strong>, such as a report of broken or
        missing functionality/documentation, or trouble with installation.
    </label>
  </div> <!-- /.radio -->
  </li>
  <li class="list-group-item">
  <div class="radio">
    <label>
      <input type="radio" name="issuenature" value="conceptual">
      ... more <strong>conceptual</strong>, like a "How can I do X?" type of
      question, or anything related to the scientific background and purpose
      of a computational tool.
    </label>
  </div> <!-- /.radio -->
  </li>
  </ul>
  </div> <!-- /.panel -->

.. raw:: html

  <div id="picksoftwarepanel" class="panel panel-info">
  <div class="panel-heading">Select software package</div>
  <div class="panel-body">

Please select the respective software from :ref:`the list of NeuroDebian
packages <pkg_tocs>`, and click the 'Help' button on its web page.

If you do not know what the relevant software package is, here are a few tips:

If you have trouble with a command, you can identify the corresponding package
by running this command in a terminal::

  $ dpkg -S `readlink -f $(which COMMAND)`

where ``COMMAND`` is the name of the command in question.

If you believe there is a problem with a file installed on your system you
can find the responsible package by running::

  $ dpkg -S FULLPATH

where ``FULLPATH`` is the complete absolute path of the file, such as
``/etc/apache2/apache2.conf``.


.. raw:: html

  </div> <!-- /.panel-body -->
  </div> <!-- /.panel -->

  <div id="recommendationpanel" class="panel panel-info">
  <div class="panel-heading">Recommendation</div>
  <div class="panel-body">

.. raw:: html

  <div id="specific-technical-recommendation">

For technical issues with a particular software, please consider the
following checklist:

.. raw:: html

   <ul>
     <li class="pkg_have_readme">Check for relevant information in the
     <a href="http://neuro.debian.net/debian/extracts/###src###/README.Debian">
     README</a>.</li>
     <li class="pkg_have_faq">Check the collection of <a href="###faq###">
     frequently asked questions (FAQ)</a> provided by the <em>###src###</em>
     authors for related information.</li>
     <li>Do a quick search on the web whether somebody posted something
     releated to your issue. Make sure to search the archive of associated
     mailing lists (if there are any).
     </li>
   </ul>

Report bug

.. raw:: html

  </div> <!--specific-technical-recommendation-->

.. raw:: html

  <div id="specific-conceptual-recommendation">

SC

.. raw:: html

  </div> <!--specific-conceptual-recommendation-->

.. raw:: html

  <div id="general-technical-recommendation">

GT

.. raw:: html

  </div> <!--general-technical-recommendation-->

.. raw:: html

  <div id="general-conceptual-recommendation">

GC

.. raw:: html

  </div> <!--general-conceptual-recommendation-->

###p###

###src###

`###homepage### <###homepage###>`_

`###contact### <###contact###>`_

`###faq### <###faq###>`_

.. raw:: html

  </div> <!-- /.panel-body -->
  </div> <!-- /.panel -->

If you believe that there is a bug in ``###p###``, we would be grateful if
you take the time to report it. Only known problems can get fixed!

Here are a few tips to help you report this bug in a way that facilitates its
resolution.

Try to reproduce the bug
  If you cannot reproduce the bug it is likely that the package maintainer
  also cannot do it. Please make an attempt to find out under which
  circumstances the faulty behavior occurs. However, if you can't figure it
  out, please report the bug nevertheless -- maybe someone else can provide
  the missing information.

Describe the problem so that the developer can reproduce it
  That means including every single detail -- not just the "important" ones.
  What kind of system (hardware/software) are you using? What did you do
  exactly when the bug hit you?

  Remember: bug reports are not just input for developers, but also help other
  users to identify whether they are affected by the same problem, and a
  recommended solution applies to them as well.

  A good bug report is an important service to the community!

  More information on high quality bug reporting is available at:
  http://raphaelhertzog.com/go/bugreporting/


Please email bug reports to the neurodebian-users_ or neurodebian-devel_
mailing list -- whichever is more appropriate. In rare cases where your
bug report contains confidential information, please email it directly
to `team@neuro.debian.net <mailto:team@neuro.debian.net?subject=BUG-###pkgname###:>`_.

If you have evidence that the faulty behavior is not specific to NeuroDebian,
your bug report is best directed to the developers of the respective software.

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

    function update_by_form() {
       var scope = $('input[name="issuescope"]:checked').val();
       var nature = $('input[name="issuenature"]:checked').val();
       if ( scope == 'specific' && ! pinfo['p']) {
         $('#recommendationpanel').slideUp();
         $('#issuenaturepanel').slideUp();
         $('#picksoftwarepanel').slideDown();
       } else {
           if ( scope != undefined) {
             $('#issuenaturepanel').slideDown();
             if ( nature != undefined) {
               if ( pinfo['have_readme'] ) { $('.pkg_have_readme').show() };
               if ( pinfo['faq'] ) { $('.pkg_have_faq').show() };
               $('#specific-technical-recommendation').slideUp();
               $('#specific-conceptual-recommendation').slideUp();
               $('#general-technical-recommendation').slideUp();
               $('#general-conceptual-recommendation').slideUp();
               $('#recommendationpanel').slideDown();
               $('#' + scope + '-' + nature + '-recommendation').slideDown();
             };
           };
         $('#picksoftwarepanel').slideUp();
       };
    };

    if ( wasready == undefined ) {var wasready = false};

    $(document).ready(function($) {
       for ( v in pinfo ) {
         var marker = '###' + v + '###';
         $("div.container:contains(" + marker + ")").each(function () {
             $(this).html($(this).html().replace(marker, pinfo[v]))
           });
       };

       $('#picksoftwarepanel').hide();
       $('.pkg_have_readme').hide();
       $('.pkg_have_faq').hide();
       $('#specific-technical-recommendation').hide();
       $('#specific-conceptual-recommendation').hide();
       $('#general-technical-recommendation').hide();
       $('#general-conceptual-recommendation').hide();
       $('#recommendationpanel').hide();

       if ( pinfo['p'] ) {
         if ( pinfo['src'] && !wasready) {
           var slabel = $('label:contains(a particular piece of software)');
           slabel.html(slabel.html().replace("a particular piece of software.",
                                             "the software <em>" + pinfo['src'] + "</em>."));
         };

         $('input[name=issuescope][value=specific]').prop('checked', true);

         $('#issuenaturepanel').show();
       } else {
         $('#issuenaturepanel').hide();
       };

       $('input[name=issuescope]:radio').change(update_by_form);
       $('input[name=issuenature]:radio').change(update_by_form);
       wasready = true;
    });


  </script>

.. include:: link_names.txt
