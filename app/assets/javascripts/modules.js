// FORM TIPS

$(document).ready(function() {
  $(".tip").tooltip();
});

// MENU NAV

$(document).ready(function() {
  $('a[data-toggle="menu"]').on('click', function (e) {
    e.preventDefault();

    var source   = $(this)
    var selector = source.attr('href');
    selector     = selector && selector.replace(/.*(?=#[^\s]*$)/, ''); // strip for ie7
    var parent   = source.parent('li');
    var previous = parent.parent('ul').find('li.active > a');
    var targets  = $('.tab-pane');
    var target   = targets.filter(selector);

    if (source.is(previous)) {
      parent.toggleClass('active');
      target.toggleClass('active');
    } else {
      previous.parent('li').removeClass('active');
      targets.filter('.active').removeClass('active');
      parent.toggleClass('active');
      target.toggleClass('active');
    }

  });
});