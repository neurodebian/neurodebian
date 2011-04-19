.. raw:: html

 <select id="release" name="release">
   <option value="">Select a release</option>
{%- for id, relname in id2relname|dictsort(true, 'value') %}
   <option value="{{ id }}">{{ relname }}</option>
{%- endfor %}
 </select>
 <select id="mirror" name="mirror">
{%- for id, mirrorname in mirror2name|dictsort %}
{%- if id == 'us-nh' %}
   <option selected value="{{ id }}">{{ mirrorname }}</option>
{%- else %}
   <option value="{{ id }}">{{ mirrorname }}</option>
{%- endif %}
{%- endfor %}
 </select>

 <div class="highlight-python" id="reposetup">
 <pre id="code">
 After selecting a release the setup code will be shown here.
 </pre>
 </div>
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

  function createrepourl(rel, mir) {
    if(rel in rel2name && mir in mirrors) {

        var retrepo = "wget -O- http://neuro.debian.net/lists/" + rel2name[rel] + "."
         + mir + " | sudo tee /etc/apt/sources.list.d/neurodebian.sources.list\n"
         + "sudo apt-key adv --recv-keys --keyserver pgp.mit.edu 2649A5A9\n";
        return retrepo;
    }

  };
  function updateout(rel, mir) {
        $('#code').text(createrepourl(rel, mir));
  };
   $('#release').change(function() {
     var singleValues = $("#release").val();
     var mirrorVal = $("#mirror").val();
     updateout(singleValues, mirrorVal);
   });
   $('#mirror').change(function() {
     var singleValues = $("#release").val();
     var mirrorVal = $("#mirror").val();
     updateout(singleValues, mirrorVal);
   });

 //-->
 </script>

