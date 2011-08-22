:date: 2011-08-20 20:00:00
:tags: neuroscience, software, packaging

.. _chap_neurosoftware_packaging:

What does it take to get some software packaged?
================================================

We often get contacted by people who wrote some scientific software and
would like to see it being available from the NeuroDebian repository.
Most of these developers don't know what it actually means to *package*
software, how time-consuming the process is, and who needs to do what to
get things done.

There is already a lot of information about *distribution packaging* on the
web, including "best-practices" documentation for upstream_-developers,
such as `Debian's upstream guide`_, and it would be pointless to repeat all
these bits here. Instead we will focus on a few core aspects that we found
to be the most ignored and misunderstood concepts that heavily influence
the speed and complexity of the *packaging process*.

.. _upstream: http://en.wikipedia.org/wiki/Upstream_(software_development)
.. _Debian's upstream guide: http://wiki.debian.org/UpstreamGuide

So what exactly is a *package*? The ultra-short summary: it is first and
foremost an executable description of how to build software from source and
install the resulting binaries, while ensuring compatibility and
interoperability with other parts of a particular system.  Hence, although
Debian-based operating systems install packages containing *binaries*, the
main focus of the packaging process is on the **source package**.  The
end-product of the packaging process is a source package that enables
**anybody** to produce binary packages in a *uniform* and *deterministic*
fashion, with an exhaustive description of its dependencies.

To understand how that is done any interested person **needs** to read a
fair bit of documentation, for example a `packaging tutorial`_, and the
`Debian policy`_ -- the ultimate guidelines for proper Debian packages.
But albeit being an interesting read for anyone, it is actually the
*package maintainer*'s job to get all this done right. However, there are a
few key aspects about packaging that any developer should know, as they
will make the difference between getting a package done in a few hours, or
only after weeks, months, or years of tedious work. These are:

* A reliable versioning scheme
* Exhaustive documentation of involved licenses
* Clear separation of 3rd-party code
* An open ear

.. instead of saying that "packaging is only for us, Debian gurus",
.. here would be a good point to say that "having those requirements
.. fullfilled packaging becomes and easy task, which could be tackled
.. having read the tutorial and then seeking the
.. mentorship/sponsorship".

Have a deterministic version!
-----------------------------

Software need a version, packages need a version. The version is used to
determine whether an update is available, whether a particular package can
be used to satisfy a versioned dependency of another package, to associate
bug reports with source code, and, of course, to tell users what version
of a software they are running.  Surprisingly, there is a lot of scientific
software out there that doesn't have a version, or pretends to have one,
but the actual source code changes without a corresponding change in the
version. This is **wrong**. If you want to have your software packaged, have
a reliable version scheme:

.. altogether a bit of a mix -- we don't increment any version while
.. working on the code -- we increment whenever making it publicly
.. available outside of VCS

.. also, strictly speaking, "sources" contain not only the 'code' which
.. we need to version -- docs/images/data/etc; thus I have replaced 'code'
.. on some occurrences

* *Increment* the version whenever you change publicly available
  release or tarball of your project (even for tiny changes).
* Put the version into the filename of your source or binary download.
* And/or use a `version control system`_ (VCS) that does that versioning for
  you.

.. VCS doesn't do versioning per se -- it does changes tracking
.. possibly with unique identified which could be treated as a version

.. _version control system: http://en.wikipedia.org/wiki/Comparison_of_revision_control_software

If you don't have a deterministic version, the package maintainer
needs to come up with one, possibly complementing to the original
version which remains stale while released material changes.
Such custom version could be based on the time-stamp of a download, or the last
modification time of any file in the source distribution.  But whatever the
maintainer will come up with, it will take time, and it will be different
from what you do. This will make packaging more complex, and it will
confuse users.


Be conscious about all licenses!
--------------------------------

Licenses are important. They determine whether a 3rd-party, such as a
Debian, is legally allowed to redistribute your software. They determine
whether a package maintainer is allowed to modify software for improved
system integration or bug fixing. They also have an impact on people's
motivation to contribute to a project. For example, many people out there
would rather not invest their time in software with restrictive licenses.

Be aware that the collection of *all* licenses in your source code form the
legal terms of your software. We often see "open-source" software that is "free
to use", but depends on, or includes source code that "may not be
redistributed".  This is probably **wrong**. Moreover, we encountered quite a
few projects that hadn't picked any license at all. If you intend other people
to use your tools this is **wrong** too, as no license typically means no
permissions at all -- not even to download or to use.

