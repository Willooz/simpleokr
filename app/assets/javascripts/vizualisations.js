var data = []
d3.selectAll(".score input")
  .each(function() {
    data.push(this.text);
  });

console.log(data);

var margin = {top: 10, right: 10, bottom: 10, left: 10},
    width = 200 - margin.left - margin.right,
    sliderBoxHeight = 40,
    height = data.length * sliderBoxHeight,
    radius = 10,
    sliderHeight = 6,
    sliderRadius = sliderHeight / 2;

var x = d3.scale.linear()
    .domain([0, 1])
    .range([0, width])
    .clamp(true);

var hue = d3.scale.linear()
    .domain([0, 1])
    .range([0, 125])
    .clamp(true);

var sliderBox = d3.selectAll(".canvas")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom);

var sliderBox = svg.selectAll("g")
    .data(data)
  .enter().append("g")
    .attr("transform", function(d, i) { return "translate(" + margin.left + "," + i * sliderBoxHeight + ")" });
    // .each(function(d, i) { d.index = i; });

sliderBox.append("rect")
    .attr("y", sliderBoxHeight - 20 )
    .attr("width", width )
    .attr("height", sliderHeight )
    .attr("rx", sliderRadius )
    .attr("ry", sliderRadius )
    .attr("fill", "lightgrey" );

sliderBox.append("rect")
    .attr("y", sliderBoxHeight - 20 )
    .attr("width", function(d) { return x(d) } )
    .attr("height", sliderHeight )
    .attr("rx", sliderRadius )
    .attr("ry", sliderRadius )
    .attr("fill", function(d) { return d3.hsl(hue(d), .8, .8) } )
    .attr("id", "colored");

sliderBox.append("text")
    .attr("y", sliderBoxHeight - 50 )
    .attr("dy", "1em")
    .text(function(d) { return d3.round(d, 1) });

var handle = sliderBox.append("circle")
    .attr("r", radius)
    .attr("cx", function(d) { return x(d) } )
    .attr("cy", sliderBoxHeight - 20 )
    .attr("fill", "white" );

var brush = d3.svg.brush()
  .x(x)
  .extent([0, 1])
  .on("brush", brushed);

handle
    .call(brush);

function brushed() {
  var sliderPosition = x.invert(d3.mouse(this)[0]);
  var sliderColor = hue(sliderPosition);
  brush.extent([sliderPosition, sliderPosition]);

  d3.select(this)
    .attr("cx", x(sliderPosition));

  d3.select(this.parentNode).select("#colored")
    .attr("width", x(sliderPosition))
    .attr("fill", d3.hsl(sliderColor, .8, .8));

  d3.select(this.parentNode).select("text")
    .text(d3.round(sliderPosition, 1));

  // var i = d3.select(this.parentNode).data().index;
  //   .update(function(d, i) { d[i] = sliderPosition } );// var index = d3.select(this.parentNode).datum();

  // value = d3.round(sliderPosition, 1);
  // console.log(index);
  // console.log(data[1]);
  // d3.select(this.parentNode)
  // data[i] = d3.round(sliderPosition, 1);
  console.log(data);

}