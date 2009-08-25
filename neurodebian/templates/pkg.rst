
.. _pkg_{{ pkg }}:


{{ title }}

{{ long_description | wordwrap(width=79, break_long_words=False) }}

Homepage: {{ db.main.homepage }}

{% if db.blends %}
Associated `Debian Pure Blends <http://wiki.debian.org/DebianPureBlends>`_:
{% for blend, name, url in db.blends.tasks %}
* `{{ name }} ({{ blend }}) <{{ url }}>`_
{% endfor %}
{% endif %}

{% if db.main.debian_popcon or db.main.ubuntu_popcon %}
Number of reported installations [#]_:
{% if db.main.debian_popcon %}
- Debian: {{ db.main.debian_popcon.insts }} (`more info <http://qa.debian.org/popcon.php?package={{ pkg }}>`_)
{% endif %}
{% if db.main.ubuntu_popcon %}
- Ubuntu: {{ db.main.ubuntu_popcon.insts }}
{% endif %}

.. [#] Due to the nature of this data, the reported number can only be
       considered a conservative estimate of the lower bound of the true
       number of installations.

{% endif %}



Binary packages
===============

NeuroDebian
-----------

{% for dist, distpkg in db|dictsort if dist[1].startswith('neurodebian') %}
{% if loop.first %}
The repository contains binary packages for the following distribution
releases and system architectures. The corresponding source packages
are available too.

.. note::
  Do not download this package manually if you plan to use it
  regularly. Instead configure your package manager to use this
  repository by following the instructions on the
  :ref:`front page <repository_howto>`.

{% endif %}
{{ dist[0] }} [{{ distpkg.component}}]:
  `{{distpkg.version}} <../../debian/{{ distpkg.poolurl }}>`_ [{{ ', '.join(distpkg.architecture) }}]

{% if loop.last %}
.. seealso::

  - Maintainer: {{ distpkg.maintainer }}
{% endif %}
{% else %}
*There are no packages in the NeuroDebian repository.*
{% endfor %}


Debian
------

{% for dist, distpkg in db|dictsort if dist[1].startswith('debian') %}
{% if loop.first %}
{% endif %}
{{ dist[0] }} [{{ distpkg.component}}]:
  `{{distpkg.version}} <http://packages.debian.org/search?suite={{ distpkg.release}}&keywords={{ pkg }}>`_ [{{ ', '.join(distpkg.architecture) }}]

{% if loop.last %}
.. seealso::

  - Maintainer: {{ distpkg.maintainer }}
  - Bug reports: `Debian bugtracking system <http://bugs.debian.org/src:{{ distpkg.source }}>`_
{% endif %}
{% else %}
*There are no official Debian packages available.*

{% if db.main.debian_itp %}
However, a Debian packaging effort has been officially announced.
Please see the corresponding
`intent-to-package bug report <http://bugs.debian.org/{{ db.main.debian_itp }}>`_
for more information about its current status.
{% endif %}
{% endfor %}


Ubuntu
------

{% for dist, distpkg in db|dictsort if dist[1].startswith('ubuntu') %}
{% if loop.first %}
{% endif %}
{{ dist[0] }} [{{ distpkg.component }}]:
  `{{distpkg.version}} <http://packages.ubuntu.com/search?suite={{ distpkg.release }}&keywords={{ pkg }}>`_ [{{ ', '.join(distpkg.architecture) }}]

{% if loop.last %}
.. seealso::

  - Maintainer: {{ distpkg.maintainer }}
  - Bug reports: `Ubuntu Launchpad <https://bugs.launchpad.net/ubuntu/+source/{{ distpkg.source }}>`_
{% endif %}
{% else %}
*There are no official Ubuntu packages available.*
{% endfor %}
