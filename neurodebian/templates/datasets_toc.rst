.. _full_dataset_list:

Dataset packages
================

.. toctree::
  :maxdepth: 1
{% for p in pkgs|sort %}
  pkgs/{{ p }}.rst
{%- endfor %}

