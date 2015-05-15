$(document).ready(function() {
  // when lost focus on news area
  $('#news').on('blur', function() {
    $.ajax({
      url: '/news',
      method: 'get',
      dataType: 'json',
      data: { 
        news:       $('#news').val(),
        exclusion:  $('#exclusion').val()
      },
      parameters: { 
        news:       $('#news').val(),
        exclusion:  $('#exclusion').val()
      },
      success: function(e) {
        result_obj = JSON.parse(e.result);
        append_news_result(result_obj);
        
      },
      error: function(e) {
      }
    });
  });

  // when lost focus on exclusion area
  $("#exclusion").on("blur", function(){
    $.ajax({
      url: '/news',
      method: 'get',
      dataType: 'json',
      data: { 
        news:       $('#news').val(),
        exclusion:  $('#exclusion').val()
      },
      parameters: { 
        news:       $('#news').val(),
        exclusion:  $('#exclusion').val()
      },
      success: function(e) {
        result_obj = JSON.parse(e.result);
        append_news_result(result_obj);
      },
      error: function(e) {
      }
    });
  });

  // when lost focus on social area
  $("#social").on("blur", function() {

  });

  function append_news_result(json_obj) {
    news_result_append = '';
    for (var key in json_obj) {
      if (json_obj.hasOwnProperty(key)) {
        news_result_append += '<li>' + key + ' (' + json_obj[key] + ')' + '</li>';
      }
    }
    $('#news_result').html(news_result_append);
  }
});