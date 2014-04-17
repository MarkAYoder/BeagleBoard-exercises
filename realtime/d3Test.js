var data = d3.range(0, 2 * Math.PI, .01).map(function(t) {
  return [t, Math.cos(2 * t)];
});
var data2 = d3.range(0, 2 * Math.PI, .01).map(function(t) {
  return [t, Math.cos(3 * t)];
});

var width  = 400,
    height = 400,
    radius = Math.min(width, height) / 2 - 30;

var r = d3.scale.linear()
    .domain([0, 1.0])
    .range([0, radius]);

var line = d3.svg.line.radial()
    .radius(function(d) { return r(d[1]); })
    .angle (function(d) { return -d[0] + Math.PI / 2; });

var svg = d3.select("body").append("svg")
    .attr("width", width)
    .attr("height", height)
  .append("g")
    .attr("transform", "translate(" + ((width/2)+10) + "," + height/2 + ")");

var gr = svg.append("g")
    .attr("class", "r axis")
  .selectAll("g")
    .data(r.ticks(5).slice(1))
  .enter().append("g");

gr.append("circle")
    .attr("r", r);

gr.append("text")
    .attr("y", function(d) { return -r(d) - 4; })
    .attr("transform", "rotate(15)")
    .style("text-anchor", "middle")
    .text(function(d) { return d; });

var ga = svg.append("g")
    .attr("class", "a axis")
  .selectAll("g")
    .data(d3.range(0, 360, 30))
  .enter().append("g")
    .attr("transform", function(d) { return "rotate(" + -d + ")"; });

ga.append("line")
    .attr("x2", radius);

ga.append("text")
    .attr("x", radius + 6)
    .attr("dy", ".35em")
    .style("text-anchor", function(d) { return d < 270 && d > 90 ? "end" : null; })
    .attr("transform", function(d) { return d < 270 && d > 90 ? "rotate(180 " + (radius + 6) + ",0)" : null; })
    .text(function(d) { return d + "°"; });

svg.append("path")
    .datum(data)
    .attr("class", "line")
    .attr("d", line);

data2[1] = [1, 1];    
svg.selectAll("path")
    .datum(data2)
    .attr("class", "line2")
    .attr("d", line);

console.log(data2[1]);