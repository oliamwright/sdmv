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

        calculate_social_person();
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

  function calculate_social_person () {
    for (var j = 1 ; j <= 3; j++ ) {
      keywords = $('#person_keywords' + j).val().split(',');

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

      $('#person_int_lvl' + j).text(similarity_percent);
      $('#venue' + j + '_int' + i).html((similarity_percent / 100).toFixed(1));
    }
  }

  // Calculate and show value of Venue{#} by each Person{#} data
  // Sum up the VAL
  function calculate_venue_val() {
    for (var i = 1; i <= 3; i++) {
      val_sum = 0;
      for (var j = 1; j <=3; j++) {
        dist = isNaN($('#venue' + i + '_dist' + j).html()) ? 0 : $('#venue' + i + '_dist' + j).html();
        int_lvl = isNaN($('#venue' + i + '_int' + j).html()) ? 0 : $('#venue' + i + '_int' + j).html();
        inf = isNaN($('#venue' + i + '_influence' + j).html()) ? 0 : $('#venue' + i + '_influence' + j).html();

        val = 0
        if (dist == 0) {
          val = 0;
        } else {
          val = (int_lvl * inf) / dist;
        }

        val_sum += val;
        $('#venue' + i + '_val' + j).html(val.toFixed(1));
      }

      $('#venue_val_sum' + i).html(val_sum.toFixed(1));
    }
  }

  // Calculate and show dist of Venue{#} by each Person{#} data
  // Sum up the DIST
  function calculate_venue_dist() {
    for (var i = 1; i <= 3; i++) {
      dist_sum = 0;
      for (var j = 1; j <= 3; j++) {
        v_x = isNaN($('#venue_x' + i).val()) ? 0 : $('#venue_x' + i).val();
        v_y = isNaN($('#venue_y' + i).val()) ? 0 : $('#venue_y' + i).val();
        p_x = isNaN($('#person_location_x' + j).val()) ? 0 : $('#person_location_x' + j).val();
        p_y = isNaN($('#person_location_y' + j).val()) ? 0 : $('#person_location_y' + j).val();

        v = Math.sqrt(Math.pow((v_x - p_x), 2) + Math.pow((v_y - p_y), 2));

        dist_sum += v;
        $('#venue' + i + '_dist' + j).html(v.toFixed(1));
      }
      $('#venue_dist_sum' + i).html(dist_sum.toFixed(1));
    }
  }

  // Person1 keywords
  $('#person_keywords1, #person_keywords2, #person_keywords3').on('blur', function() {
    calculate_social_person();
  });

  $('#person_location_x1, #person_location_y1, #venue_x1, #venue_y1,' +
    '#person_location_x2, #person_location_y2, #venue_x2, #venue_y2,' + 
    '#person_location_x3, #person_location_y3, #venue_x3, #venue_y3')
  .on('blur', function() {

    calculate_venue_dist();
    calculate_venue_val();
  })

  $('#influence1, #influence2, #influence3').on('blur', function() {
    for (var i = 1; i <= 3; i++) {
      for (var j = 1; j <= 3; j++) {
        $('#venue' + i + '_influence' + j).html($('#influence' + j).val());
      }
    }

    calculate_venue_val();
  })
});