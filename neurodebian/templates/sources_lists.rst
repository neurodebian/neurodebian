.. raw:: html

 <select id="release" name="release">
   <option selected value="">Select your operating system</option>
   <option value="win32">MS Windows (32bit)</option>
   <option value="win64">MS Windows (64bit)</option>
   <option value="mac">Mac OS X</option>
{%- for id, relname in id2relname|dictsort(true, 'value') %}
   <option value="{{ id }}">{{ relname }}</option>
{%- endfor %}
 </select>
 <select id="mirror" name="mirror">
   <option selected value="">Select a download server</option>
{%- for id, mirrorname in mirror2name|dictsort %}
   <option value="{{ id }}">{{ mirrorname }}</option>
{%- endfor %}
 </select>

 <script>
 <!--
 
  var rel2name =  {
{%- for id, codename in id2codename|dictsort %}
   "{{ id }}" : "{{ codename }}",
{%- endfor %}
  };

  var mirrors =  {
{%- for id, url in mirror2url|dictsort %}
   "{{ id }}" : "{{ url }}",
{%- endfor %}
  };

 //-->
 </script>
