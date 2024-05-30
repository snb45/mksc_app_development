import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:popover/popover.dart';

class DropdownIconButton extends StatefulWidget {
  final String initialData;
  final Function(String) onOptionSelected;

  const DropdownIconButton({
    Key? key,
    this.initialData = "",
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  State<DropdownIconButton> createState() => _DropdownIconButtonState();
}

class _DropdownIconButtonState extends State<DropdownIconButton> {
  String selectedData = "";

  @override
  void initState() {
    super.initState();
    selectedData = widget.initialData;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/getdata');
        // showPopover(
        //     context: context,
        //     bodyBuilder: (context) => const ListItems(),
        //     onPop: () => print('Popover was popped!'),
        //     direction: PopoverDirection.bottom,
        //     width: 130,
        //     height: 150,
        //     arrowHeight: 15,
        //     arrowWidth: 30,
        //   );
      },
      child: const Padding(
        padding: EdgeInsets.only(right: 15.0),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Edit data ",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Icon(Ionicons.filter_outline, color: Colors.white),
          ],
        ),
      ),
    );
  }

}
class ListItems extends StatelessWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/getdata');
              },
              child: Container(
                height: 50,
                color: const Color.fromARGB(255, 109, 189, 243),
                child:  const Center(child: Text('Today Data',style:TextStyle(color: Colors.white))),
              ),
            ),
            const Divider(),
           InkWell(
            onTap: () {
                
              },
              child: Container(
                height: 50,
                color: const Color.fromARGB(255, 109, 189, 243),
                child: const Center(child: Text('All data',style:TextStyle(color: Colors.white)),
              ),
            ),
           )
          ],
        ),
    );
  }
}