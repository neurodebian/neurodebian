{% for dist, mirrors in repos|dictsort %}
* {{ dist }}: {% for mirror, list in mirrors|sort %}[`{{ mirror }} <_static/{{ list }}>`__] {% endfor %}
{% endfor %}

