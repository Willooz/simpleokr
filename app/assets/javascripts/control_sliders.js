$(document).ready(function() {

  var data = []

  d3.selectAll(".review input")
    .each(function() {
      var id = d3.select(this).attr("data-id");
      var value = d3.select(this).attr("value");
      data.push({ id: id, value: value });
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

  var scoreBox = d3.selectAll(".review");

  scoreBox.append("svg")
      .attr("class", "canvas")
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
      .attr("fill", "#F0F0F0" );

  slider.append("rect")
      .attr("y", 10 )
      .attr("width", function(d) { return x(d.value) } )
      .attr("height", sliderHeight )
      .attr("rx", sliderRadius )
      .attr("ry", sliderRadius )
      .attr("fill", function(d) { return d3.hsl(hue(d.value), .8, .8) } )
      .attr("id", "colored");

  slider.append("text")
      .attr("x", -50)
      .attr("y", 17)

      .text(function(d) { return d3.round(d.value, 1) });

  var handle = slider.append("circle")
      .attr("r", radius)
      .attr("cx", function(d) { return x(d.value) } )
      .attr("cy", 12)
      .attr("fill", "white")
      .attr("stroke", "#CDCDCD")
      .attr("stroke-width", "1");

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

    // Move slider
    d3.select(this)
      .attr("cx", x(sliderPosition));

    // Move and colorize slider fill
    d3.select(this.parentNode).select("#colored")
      .attr("width", x(sliderPosition))
      .attr("fill", d3.hsl(sliderColor, .8, .8));

    // Update score text
    d3.select(this.parentNode).select("text")
      .text(d3.round(sliderPosition, 1));

    // Update score value in input field with right data-id property
    var dataId = d3.select(this.parentNode).datum().id;
    d3.select("[data-id='" + dataId + "']")
      .attr("value", d3.round(sliderPosition, 1));
  }

});