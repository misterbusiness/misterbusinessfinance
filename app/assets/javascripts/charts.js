$(function () {
  // function drawChart() {
        // Load Google visualization library if a chart element exists
        if ($('[data-chart]').length > 0) {
            $.getScript('https://www.google.com/jsapi', function (data, textStatus) {
                google.load('visualization', '1.0', { 'packages': ['corechart'], 'callback': function () {
                    // Google visualization library loaded
                    $('[data-chart]').each(function () {
                        var div = $(this)
                        // Fetch chart data
                        $.getJSON(div.data('chart'), function (data) {
                            // Create DataTable from received chart data
                            var table = new google.visualization.DataTable();
                            //table.addCols(data.cols);
                            $.each(data.cols, function () {
                                table.addColumn.apply(table, this);
                            });
                            table.addRows(data.rows);

                            // Draw the chart
                            var chart = new google.visualization.ChartWrapper();
                            chart.setChartType(data.type);
                            chart.setDataTable(table);
                            chart.setOptions(data.options);
                            if (data.title.length > 0) {chart.setOption('title', data.title);}
                            if (data.is3D.length > 0) {chart.setOption('is3D',data.is3D);}
                            if (data.color.length > 0) {chart.setOption('colors', data.color);}
                            chart.setOption('width', div.width());
                            chart.setOption('height', div.height());
                            //alert("6");
                            chart.draw(div.get(0));
                            //alert("7");
                        });
                    });
                }});
            });
        }
    //}
});