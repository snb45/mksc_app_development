import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../modals/chartdatamodal.dart';
import '../service/services.dart';

class LineGraph extends StatefulWidget {
  LineGraph({Key? key}) : super(key: key);

  @override
  State<LineGraph> createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  List<Map<String, dynamic>>? sitedata;
  final Services _service = Services();

  List<ChartData> populationData = [];
  List<ChartData> dailyData = [];
  List<ChartData> weeklyData = [];
  List<ChartData> monthlyData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      final jsonData = await _service.getData('chickendata', today, "");
      setState(() {
        populationData = (jsonData['populationData'] as List)
            .map(
                (data) => ChartData(data['month'], double.parse(data['total'])))
            .toList();

        dailyData = (jsonData['daily'] as List)
            .map((data) => ChartData(data['day'], double.parse(data['total'])))
            .toList();

        weeklyData = (jsonData['weekly'] as List)
            .map((data) => ChartData(data['week'], double.parse(data['total'])))
            .toList();

        monthlyData = (jsonData['monthly'] as List)
            .map(
                (data) => ChartData(data['month'], double.parse(data['total'])))
            .toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  final LinearGradient _gradient = const LinearGradient(
    colors: <Color>[
      Color.fromRGBO(218, 242, 250, 1),
      Color.fromRGBO(186, 231, 246, 1.0),
      Colors.blue,
    ],
    stops: <double>[0.2, 0.4, 0.9],
    // transform: GradientRotation(-90)
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            title: const ChartTitle(text: 'Population Analysis'),
            legend: const Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<ChartData, String>>[
              LineSeries<ChartData, String>(
                dataSource: populationData,
                xValueMapper: (ChartData data, _) => data.year,
                yValueMapper: (ChartData data, _) => data.sales,
                name: 'Population',
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
          SfCartesianChart(
            title: const ChartTitle(text: 'Daily Analysis'),
            primaryXAxis: const CategoryAxis(),
            primaryYAxis: const CategoryAxis(),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<ChartData, String>>[
              ColumnSeries(
                dataSource: dailyData,
                xValueMapper: (ChartData data, _) => data.year,
                yValueMapper: (ChartData data, _) => data.sales,
                gradient: _gradient,
                width: 0.2,
              )
            ],
          ),
          SfCartesianChart(
            title: const ChartTitle(text: 'Weekly Analysis'),
            primaryXAxis: const CategoryAxis(),
            legend: const Legend(isVisible: true),
            primaryYAxis: const CategoryAxis(),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<ChartData, String>>[
              ColumnSeries(
                dataSource: weeklyData,
                xValueMapper: (ChartData data, _) => data.year,
                yValueMapper: (ChartData data, _) => data.sales,
                gradient: _gradient,
                width: 0.2,
              )
            ],
          ),
          SfCartesianChart(
            title: const ChartTitle(text: 'Monthly Analysis'),
            primaryXAxis: const CategoryAxis(),
            legend: const Legend(isVisible: true),
            primaryYAxis: CategoryAxis(),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<ChartData, String>>[
              ColumnSeries(
                dataSource: monthlyData,
                xValueMapper: (ChartData data, _) => data.year,
                yValueMapper: (ChartData data, _) => data.sales,
                gradient: _gradient,
                width: 0.2,
              )
            ],
          ),
        ],
      ),
    );
  }
}
// SfPyramidChart(
          //   title: ChartTitle(text: 'Daily Analysis'),
          //   legend: Legend(isVisible: true),
          //   tooltipBehavior: TooltipBehavior(enable: true),
          //   series: PyramidSeries<ChartData, String>(
          //     dataSource: dailyData,
          //     xValueMapper: (ChartData sales, _) => sales.year,
          //     yValueMapper: (ChartData sales, _) => sales.sales,
          //   ),
          // ),
          // Second chart with daily data
          // SfCartesianChart(
          //   primaryXAxis: CategoryAxis(),
          //   title: ChartTitle(text: 'Daily Analysis'),
          //   legend: Legend(isVisible: true),
          //   tooltipBehavior: TooltipBehavior(enable: true),
          //   series: <CartesianSeries<ChartData, String>>[
          //     LineSeries<ChartData, String>(
          //       dataSource: dailyData,
          //       xValueMapper: (ChartData data, _) => data.year,
          //       yValueMapper: (ChartData data, _) => data.sales,
          //       name: 'Daily',
          //       dataLabelSettings: DataLabelSettings(isVisible: true),
          //     ),
          //   ],
          // ),

// horizontal bars
// SfCartesianChart(
// title: ChartTitle(text: 'Daily Analysis'),
// primaryXAxis: CategoryAxis(),
// primaryYAxis: NumericAxis(
// minimum: 0,
// maximum: 40,
// interval: 10,
// ),
// tooltipBehavior: TooltipBehavior(enable: true),
// series: <CartesianSeries<ChartData, String>>[
// BarSeries(
// dataSource: dailyData,
// xValueMapper: (ChartData data, _) => data.year,
// yValueMapper: (ChartData data, _) => data.sales,
// color: Color.fromRGBO(8, 142, 255, 1),
// )
// ],
// ),