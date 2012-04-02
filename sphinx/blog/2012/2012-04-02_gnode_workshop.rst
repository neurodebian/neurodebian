:date: 2012-04-02 00:00:00
:tags: G-Node, neuroscience, software, electrophysiology, neuroshare

.. _chap_gnode_packaging_workshop_2012:


Exciting new software for electrophysiology -- NeuroDebian@G-Node
=================================================================

Upon an invitation by `Thomas Wachtler`_, on Feb 28 2012 NeuroDebian visited
the German INCF_ node -- `G-Node`_ for a short workshop on Debian packaging.
G-Node drives a number of software projects primarily focused on
electrophysiology research -- ranging from server-side data storage to data
access and analysis tools for workstations.  None of those are part of
(Neuro)Debian yet, so all participants had high hopes to change this as soon as
possible.

During the workshop we looked into various projects and discussed how they
could be packaged for Debian. Fortunately, it turned out that the majority of
the necessary packaging work will be fairly straightforward and there are no
obvious show stoppers, such as licensing problems, that would prevent inclusion
into Debian in a rather near future. This is especially exciting as no less than
three key infrastructure problems of electrophysiology research, and
electrophysiology on Linux machines in particular will be tackled with the new
packages.


Access proprietary data formats
-------------------------------

Maybe one of the most pressing issues is data access. There are numerous
hardware vendors for data acquisition devices that all have their own
proprietary data formats. This is a serious obstacle when it comes to data
sharing efforts or collaborative work in general. To access such data, one
depends on the vendor to provide support for a particular computing
environment. However, not surprisingly this support is typically limited to the
Windows platform, or other commercial systems, such as Matlab.

For many years these hardware vendors could not agree on a common data format,
but instead came up with a standardized API to access vendor specific IO
libraries to ease the life of developers trying to add support for a data
format to their software. This standardization initiative is called
Neuroshare_.  Unfortunately, it does not address the core of the problem, as it
still requires the vendors-specific libraries implementing the Neuroshare-API
to access a proprietary data format -- and of course the vast majority of these
libraries is closed-source and Windows-only.

G-Node has developed a Wine_-base solution that behaves like a Neuroshare
library on the Linux platform and internally passes library calls on to one of
the vendor libraries. This nswineproxy_ can be used as a drop-in replacement
for any Neuroshare library and therefore allows for access to all
Neuroshare-compliant modules. While this solution admittedly lacks the
performance of a native implementation, it still makes a huge difference to be
able to access a particular data format at all, and is perfectly suitable for
one-time data conversion -- for example into the open HDF5 data format.

In addition to the Wine-proxy, G-Node also provides `python-neuroshare`_,
a Python package to access any Neuroshare-library.


Comprehensive data description and sharing
------------------------------------------

Plain data access is not sufficient for collaborative work and data sharing.
In addition, it requires a comprehensive description of data, including
information on data origin, acquisition parameters, and applied processing.
G-Node offers several software packages that offer important functionality in
this regard. ODML_ is a markup language to create comprehensive meta
information for a particular dataset (Python and Java bindings are provided).
datajongleur_ is a Python package to create data views that combine plain data
with meta information, such as physical quantities, or more detailed meta data.
It allows injecting these enriched datasets in SQL databases for efficient
storage, querying, and retrieval. Finally, G-Node also develops a server-side
database solution that aids multi-site data-sharing efforts. Clients for
various environments, such as Matlab and Python are either being developed or
are already available.


Real-time data analysis
-----------------------

The third topic for software development at G-Node are closed-loop real-time
systems for online stimulus creation, data acquisition, and data analysis, such
as Relacs_. The upcoming Debian release (wheezy) will offer a Linux kernel with
real-time capabilities which should make it easier to offer out-of-the-box
solution for this type of research.

If you are interested in any of these software packages and would like to see
them integrated into the Debian system quickly, please do not hesitate to
:ref:`contact us <support>`, so we can coordinate the effort.

.. _Thomas Wachtler: http://neuro.bio.lmu.de/research_groups/res-wachtler_th/index.html
.. _INCF: http://www.incf.org/
.. _G-Node: http://www.g-node.org/

.. _Neuroshare: http://neuroshare.sourceforge.net
.. _nswineproxy: http://github.com/G-Node/nswineproxy
.. _python-neuroshare: http://github.com/G-Node/python-neuroshare
.. _ODML: http://www.g-node.org/projects/odml

.. _datajongleur: http://github.com/G-Node/Datajongleur
.. _Relacs: http://relacs.sourceforge.net/


