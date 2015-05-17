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
        news_keywords = JSON.parse(e.news_keywords);
        append_news_result(e);
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

    $('#title_keyword1').html(news_keywords[0] ? news_keywords[0] : "" );
    $('#title_keyword2').html(news_keywords[1] ? news_keywords[1] : "" );
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
  $('#news, #exclusion').on('blur', update_news);

  // If numeric field value is not invalid, give focus on that
  $('.numeric').on('blur', function() {
    if (isNaN($(this).val())) {
      alert('Please input numeric value.');
      $(this).focus();
    }
  });

  function calculate_social_person () {
    sum_int = 0;
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

      sum_int += similarity_percent;
      $('#person_int_lvl' + j).text(similarity_percent);
      $('#venue' + j + '_int' + i).html((similarity_percent / 100).toFixed(1));
    }

    $('#avg_int').html((sum_int / 3).toFixed(1));
  }

  // Calculate and show value of Venue{#} by each Person{#} data
  // Sum up the VAL
  function calculate_venue_val() {
    val_max_idx = 0;
    val_max = -99999;
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

        val = parseFloat(val.toFixed(1));
        val_sum += val;
        $('#venue' + i + '_val' + j).html(val);

        // Get maximum Venue and its index
        if (val > val_max) {
          val_max = val;
          val_max_idx = i;
        }
      }

      $('#venue_val_sum' + i).html(val_sum.toFixed(1));
      $('#max_venue').html(val_max_idx);
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
      inf_sum = 0;

      for (var j = 1; j <= 3; j++) {
        $('#venue' + i + '_influence' + j).html($('#influence' + j).val());
        inf_sum += parseFloat($('#influence' + j).val());
      }
    }
    debugger;
    $('#avg_influence').html((inf_sum / 3).toFixed(1));
    calculate_venue_val();
  })

  $('#person1_availability_min, #person1_availability_max,' + 
    '#person2_availability_min, #person2_availability_max' + 
    '#person3_availability_min, #person3_availability_max').on('blur', function() {

   if (isNaN($(this).val())) {
      alert('Please input numeric value.');
      $(this).focus();  
    } else {
      p1_min = isNaN($('#person1_availability_min').val()) ? 0 : parseFloat($('#person1_availability_min').val());
      p1_max = isNaN($('#person1_availability_max').val()) ? 0 : parseFloat($('#person1_availability_max').val());

      avg1 = (p1_max + p1_min) / 2;

      p2_min = isNaN($('#person2_availability_min').val()) ? 0 : parseFloat($('#person2_availability_min').val());
      p2_max = isNaN($('#person2_availability_max').val()) ? 0 : parseFloat($('#person2_availability_max').val());
      avg2 = (p2_max + p2_min) / 2;      

      p3_min = isNaN($('#person3_availability_min').val()) ? 0 : parseFloat($('#person3_availability_min').val());
      p3_max = isNaN($('#person3_availability_max').val()) ? 0 : parseFloat($('#person3_availability_max').val());
      avg3 = (p3_max + p3_min) / 2;

      avg = (avg1 + avg2 + avg3) / 3;
      $('#avg_availability').html(avg.toFixed(1));
    }
  })
});