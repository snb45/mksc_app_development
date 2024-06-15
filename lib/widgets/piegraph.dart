import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mksc_mobile/service/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import '../modals/chartdatamodal.dart';
import '../modals/piechartdatamodal.dart';

class PieChart extends StatefulWidget {
  const PieChart({super.key});

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  List<Map<String, dynamic>>? sitedata;
  final Services _service = Services();

  List<PieChartData> populationData = [];
  List<PieChartData> dailyData = [];
  List<PieChartData> weeklyData = [];
  List<PieChartData> monthlyData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final jsonData = await _service.getVegetableData('vegetable');
      setState(() {
        dailyData = (jsonData['daily'] as List)
            .map((data) =>
                PieChartData(data['item'], double.parse(data['number'])))
            .toList();

        weeklyData = (jsonData['weekly'] as List)
            .map((data) =>
                PieChartData(data['item'], double.parse(data['number'])))
            .toList();

        monthlyData = (jsonData['monthly'] as List)
            .map((data) =>
                PieChartData(data['item'], double.parse(data['number'])))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  final LinearGradient _gradient = const LinearGradient(
    colors: <Color>[
      Color.fromRGBO(218, 242, 250, 1),
      Color.fromRGBO(186, 231, 246, 1.0),
      Colors.blue,
    ],
    stops: <double>[0.2, 0.4, 0.9],
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (isLoading)
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: [
                  _buildShimmerCard(),
                  _buildShimmerCard(),
                  _buildShimmerCard(),
                ],
              ),
            )
          else ...[
            if (dailyData.isNotEmpty)
              VegetablePieChart(
                data: dailyData,
                title: '${DateFormat('d MMMM yyyy').format(DateTime.now())}',
              ),
            if (weeklyData.isNotEmpty)
              VegetablePieChart(
                data: weeklyData,
                title: _getWeeklyTitle(),
              ),
            if (monthlyData.isNotEmpty)
              VegetablePieChart(
                data: monthlyData,
                title:
                    '${DateFormat('MMMM').format(DateTime.now())} Collections',
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.all(10),
      child: Container(
        height: 230,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:BorderRadius.circular(10)
        ),
        
      ),
    );
  }

  String _getWeeklyTitle() {
    DateTime now = DateTime.now();
    int weekNumber =
        ((now.difference(DateTime(now.year, 1, 1)).inDays) / 7).ceil();

    return 'Week #$weekNumber Collections';
  }
}

class VegetablePieChart extends StatelessWidget {
  final List<PieChartData> data;
  final String title;

  VegetablePieChart({required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w200)),
          ),
          SfCircularChart(
            legend: const Legend(isVisible: true),
            series: <PieSeries>[
              PieSeries<PieChartData, String>(
                dataSource: data,
                xValueMapper: (PieChartData data, _) => data.item,
                yValueMapper: (PieChartData data, _) => data.number,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
