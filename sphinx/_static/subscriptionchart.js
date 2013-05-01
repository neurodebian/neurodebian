d3.json('/_files/nd_subscriptionstats.json', function(data) {
  nv.addGraph(function() {
    chart = nv.models.stackedAreaChart()
                  .x(function(d) { return d[0] })
                  .y(function(d) { return d[1] })
                  .clipEdge(true);

    chart.stacked.style('expand');

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
