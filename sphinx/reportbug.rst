Report a bug
============

If you believe that there is a bug in ``###pkgname###``, we would be grateful if
you take the time to report it. Only known problems can get fixed!

Here are a few tips to help you report this bug in a way that facilitates its
resolution.

.. container:: foldup

  .. container:: expandinstructions

     Click on an item to expand it

  Please double-check the name of the faulty package
    If you have trouble with a command, you can identify the corresponding package
    by running this command in a terminal::

      $ dpkg -S `readlink -f $(which COMMAND)`

    where ``COMMAND`` is the name of the command that fails.

    If you believe there is a problem with a file installed on your system you
    can find the responsible package by running::

      $ dpkg -S FULLPATH

    where ``FULLPATH`` is the complete absolute path of the file.

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
    var split = location.search.replace('?', '').split('=')
    if ( split[0] == 'p' ) {
      $(document.body).html($(document.body).html().replace('###pkgname###', split[1]));
    }
  </script>

.. include:: link_names.txt
