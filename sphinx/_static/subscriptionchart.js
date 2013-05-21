d3.json('/_files/nd_subscriptionstats.json', function(data) {

  // collect debian and ubuntu releases we are dealing with to create
  // proper color scales
  var debian_releases = new Array()
  var ubuntu_releases = new Array()

	data.forEach(function(d, i) {
  	if (d.key.indexOf("Ubuntu") > -1)
          ubuntu_releases.push(d.key)
      else
          debian_releases.push(d.key);
  })

  // yoh: can't find a sane way to use ordinal scale here
  // so let's create linear scale for indices within known releases
  var colors_debian = d3.scale.linear()
	.domain([0, debian_releases.length]).range(["white", "#dd1155"])
  var colors_ubuntu = d3.scale.linear()
	.domain([0, ubuntu_releases.length]).range(["white", "#dd4814"])

  releaseKeyColor = function(d, i) {
	if (d.key.indexOf("Ubuntu") > -1)
		return colors_ubuntu(ubuntu_releases.indexOf(d.key)+1)
	else
		return colors_debian(debian_releases.indexOf(d.key)+1);
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
