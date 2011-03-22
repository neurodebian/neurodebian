.. _{{ label }}:

{{ title }}

{% for p in pkgs|sort %}
* :ref:`{{ p }} <pkg_{{ p }}>` ({{ db[p].main.description }})
{%- endfor %}

