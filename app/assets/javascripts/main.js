$(document).ready(function() {

  news_keywords = [];
  social_keywords = [];

  function update_news() {
    $.ajax({
      url: '/news',
      type: 'POST',
      data: { 
        news:       $('#news').val(),
        exclusion:  $('#exclusion').val()
      },
      success: function(e) {
        append_news_result(e);
        news_keywords = JSON.parse(e.news_keywords);
      },
      error: function(e) {
      }
    });
  }

  function append_news_result(resp) {
    json_obj = JSON.parse(resp.result);

    news_result_append = '';
    for (var key in json_obj) {
      if (json_obj.hasOwnProperty(key)) {
        news_result_append += '<li>' + key + ' (' + json_obj[key] + ')' + '</li>';
      }
    }
    $('#news_result').html(news_result_append);
    $('#social_news_comp').text('Social / News Keyword Comp = ' + resp.similarity + '%');
  }

  // when lost focus on social area
  $('#social').on("blur", function() {
    $.ajax({
      url: '/social',
      type: 'POST',
      data: { social: $('#social').val() },
      success: function(e) {
        result_obj = JSON.parse(e.result);
        social_keywords = JSON.parse(e.social_keywords);

        social_result_append = '';
        for (var key in result_obj) {
          if (result_obj.hasOwnProperty(key)) {
            social_result_append += '<li>' + key + ' (' + result_obj[key] + ')' + '</li>';
          }
        }
        $('#social_result').html(social_result_append);
        $('#social_news_comp').text('Social / News Keyword Comp = ' + e.similarity + '%');

        output_social_person(undefined);
      },
      error: function(e) {
      }
    });
  });

  // when lost focus on news area
  $('#news').on('blur', update_news);

  // when lost focus on exclusion area
  $('#exclusion').on('blur', update_news);

  // If numeric field value is not invalid, give focus on that
  $('.numeric').on('blur', function() {
    if (isNaN($(this).val())) {
      alert('Please input numeric value.');
      $(this).focus();
    }
  });

  function output_social_person (obj) {
    if (obj === undefined) {  // Social keywords was changed
      similarity_percent1 = calculate_social_person($('#person_keywords1'));
      $('#person_int_lvl1').text(similarity_percent1);

      similarity_percent2 = calculate_social_person($('#person_keywords2'));
      $('#person_int_lvl2').text(similarity_percent2);

      similarity_percent3 = calculate_social_person($('#person_keywords3'));
      $('#person_int_lvl3').text(similarity_percent3);
    } else {  // Person keywords was changed
      return calculate_social_person(obj);
    }
  }

  function calculate_social_person (obj) {
    keywords = obj.val().split(',');

    for (var i = 0; i < keywords.length; i++) {
      keywords[i] = keywords[i].trim();
    }

    same_count = 0;
    for (var i = 0; i < keywords.length; i++) {
      if ($.inArray(keywords[i], social_keywords) > -1) {
        same_count += 1;
      }
    }

    similarity_percent = 0;
    if (same_count == 0 || social_keywords.length == 0) {
      similarity_percent = 0;
    }
    else {
      similarity_percent = (same_count / social_keywords.length) * 100;
    }

    return similarity_percent;
  }

  // Person1 keywords
  $('#person_keywords1').on('blur', function() {
    similarity_percent = output_social_person($(this));
    $('#person_int_lvl1').text(similarity_percent);
  });

  // Person2 keywords
  $('#person_keywords2').on('blur', function() {
    similarity_percent = output_social_person($(this));
    $('#person_int_lvl2').text(similarity_percent);
  });

  // Person3 keywords
  $('#person_keywords3').on('blur', function() {
    similarity_percent = output_social_person($(this));
    $('#person_int_lvl3').text(similarity_percent);
  });

  $('#person_location_x1, #person_location_y1, #venue_x1, #venue_y1,' +
    '#person_location_x2, #person_location_y2, #venue_x2, #venue_y2,' + 
    '#person_location_x3, #person_location_y3, #venue_x3, #venue_y3')
  .on('blur', function() {
    
  })

  $('#influence1, #influence2, #influence3').on('blur', function() {
    debugger;
    for (var i = 1; i <= 3; i++) {
      for (var j = 1; j <= 3; j++) {
        $('#venue'+i+'_influence'+j).html($('#influence'+j).val());
      }
    }
  })
});