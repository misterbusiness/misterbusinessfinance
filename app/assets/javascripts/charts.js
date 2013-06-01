//function handleButtonClick() {
//    alert('button clicked!');
//    drawVisualization();
//}
//
//function drawVisualization() {
//    $.getScript('https://www.google.com/jsapi', function (data, textStatus) {
//        google.load('visualization', '1', {'packages': ['corechart'], 'callback': function () {
//            $.getJSON('lancamentos/reports/receita_realizada', function (data) {
//                alert("got json");
//                var table = new google.visualization.DataTable();
//                $.each(data.cols, function () {
//                    table.addColumn.apply(table, this);
//                });
//                table.addRows(data.rows);
//                alert("table ready");
//                //table.send(handleResponse);
//                var container = document.getElementById('report_zone_div');
//                var chart = new google.visualization.ChartWrapper(container);
//
//                alert("chartStarted");
//                chart.setChartType(data.type);
//                chart.setDataTable(table);
//                chart.setOptions(data.options);
//
//                if (data.title.length > 0) {
//                    chart.setOption('title', data.title);
//                }
//                if (data.is3D.length > 0) {
//                    chart.setOption('is3D', data.is3D);
//                }
//                if (data.color.length > 0) {
//                    chart.setOption('colors', data.color);
//                }
//
//                //chart.setOption('width', container.width());
//                //chart.setOption('height', container.height());
//                alert("chart ready");
//                chart.draw(table);
//                chart.getChart();
//            });
//        }});
//    });
//}


//$(function () {
//function drawChart(targetId, targetReport) {
//google.load('visualization', '1', {'packages':['corechart']});

//function drawChart() {
//    alert("DrawChart1");
//        // Load Google visualization library if a chart element exists
//       // if ($('[data-chart]').length > 0) {
//    //'report_zone_1_div',<%=  lancamentos_reports_receita_realizada_path %>
////            $.getScript('https://www.google.com/jsapi', function (data, textStatus) {
////                google.load('visualization', '1.0', { 'packages': ['corechart'], 'callback': function () {
////                google.load('visualization', '1.0', { 'packages': ['corechart']}, function () {
//                    // Google visualization library loaded
//                    //$('[data-chart]').each(function () {
//
//
////                    $('#report_zone_1_div').load("",function () {
////                        var div = $(this);
////                        // Fetch chart data
////                        //$.getJSON(div.data('chart'), function (data) {
////                        $.getJSON('lancamentos/reports/receita_realizada', function (data) {
////                        // Create DataTable from received chart data
////                            var table = new google.visualization.DataTable();
////                            //table.addCols(data.cols);
////                            $.each(data.cols, function () {
////                                table.addColumn.apply(table, this);
////                            });
////                            table.addRows(data.rows);
////
////                            // Draw the chart
////                            var chart = new google.visualization.ChartWrapper();
////                            chart.setChartType(data.type);
////                            chart.setDataTable(table);
////                            chart.setOptions(data.options);
////                            if (data.title.length > 0) {chart.setOption('title', data.title);}
////                            if (data.is3D.length > 0) {chart.setOption('is3D',data.is3D);}
////                            if (data.color.length > 0) {chart.setOption('colors', data.color);}
////                            chart.setOption('width', div.width());
////                            chart.setOption('height', div.height());
////                            chart.draw(div.get(0));
////                        });
////
////
////                    });
//                }
//                //});
//            //});
//       // }
////    });
////}
//
//function drawChart2(){
//    alert("Drawchart2");
//    $('#chartsArea').load("",function () {
//                        var div = $(this);
//                        // Fetch chart data
//                        //$.getJSON(div.data('chart'), function (data) {
//                        $.getJSON('lancamentos/reports/receita_realizada', function (data) {
//                        // Create DataTable from received chart data
//                            var table = new google.visualization.DataTable();
//                            //table.addCols(data.cols);
//                            $.each(data.cols, function () {
//                                table.addColumn.apply(table, this);
//                            });
//                            table.addRows(data.rows);
//
//                            // Draw the chart
//                            var chart = new google.visualization.ChartWrapper();
//                            chart.setChartType(data.type);
//                            chart.setDataTable(table);
//                            chart.setOptions(data.options);
//                            if (data.title.length > 0) {chart.setOption('title', data.title);}
//                            if (data.is3D.length > 0) {chart.setOption('is3D',data.is3D);}
//                            if (data.color.length > 0) {chart.setOption('colors', data.color);}
//                            chart.setOption('width', div.width());
//                            chart.setOption('height', div.height());
//                            chart.draw(div.get(0));
//                        });
//
//
//                    });
//
//}
////});