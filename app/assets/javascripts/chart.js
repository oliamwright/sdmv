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
});