$(document).ready(function() {

  function createKrForm(o, kr) {
    var html = '<div class="kr-form-group" data-kr-id="' + kr + '">'
    html += '<label>Key Result: </label>';
    html += '<input type="text" name="okr[objectives_attributes][' + o + '][key_results_attributes][' + kr + '][description]"></div>';
    return html;
  }

  function createObjectiveForm(o) {
    var html = '<div class="o-form-group" data-o-id="' + o + '" data-kr-count="0">';
    html += '<label>Objective: </label>';
    html += '<input type="text" name="okr[objectives_attributes][' + o + '][description]">';
    html += '<div class="kr-form-group">';
    html += '<label>Key Result: </label>';
    html += '<input type="text" name="okr[objectives_attributes][' + o + '][key_results_attributes][0][description]"></div>';
    html += '<a class="add-kr-btn" href="#">Add KR</a>';
    html += '<a class="remove-kr-btn" href="#">Remove KR</a></div>';
    return html;
  }

  $('#define-okr').on('click', 'a.add-o-btn', function() {
    // Identify O count
    var parentOkr = $(this).parent('.okr-form-group');
    var oCount = parentOkr.data('o-count');
    // Increment 0 count
    parentOkr.data('o-count', oCount + 1);
    // Generate new O and KR fields
    parentOkr.find('.o-form-group').last().after(createObjectiveForm(oCount + 1));
    // Show / Hide O Delete Button
    if (oCount == 0) {
      parentOkr.find('.remove-o-btn').show();
    }
    return false;
  });

  $('#define-okr').on('click', 'a.remove-o-btn', function() {
    var parentOkr = $(this).parent('.okr-form-group');
    var oCount = parentOkr.data('o-count');
    var lastOjective = parentOkr.find('.o-form-group').last();
    lastOjective.remove();
    parentOkr.data('o-count', oCount - 1 );
    if (oCount == 1) {
      parentOkr.find('.remove-o-btn').hide();
    }
    return false;
  });

  $('#define-okr').on('click', 'a.add-kr-btn', function() {
    // Identify 0 id and KR count
    var parentObjective = $(this).parent('.o-form-group');
    var oCount = parentObjective.data('o-id');
    var krCount = parentObjective.data('kr-count');
    // Increment KR count
    parentObjective.data('kr-count', krCount + 1);
    // Generate new KR fields
    parentObjective.find('.kr-form-group').last().after(createKrForm(oCount, krCount + 1));
    // Show / Hide KR Delete Button
    if (krCount == 0) {
      parentObjective.find('.remove-kr-btn').show();
    }
    return false;
  });

  $('#define-okr').on('click', 'a.remove-kr-btn', function() {
    var parentObjective = $(this).parent('.o-form-group');
    var krCount = parentObjective.data('kr-count');
    var lastKr = parentObjective.find('.kr-form-group').last();
    lastKr.remove();
    parentObjective.data('kr-count', krCount - 1 );
    if (krCount == 1) {
      parentObjective.find('.remove-kr-btn').hide();
    }
    return false;
  });

});

// var objectives = [
//   { "description": "First Objective", "keyResults": [ "description": "first kr", "descritpion": "sec kr"]},
//   { "description": "2nd Objective", "keyResults": [ "description": "first kr" ] },
//   { "description": "2nd Objective", "keyResults": [ "description": "first kr" ] }
// ]
