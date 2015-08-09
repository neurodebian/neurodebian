.. raw:: html

 <div class="form-group">
 <div class="input-group">
 <span class="input-group-addon" id="basic-addon-os">I am running</span>
 <select id="release" name="release" class="form-control" aria-describedby="basic-addon-os" data-toggle="tooltip" title="Which operating system is runnning on the machine you want to use NeuroDebian on?">
   <option selected value="">Select your operating system</option>
   <option value="win32">MS Windows (32bit)</option>
   <option value="win64">MS Windows (64bit)</option>
   <option value="mac">Mac OS X</option>
{%- for code, relname in code2name|dictsort(true, 'value') %}
   <option value="{{ code }}">{{ relname }}</option>
{%- endfor %}
 </select>
 </div> <!-- /.input-group -->
{% if mirror2url|count %}
 <div id="mirror-input-group" class="input-group">
 <span class="input-group-addon" id="basic-addon-download">I want to download from</span>
 <select id="mirror" name="mirror" class="form-control" aria-describedby="basic-addon-download" title="Choose a fast mirror, but it's OK to keep the default.">
   <option selected value="us-nh">Main repository (or select something closer to you)</option>
{%- for id, mirrorname in mirror2name|dictsort %}
   <option value="{{ id }}">{{ mirrorname }}</option>
{%- endfor %}
 </select>
 </div> <!-- /.input-group -->
 </div> <!-- /.form-group -->

 <script>
 <!--
 
  var mirrors =  {
{%- for id, url in mirror2url|dictsort %}
   "{{ id }}" : "{{ url }}",
{%- endfor %}
  };

 //-->
 </script>
{% endif -%}
