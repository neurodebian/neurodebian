.. _full_pkg_list:

Package list
============

.. toctree::
  :maxdepth: 1
{% for p in pkgs|sort %}
  pkgs/{{ p }}.rst
{%- endfor %}

