d3.json('/_files/nd_subscriptionstats.json', function(data) {

  // yoh: can't find a sane way to use ordinal scale here
  // so let's create linear scale for indices within known releases

  // collect debian and ubuntu releases we are dealing with to create
  // proper color scales
  // Will be Ubuntu for true
  var releases = {false:[], true:[]}

  data.forEach(function(d, i) {
  	  releases[d.key.indexOf("Ubuntu") > -1].push(d.key)
  })

 var colors = {false: d3.scale.linear()
       	               .domain([0, releases[false].length]).range(["white", "#dd1155"]),
                true:  d3.scale.linear()
                       .domain([0, releases[true].length]).range(["white", "#dd4814"])}

  releaseKeyColor = function(d, i) {
	var isubuntu = d.key.indexOf("Ubuntu") > -1
    return colors[isubuntu](releases[isubuntu].indexOf(d.key)+1)
  }

  nv.addGraph(function() {
    chart = nv.models.stackedAreaChart()
                  .x(function(d) { return d[0] })
                  .y(function(d) { return d[1] })
                  .color(releaseKeyColor)
                  .clipEdge(true);

    chart.stacked.style('stacked');

    chart.xAxis
        .tickFormat(function(d) {
            return d3.time.format('%d %b %Y')(new Date(d)) });

    chart.yAxis
        .tickFormat(d3.format(',.2f'));

    d3.select('#subscriptionchart')
      .datum(data)
        .transition().duration(500).call(chart);

    nv.utils.windowResize(chart.update);

    return chart;
  });
})
