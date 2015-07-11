$(document).ready(function() {

  var data = []

  var scoreBox = d3.selectAll(".score")
    .each(function() {
      var score = d3.select(this).attr("data-score");
      data.push(score);
    });

  // console.log(data);

  var width = 135,
      height = 30,
      radius = 5,
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
      .attr("cy", 12 )
      .attr("fill", function(d) { return d3.hsl(hue(d), .8, .8) } );

});