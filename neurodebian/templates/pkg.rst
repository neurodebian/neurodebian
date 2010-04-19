
.. _pkg_{{ pkg }}:


{{ title }}

{{ long_description }}

External links:

.. raw:: html

  <p><a href="{{ db.main.homepage }}">
  <img src="../_static/go-home.png" title="Go to {{ pkg }} homepage" /></a>
  {%- if cfg.has_option("nitrc ids", pkg) -%}
  <a href="http://www.nitrc.org/project?group_id={{ cfg.get("nitrc ids", pkg) }}">
  <img src="../_static/nitrc.jpg" title="See the entry on nitrc.org" /></a>
  {%- endif -%}
  </p>

{% if db.main.publication %}
Citable reference:
  *{{ db.main.publication.authors }}* ({{ db.main.publication.year }}).
  {%- if db.main.publication.url %} `{{ db.main.publication.title }} <{{ db.main.publication.url }}>`_.
  {%- else %} {{ db.main.publication.title }}.
  {%- endif %} {{ db.main.publication.in }}.
  {%- if db.main.publication.doi %} (`DOI <http://dx.doi.org/{{ db.main.publication.doi }}>`_)
  {%- endif %}
{% endif %}

{% if db.main.registration -%}
.. note::
  The software authors ask users to
  `register <{{ db.main.registration }}>`_. Available user statistics might be 
  helpful to acquire funding for this project and therefore foster continued
  developement in the future.
{% endif -%}

{% if db.blends or db.main.debian_popcon or db.main.ubuntu_popcon or
      db.main.recommends or db.main.suggests -%}
Package Details
===============
{% if db.blends %}
`Debian Pure Blends <http://wiki.debian.org/DebianPureBlends>`_ Status
----------------------------------------------------------------------
Associated blends:

{% for blend, name, url in db.blends.tasks %}
* `{{ name }} ({{ blend }}) <{{ url }}>`_
{% endfor %}
{% if db.blends.remark %}
.. note::
{{ db.blends.remark | indent(width=2, indentfirst=true) }}
{% endif -%}
{% endif -%}

{% if db.main.debian_popcon or db.main.ubuntu_popcon %}
Popularity statistics [#]_
--------------------------
{% if db.main.debian_popcon -%}
- Debian: {{ db.main.debian_popcon.insts }} (`more info <http://qa.debian.org/popcon.php?package={{ db.main.sv.split()[0] }}>`_)
{% endif -%}
{% if db.main.ubuntu_popcon -%}
- Ubuntu: {{ db.main.ubuntu_popcon.insts }}
{% endif %}

.. [#] Due to the nature of this data, the reported number can only be
       considered a conservative estimate of the lower bound of the true
       number of installations.
{% endif -%}
{% endif -%}

{% if db.main.recommends or db.main.suggests %}
Related packages
----------------
{% if db.main.recommends %}
{%- for pkg in db.main.recommends.split(',') %}
{%- if pkg.split('|')[0].strip() in fulldb %}
* :ref:`pkg_{{ pkg.strip() }}`
{%- else %}
* {{ pkg }}
{% endif -%}{% endfor %}{% endif %}
{%- if db.main.suggests %}
{%- for pkg in db.main.suggests.split(',') %}
{%- if pkg.split('|')[0].strip() in fulldb %}
* :ref:`pkg_{{ pkg.strip() }}`
{%- else %}
* {{ pkg.strip() }}
{% endif -%}{% endfor %}{% endif %}
{% endif %}

Binary packages
===============

NeuroDebian
-----------

{% for dist, distpkg in db|dictsort if dist[1].startswith('neurodebian') -%}
{% if loop.first -%}
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

  - Original Maintainer: {{ distpkg.maintainer }}

    (if there is any chance that some problem is specific to the package
    distributed through the NeuroDebian repository, please contact
    pkg-exppsy-maintainers@lists.alioth.debian.org instead of the original
    maintainer)
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