The package maintainer needs to sort all these things out, needs to
make sure that redistribution doesn't impose a legal threat to anyone
(including repository mirror operators), and needs to make sure that people
expecting free and open-source software only get free and open-source
software.

If you want to facilitate the packaging process: Make sure that you are
aware of all licenses covering the source code and other materials
(such as documentation and images) in your software. Make sure
to document them properly.  Make sure that the licenses
covering the source code are compatible to each other (e.g. you cannot
release under the GPL_ if the license of some other part of your code says
"must not be used on Thursdays"). The easiest way to avoid unnecessary
complications is to use a `standard license`_ (such as BSD, or GPL) that
are known and have been evaluated by legal experts regarding their
implications and their compatibility with each other.  Beware that
standard licenses created to cover programs source code are not always
appropriate for content (e.g. images and documentation) or data (which
might not even be copyrightable in some jurisdictions such as USA).  You
can find some of popular licenses for content and data on
`Open Knowledge Definition (OKD)
<http://www.opendefinition.org/licenses>`_ website.  For any license, check if your legal
terms comply with the `open-source definition`_ or the `Debian free software
guidelines`_ (that are the basis of this definition).

.. _GPL: http://www.gnu.org/copyleft/gpl.html
.. _open-source definition: http://www.opensource.org/docs/osd
.. _Debian free software guidelines: http://www.debian.org/social_contract#guidelines


Allow for modularity!
---------------------

Usually, software authors already have means to build their code for Debian
or Ubuntu systems before contacting a potential packager. However, quite
often these procedures need to be adjusted (and sometimes even abandoned)
for a distribution package. A prominent reason is the inclusion of
3rd-party source code. Virtually all software is built on top of some other
software -- may it be a GUI toolkit or a numerical library. Occasionally,
it makes sense to include the more exotic dependencies into a source
distribution of some software, mainly to make building and installing
easier for people on less fortunate platforms.

However, for a distribution package such setup is typically not acceptable.
An operating system like Debian is a modular system were duplication needs
to be avoided. There should only be a single copy of a particular library
or tool in the distribution. All packages that require a piece of 3rd-party
software need to declare a dependency on the corresponding package and
should not ship their own copy. This has the advantage that bugs in a
software can be fixed in a single place and all dependent software
automatically benefits from this fix, without further human intervention.
Only a modular design like this makes it possible to successfully maintain
an integrated system of tens of thousands software packages with a
reasonable amount of manpower.

So if your source distribution contains 3rd-party software, clearly
identify its origin and version (the license as well, of course). This
informs the packager which dependencies need to be declared, or potentially
which other software still needs to be packaged separately, in order to
serve as a dependency.

As a consequence of the dependency system, you should not modify 3rd-party
software. If you, for example, take the source of a library and modify it a
bit to make it easier for you to do a certain task, there is suddenly the
need for having two almost identical libraries in the operating system. The
package for your software cannot use the system package for this library,
because it is modified. Instead of keep a modified version: if you need to
fix bugs in 3rd-party software, make sure to forward the fixes to the
original developers. If you need to adapt its behavior, try to do it in a
way that is modular, keeping the adaptor separate from the 3rd-party code.
This will make it much easier for you to track future developments of this
code, as well as help the packager integrate your software into the
operating system.

Also, you will significantly facilitate the packaging process if your
build-system allows to optionally build and link against system libraries
instead of the convenience copies that may be included in your source code.
Keep in mind that anything that is *required* for packaging software for
Debian needs to be added or modified by the package maintainer. All
modifications can potentially change the behavior of your software and may
confuse users and/or result in unnecessary support requests that need to be
dealt with. Be assured that it is in the very interest of the package
maintainer to keep the differences minimal. If you keep modularity aspects
in mind while developing you can massively facilitate a packaging effort.


Be prepared for feedback!
-------------------------

The package maintainer might send you a few patches during the initial
packaging that either fix bugs on the Debian platform or that were added to
gain compliance with the Debian policy. Be prepared to evaluate these
patches and merge them into your code base or discuss necessary
modifications. The package maintainer needs to keep track of all
modifications done to your software and needs to refresh them for every new
release that is made. If you make it easy for the maintainer to do this
work, for example quickly merging modifications, by exposing a version
control system to track modifications, or at least a reliable communication
channel that informs the maintainer about the fate of the patches, you will
help to streamline long-term package maintenance and contribute to a
reliable package. All this will help disseminating your software in an
extremely convenient form to a very large audience.
