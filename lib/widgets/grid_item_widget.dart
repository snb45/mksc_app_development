// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mksc_mobile/screens/formdata.dart';
import 'package:mksc_mobile/screens/viewdata.dart';
import '../modals/grid_item.dart';
import 'bottomsheet.dart';

class GridItemWidget extends StatefulWidget {
  final GridItem item;

  const GridItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  State<GridItemWidget> createState() => _GridItemWidgetState();
}

class _GridItemWidgetState extends State<GridItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.item.title == "Chicken House" ||
            widget.item.title == "Menu" ||
            widget.item.title == "Vegetable") {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return CampSelectionBottomSheet(
                initialSelectedCamp: null,
                selectedCampType: null,
                title: widget.item.title,
                selectedDay: null,
              );
            },
          );
        } else {
          Fluttertoast.showToast(
              msg: "Sorry ${widget.item.title} not available for now",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue,
              Color.fromARGB(255, 154, 192, 224),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              widget.item.svgicon,
              height: 40,
              width: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 10.0),
            Text(
              widget.item.title,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
