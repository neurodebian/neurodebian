
.. _binary_pkg_{{ pname }}:

{{ pname }}
{% for c in pname %}*{%- endfor %}

.. raw:: html

  <div class="row">
  <div class="col-md-12">
  <p class="lead">{{ short_description }}</p>
  </div> <!-- /div .col-md-12 -->
  </div> <!-- /div .row -->

  <div class="row">
  <div class="col-md-12">
  <div class="btn-group" role="group" aria-label="package actions">
  <a role="button"
     class="btn btn-primary"
     title="Click to get installation instructions"
     href="/install_pkg.html?p={{ pname | e }}">
  Install package</a>

{% if havemeta_README_Debian %}

.. raw:: html

  <a role="button"
         class="btn btn-warning"
         href="{{ cfg.get('metadata', 'source extracts baseurl') | e }}/{{ src_name | e }}/README.Debian"
         title="Get essential user information for this package">Read this!</a>

{% endif -%}

.. raw:: html

  <a role="button"
     class="btn btn-default"
     title="Click for information on bug reporting"
     href="/reportbug.html?p={{ pname | e }}&src={{ src_name | e }}
     {%- if havemeta_README_Debian -%}
     &have_readme=1
     {%- endif -%}
     {%- if homepage -%}
     &homepage={{ homepage | e }}
     {%- endif -%}
     {%- if 'Contact' in upstream -%}
     &contact={{ upstream.Contact | e }}
     {%- endif -%}
     {%- if 'FAQ' in upstream -%}
     &faq={{ upstream.FAQ | e }}
     {%- endif -%}
     {%- if in_base_release|length -%}
     &in_debian_proper=1
     {%- endif -%}
     ">
  Help</a>

{% if component == 'non-free' -%}
.. raw:: html

  <a role="button"
         class="btn btn-danger"
         href="{{ cfg.get('metadata', 'source extracts baseurl') | e }}/{{ src_name | e }}/copyright"
         title="Non-standard licencing terms, verify compliance!">Check licence</a>

{% elif component == 'contrib' -%}

.. raw:: html

  <a role="button"
         class="btn btn-danger"
         href="{{ cfg.get('metadata', 'source extracts baseurl') | e }}/{{ src_name | e }}/copyright"
         title="Package dependencies have non-standard licensing terms, verify compliance!">
         Check license</a>

{% else %}

.. raw:: html

  <a role="button"
         class="btn btn-default"
         href="{{ cfg.get('metadata', 'source extracts baseurl') | e }}/{{ src_name | e }}/copyright"
         title="Check license">
         Check license</a>

{% endif %}

.. raw:: html

  </div> <!-- /div .btn-group -->
  </div> <!-- /div .col-md-12 -->
  </div> <!-- /div .row -->

  <hr />

  <div class="row">
  <div class="col-md-12">

{{ description }}

.. raw:: html

  <p>
  <div class="btn-group" role="group" aria-label="...">

  {% if homepage %}
  <a role="button" class="btn btn-default" href="{{ homepage }}">
  Visit project</a>
  {% endif -%}

  {% if 'Contact' in upstream %}
  <a role="button" class="btn btn-default" href="{{ upstream.Contact }}">
  Contact authors</a>
  {% endif -%}

  {% if 'FAQ' in upstream %}
  <a role="button" class="btn btn-default" href="{{ upstream.FAQ }}">
  See FAQ</a>
  {% endif -%}

  </div> <!-- /div .btn-group -->
  </p>

{% for bin in binary|sort if not bin == pname %}
{%- if loop.first %}
Related packages:
:ref:`{{ bin }} <binary_pkg_{{ bin }}>`
{%- else -%}
, :ref:`{{ bin }} <binary_pkg_{{ bin }}>`
{%- endif %}
{%- endfor %}

.. raw:: html

  <hr />

{% if 'Registration' in upstream -%}
.. raw:: html

  <div class="panel panel-danger">
  <div class="panel-heading">User registration</div>
  <div class="panel-body">

{% if upstream.Registration.startswith('http') -%}
The software authors ask users to `register <{{ upstream.Registration }}>`_.
Available user statistics may be helpful to acquire funding for this project
and therefore foster continued development in the future.
{%- else -%}
{{ upstream.Registration }}
{% endif %}

.. raw:: html

  </div> <!-- /.panel-body -->
  </div> <!-- /.panel -->
{% endif %}

{% if 'Donation' in upstream -%}
.. raw:: html

  <div class="panel panel-danger">
  <div class="panel-heading">Donations to the project</div>
  <div class="panel-body">

{% if upstream.Donation.startswith('http') -%}
For information on how to donate to this project, please visit
`this page <{{ upstream.Donation }}>`_.
{%- else -%}
{{ upstream.Donation }}
{% endif %}

