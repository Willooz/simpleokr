$(document).ready(function() {

  var data = []

  d3.selectAll(".score input")
    .each(function() {
      var input = d3.select(this).attr("value");
      data.push(input);
    });

  // console.log(data);

  var margin = {top: 0, right: 10, bottom: 0, left: 10},
      width = 200 - margin.left - margin.right,
      height = 40,
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

  var svg = d3.selectAll(".canvas")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g");

  var slider = d3.selectAll("g")
      .data(data);

  slider.append("rect")
      .attr("y", height - 20 )
      .attr("width", width )
      .attr("height", sliderHeight )
      .attr("rx", sliderRadius )
      .attr("ry", sliderRadius )
      .attr("fill", "lightgrey" );

  slider.append("rect")
      .attr("y", height - 20 )
      .attr("width", function(d) { return x(d) } )
      .attr("height", sliderHeight )
      .attr("rx", sliderRadius )
      .attr("ry", sliderRadius )
      .attr("fill", function(d) { return d3.hsl(hue(d), .8, .8) } )
      .attr("id", "colored");

  slider.append("text")
      .attr("y", height - 50 )
      .attr("dy", "1em")
      .text(function(d) { return d3.round(d, 1) });

  var handle = slider.append("circle")
      .attr("r", radius)
      .attr("cx", function(d) { return x(d) } )
      .attr("cy", height - 20 )
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

    // PUT CHANGED DATA BACK INTO THE INPUT
    console.log(data);

  }

});