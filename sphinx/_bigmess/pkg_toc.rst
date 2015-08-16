.. _{{ label }}:

{{ title }}
{{ '=' * (title|count) }}

{% if '<' in title %}
.. raw:: html

   <p><img alt="Maintainer avatar" src="http://www.gravatar.com/avatar/{{ emailhash }}?s=100&r=g&d=mm" /></p>
{% endif %}

.. raw:: html

  <table class="table table-responsive table-hover table-condensed">
  <thead>
  <tr>
  <th title="Source package name">Source</th>
  <th title="Binary package name">Binary</th>
  <th title="Package description and info links">Description</th>
  </tr>
  </thead>
  <tbody>
  {% for srcpkg in pkgs|sort %}
  <tr class="info"><td colspan="2">{{ srcpkg }}</td>
  <td><span class="pull-right">
  {%- if 'homepage' in srcdb[srcpkg] -%}
  <a href="{{ srcdb[srcpkg].homepage }}" title="Visit project website"><span class="glyphicon glyphicon-home"></span></a>
  {%- endif %}
  {%- if srcdb[srcpkg].component == 'non-free' -%}
  {%- if srcdb[srcpkg].havemeta_copyright -%}
  <a href="{{ cfg.get('metadata', 'source extracts baseurl') }}/{{ srcpkg }}/copyright">
  <span title="Non-standard licence terms: verify compliance!" class="warning glyphicon glyphicon-exclamation-sign"></span></a>
  {%- else -%}
  <span title="Non-standard licence terms: verify compliance!" class="warning glyphicon glyphicon-exclamation-sign"></span>
  {%- endif %}
  {%- endif %}
  {% if 'sid' in srcdb[srcpkg].in_base_release -%}
  <a href="https://bugs.debian.org/src:{{ srcpkg }}" title="See reported issues in the Debian bug tracker"><span class="glyphicon glyphicon-fire"></span></a>
  <a title="See popularity statistics for the Debian operating system"
     href="https://qa.debian.org/popcon-graph.php?show_installed=on&want_legend=on&from_date=&beenhere=1&packages={{ srcdb[srcpkg].binary | join('+') }}"><span class="glyphicon glyphicon-stats"></span></a>
  {%- endif %}
  </span></td>
  </tr>
  {% for binpkg in srcdb[srcpkg].binary|sort %}
  {%- if not 'transitional dummy package' in bindb[binpkg].short_description -%}
  <tr>
  <td>
  </td>
  <td><a href="../pkgs/{{ binpkg }}.html">{{ binpkg }}</a></td>
  <td>{{ bindb[binpkg].short_description }}</td>
  </tr>
  {%- endif -%}
  {% endfor %}
  {% endfor %}
  </tbody>
  </table>