.. raw:: html

  </div> <!-- /.panel-body -->
  </div> <!-- /.panel -->

{% endif %}


{% if 'Cite-As' in upstream or 'Reference' in upstream or 'Also-Known-As' in upstream %}
.. raw:: html

  <div class="panel panel-info">
  <div class="panel-heading">
  Additional information
  {% if upstream and 'Also-Known-As' in upstream %}
  <div class="btn-group pull-right" role="group" aria-label="...">
  {% if upstream['Also-Known-As'].NeuroLex %}
  <a role="button" class="btn btn-default btn-xs"
     href="http://uri.neuinfo.org/nif/nifstd/{{ upstream['Also-Known-As'].NeuroLex }}">
  NeuroLex</a>
  {% endif -%}
  {% if upstream['Also-Known-As'].NITRC %}
  <a role="button" class="btn btn-default btn-xs"
     href="http://www.nitrc.org/project?group_id={{ upstream['Also-Known-As'].NITRC }}">
  NITRC</a>
  {% endif -%}
  </div> <!-- /div .btn-group -->
  {% endif %}
  </div>
  <div class="panel-body">

{% if 'Cite-As' in upstream -%}
{{ upstream.Cite-As }}
{% endif -%}

{% if 'Reference' in upstream or Other-References in upstream -%}
  .. raw:: html

  <ul class="list-unstyled">
  {%- for ref in upstream.Reference %}
    <li>
    {{ ', '.join(ref.Author.split(' and ')) }} ({{ ref.Year }}).
    <strong>{{ ref.Title }}</strong>. <em>
    {%- if ref.Journal %} {{ ref.Journal }}{% endif %}
    {%- if ref.Volume %}, {{ ref.Volume }}{% endif %}</em>
    {%- if ref.Pages %}, {{ ref.Pages }}{% endif %}.

    {%- if ref.URL %}
      <a role="button" class="btn btn-default btn-xs"
         href="{{ ref.URL }}" title="Access publication">
         URL</a>
    {% endif %}
    {%- if ref.Eprint %}
      <a role="button" class="btn btn-default btn-xs"
         href="{{ ref.Eprint }}" title="Access publication">
         Eprint</a>
    {% endif %}
    {%- if ref.DOI %}
      <a role="button" class="btn btn-default btn-xs"
         href="http://dx.doi.org/{{ ref.DOI }}" title="Access publication">
         DOI</a>
    {% endif %}
    {%- if ref.PMID %}
      <a role="button" class="btn btn-default btn-xs"
         href="http://www.ncbi.nlm.nih.gov/pubmed/{{ ref.PMID }}" title="Access publication">
         PubMed</a>
    {% endif %}
    </li>
  {% endfor -%}

  {% if 'Other-References' in upstream %}
    <li><a href="{{ upstream['Other-References'] }}">Additional references &raquo;</a></li>
  {% endif -%}
  </ul>
{% endif -%}

.. raw:: html

  </div> <!-- /.panel-body -->
  </div> <!-- /.panel -->

{% endif -%}

.. raw:: html

  </div> <!-- /div .col-md-12 -->
  </div> <!-- /div .row -->

  <div class="row">
  <div class="col-md-12">
  </div> <!-- /div .col-md-12 -->
  </div> <!-- /div .row -->

Maintainer information
----------------------

This software package is maintained for (Neuro)Debian by the follow individuals and/or groups:

.. raw:: html

   <div class="row">
    <div class="col-sm-6 col-md-4">
   {% for m in maintainers %}
     <div class="thumbnail pull-left">
      <img alt="Maintainer avatar" src="http://www.gravatar.com/avatar/{{ m[2][0] }}?s=100&r=g&d=mm" />
      <div class="caption">{{ m[0] }}</div>
    </div>
   {%- endfor %}
    </div>
   </div>

In order to get support, or to get in touch with a maintainer, please click the
'Help' button at the top of the page.

Advanced user information
-------------------------

{% if vcs_browser %}
.. raw:: html

  <p>Version control system available:
  <a role="button" class="btn btn-default btn-sm" href="{{ vcs_browser }}">
  Browse sources</a></p>
{% endif %}

.. list-table:: Package availability chart
   :header-rows: 1
   :stub-columns: 1
   :widths: 40 20 20 20

   * - Distribution
     - Base version
     - Our version
     - Architectures
  {%- for release in availability|dictsort %}
  {%- for version in release[1] %}
  {%- if loop.first %}
   * - {{ release[0] }}
  {%- else %}
   * -
  {%- endif %}
     - {{ version[0] }}
     - {{ version[1] }}
     - {{ ', '.join(version[2]) }}
  {%- endfor %}
  {%- endfor %}
