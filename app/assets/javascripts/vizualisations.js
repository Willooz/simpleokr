$(document).ready(function() {

  var data = []

  d3.selectAll(".score input")
    .each(function() {
      var input = d3.select(this).attr("value");
      data.push(input);
    });

  // console.log(data);

  var width = 135,
      height = 30,
      radius = 10,
      sliderHeight = 4,
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
      .attr("width", 200)
      .attr("height", height)
      .append("g");

  var slider = d3.selectAll("g")
      .data(data)
      .attr("transform", "translate(50,0)");

  slider.append("rect")
      .attr("y", 10 )
      .attr("width", width )
      .attr("height", sliderHeight )
      .attr("rx", sliderRadius )
      .attr("ry", sliderRadius )
      .attr("fill", "lightgrey" );

  slider.append("rect")
      .attr("y", 10 )
      .attr("width", function(d) { return x(d) } )
      .attr("height", sliderHeight )
      .attr("rx", sliderRadius )
      .attr("ry", sliderRadius )
      .attr("fill", function(d) { return d3.hsl(hue(d), .8, .8) } )
      .attr("id", "colored");

  slider.append("text")
      .attr("x", -50)
      .attr("y", 17)

      .text(function(d) { return d3.round(d, 1) });

  var handle = slider.append("circle")
      .attr("r", radius)
      .attr("cx", function(d) { return x(d) } )
      .attr("cy", 11 );

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