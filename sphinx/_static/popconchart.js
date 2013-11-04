var colors_debian = d3.scale.linear()
	.domain([1.43, 1.60]).range(["white", "#dd1155"])
var colors_ubuntu = d3.scale.linear()
	.domain([1.43, 1.60]).range(["white", "#dd4814"])

keyColor = function(d, i) {
	var version = parseFloat(d.key.substr(0, 4))
	if (d.key.indexOf("ubuntu") > 0)
		return colors_ubuntu(version)
	else
		return colors_debian(version);
}

d3.json('/_files/nd_popconstats.json', function(data) {
  nv.addGraph(function() {
    chart = nv.models.stackedAreaChart()
                  .x(function(d) { return d[0] })
                  .y(function(d) { return d[1] })
                  .color(keyColor)
                  .clipEdge(true);

    chart.stacked.style('stacked');

    chart.xAxis
        .tickFormat(function(d) {
            return d3.time.format('%d %b %Y')(new Date(d)) });

    chart.yAxis
        .tickFormat(d3.format(',d'));

    d3.select('#popconchart')
      .datum(data)
        .transition().duration(500).call(chart);

    nv.utils.windowResize(chart.update);

    return chart;
  });
})
