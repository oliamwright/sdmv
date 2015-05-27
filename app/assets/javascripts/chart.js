$(function () {
    $('#container').highcharts({
        chart: {
            type: 'scatter',
            zoomType: 'xy'
        },
        title: {
            text: 'Person & Venue Location'
        },
        subtitle: {
            text: ''
        },
        xAxis: {
            title: {
                enabled: true,
                text: 'X'
            },
            startOnTick: true,
            endOnTick: true,
            showLastLabel: true
        },
        yAxis: {
            title: {
                text: 'Y'
            }
        },
        legend: {
            layout: 'vertical',
            align: 'left',
            verticalAlign: 'top',
            x: 100,
            y: 70,
            floating: true,
            backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF',
            borderWidth: 1
        },
        plotOptions: {
            scatter: {
                marker: {
                    radius: 5,
                    states: {
                        hover: {
                            enabled: true,
                            lineColor: 'rgb(100,100,100)'
                        }
                    }
                },
                states: {
                    hover: {
                        marker: {
                            enabled: false
                        }
                    }
                },
                tooltip: {
                    // formatter: function () {
                    //     return this.series.data.indexOf(this.point);
                    // }
                    headerFormat: '<b>{series.name}</b><br>',
                    pointFormat: '{point.x} x, {point.y} y'
                }
            }
        },
        series: [{
            name: 'Person',
            color: 'rgba(223, 83, 83, .5)',
            data: [[1, 2], [2, 2], [0, 0]]

        }, {
            name: 'Venue',
            color: 'rgba(119, 152, 191, .5)',
            data: [[3, 1], [3, 3], [-1, -1]]
        }]
    });

  // Update Highchart series data for Venue objects
  // This is called as Ajax callback
  window.update_venue_data = function(venue_data) {
    chart = $('#container').highcharts();

    venue_series_data = [];
    venue_data_list = JSON.parse(venue_data);
    for (var i = 0; i < venue_data_list.length; i++) {
      venue_series_data.push([venue_data_list[i].x, venue_data_list[i].y]);
    }

    chart.series[1].setData(venue_series_data);
  }

  // Update Highchart series data for Person objects
  // This is called as Ajax callback
  window.update_person_data = function(person_data) {
    chart = $('#container').highcharts();

    person_series_data = [];
    person_data_list = JSON.parse(person_data);
    for (var i = 0; i < person_data_list.length; i++) {
      person_series_data.push([person_data_list[i].x, person_data_list[i].y]);
    }

    chart.series[0].setData(person_series_data);
  }
});