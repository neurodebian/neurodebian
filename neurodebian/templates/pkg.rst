
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

Binary packages
===============

{% for dist, distpkg in db|dictsort if dist[1].startswith('neurodebian') %}
{% if loop.first %}
NeuroDebian
-----------

{% endif %}
{{ dist[0] }} [{{ distpkg.drc.split()[2]}}]:
  `{{distpkg.version}} <../../debian/{{ distpkg.poolurl }}>`_ [{{ ', '.join(distpkg.architecture) }}]

{% if loop.last %}
.. seealso::

  - Maintainer: {{ distpkg.maintainer }}
{% endif %}
{% else %}
*There are no packages in the NeuroDebian repository.*
{% endfor %}


{% for dist, distpkg in db|dictsort if dist[1].startswith('debian') %}
{% if loop.first %}
Debian
------

{% endif %}
{{ dist[0] }} [{{ distpkg.drc.split()[2]}}]:
  `{{distpkg.version}} <http://packages.debian.org/search?suite={{ distpkg.drc.split()[1]}}&keywords={{ pkg }}>`_ [{{ ', '.join(distpkg.architecture) }}]

{% if loop.last %}
.. seealso::

  - Maintainer: {{ distpkg.maintainer }}
  - Bug reports: `Debian bugtracking system <http://bugs.debian.org/src:{{ distpkg.sv.split()[0] }}>`_
{% if distpkg.popcon %}
  - Reported installations: {{ distpkg.popcon.insts }}
{% endif %}
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


{% for dist, distpkg in db.iteritems() if dist[1].startswith('ubuntu') %}
{% if loop.first %}
Ubuntu
------

{% endif %}
{{ dist[0] }} [{{ distpkg.drc.split()[2]}}]:
  `{{distpkg.version}} <http://packages.ubuntu.com/search?suite={{ distpkg.drc.split()[1]}}&keywords={{ pkg }}>`_ [{{ ', '.join(distpkg.architecture) }}]

{% if loop.last %}
.. seealso::

  - Maintainer: {{ distpkg.maintainer }}
  - Bug reports: `Ubuntu Launchpad <https://bugs.launchpad.net/ubuntu/+source/{{ distpkg.sv.split()[0] }}>`_
{% if distpkg.popcon %}
  - Reported installations: {{ distpkg.popcon.insts }}
{% endif %}
{% endif %}
{% else %}
*There are no official Ubuntu packages available.*
{% endfor %}
