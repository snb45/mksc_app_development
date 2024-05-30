import 'package:flutter/material.dart';
import 'package:mksc_mobile/screens/warningscreen.dart';
import 'package:mksc_mobile/widgets/linesgraph.dart';
import 'package:mksc_mobile/widgets/piegraph.dart';

class ViewData extends StatefulWidget {
  const ViewData({super.key, required this.title});
  final title;
  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(218, 242, 250, 1),
        title: Text(
          "View ${widget.title} Data",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.title == "Chicken House"
            ? LineGraph()
            : widget.title == "Vegetable"
                ? PieChart()
                : WarningScreen(),
      ),
    );
  }
}
