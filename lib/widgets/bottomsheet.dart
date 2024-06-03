import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc_mobile/screens/menuscreen.dart';
import 'package:mksc_mobile/screens/vegetable_screen.dart';
import 'package:mksc_mobile/service/services.dart';

import '../screens/formdata.dart';
import '../screens/viewdata.dart';

class CampSelectionBottomSheet extends StatefulWidget {
  final String? initialSelectedCamp;
  final String? title;
  final String? selectedCampType;
  final String? selectedDay;
  final String? selectedMenu;

  const CampSelectionBottomSheet(
      {Key? key,
      this.initialSelectedCamp,
      this.selectedCampType,
      this.title,
      this.selectedDay,
      this.selectedMenu})
      : super(key: key);

  @override
  _CampSelectionBottomSheetState createState() =>
      _CampSelectionBottomSheetState();
}

class _CampSelectionBottomSheetState extends State<CampSelectionBottomSheet> {
  late String? _selectedCamp;
  late String? _selectedCampType;
  late String? typeID;
  late String? _selectedDay;
  late String? selectedMenuId;
  late String? _selectedMenu;
  late bool _isExpanded = false;
  late bool _typeisExpanded = false;
  late bool _dayExpanded = false;
  late bool _menuExpanded = false;
  final service = Services();
  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  @override
  void initState() {
    super.initState();
    _selectedCamp = widget.initialSelectedCamp;
    _selectedCampType = widget.selectedCampType;
    _selectedDay = widget.selectedDay;
    _selectedMenu = widget.selectedMenu;
    getCampdata();
  }

  Future<List<dynamic>> getCampdata() async {
    final camps = await service.getCamps();
    return camps;
  }

  Future<List<dynamic>> getMenutype() async {
    final camps = await service.getMenuType(_selectedCamp);
    return camps;
  }

  Future<List<dynamic>> getMenudata() async {
    final camps = await service.getMenu(_selectedDay, typeID, _selectedCamp);
    return camps;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(218, 242, 250, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      constraints: const BoxConstraints(
        minHeight: 300,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.title != "Menu") ...[
                SizedBox(
                  height: 80,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddData(title: widget.title ?? ''),
                          ),
                        );
                      // if (widget.title == 'Vegetable') {
                      //   Navigator.pop(context);
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) =>
                      //           VegetableScreen(title: widget.title ?? ''),
                      //     ),
                      //   );
                      // } else {
                        
                      // }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Card(
                        elevation: 0,
                        color: const Color.fromARGB(87, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: Colors.blue,
                            width: 0.2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.add,
                                color: Colors.blue,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Text("Add ${widget.title} data"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                  SizedBox(
                    height: 80,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewData(title: widget.title)),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Card(
                          color: const Color.fromARGB(87, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                              color: Colors.blue,
                              width: 0.2,
                            ),
                          ),
                          elevation: 0,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.blue,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 18.0),
                                  child: Text("Click to Consults"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ] else ...[
                SizedBox(
                  height: 80,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isExpanded = true;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Card(
                        elevation: 0,
                        color: const Color.fromARGB(87, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: Colors.blue,
                            width: 0.2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Text(_selectedCamp != null
                                    ? _selectedCamp!
                                    : 'Select Camp'),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_selectedCamp != null) ...[
                  SizedBox(
                    height: 80,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _typeisExpanded = true;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Card(
                          elevation: 0,
                          color: const Color.fromARGB(87, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                              color: Colors.blue,
                              width: 0.2,
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Text(_selectedCampType != null
                                      ? _selectedCampType!
                                      : 'Choose Menu Type'),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                if (_selectedCampType != null) ...[
                  SizedBox(
                    height: 80,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _dayExpanded = true;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Card(
                          elevation: 0,
                          color: const Color.fromARGB(87, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                              color: Colors.blue,
                              width: 0.2,
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Text(_selectedDay != null
                                      ? _selectedDay!
                                      : 'Choose a Day'),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                if (_selectedDay != null) ...[
                  SizedBox(
                    height: 80,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _menuExpanded = true;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Card(
                          elevation: 0,
                          color: const Color.fromARGB(87, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                              color: Colors.blue,
                              width: 0.2,
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Text(_selectedMenu != null
                                      ? _selectedMenu!
                                      : 'Choose Menu'),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                if (_isExpanded) ...[
                  FutureBuilder(
                    future: getCampdata(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: LinearProgressIndicator(
                            color: Colors.orange,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final camps = snapshot.data!;
                        return Container(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: camps.length,
                            itemBuilder: (BuildContext context, int index) {
                              final campName = camps[index]['camp'];
                              return ListTile(
                                title: Text(campName),
                                onTap: () {
                                  setState(() {
                                    _selectedCamp = campName;
                                    _isExpanded = false;
                                  });
                                },
                                selected: _selectedCamp == campName,
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
                if (_typeisExpanded) ...[
                  FutureBuilder(
                    future: getMenutype(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: LinearProgressIndicator(
                            color: Colors.orange,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final camps = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: camps.length,
                          itemBuilder: (BuildContext context, int index) {
                            final campName = camps[index]['type'];
                            return ListTile(
                              title: Text(campName == "1"
                                  ? "Break Fast"
                                  : campName == "2"
                                      ? "Lunch"
                                      : campName == "3"
                                          ? "Dinner"
                                          :campName == "4"
                                          ? "Picnic"
                                          : ""),
                              onTap: () {
                                setState(() {
                                  typeID = campName;
                                  _selectedCampType = campName == "1"
                                      ? "Break Fast"
                                      : campName == "2"
                                          ? "Lunch"
                                          : campName == "3"
                                              ? "Dinner"
                                              : campName == "4"
                                          ? "Picnic"
                                          :  "";
                                  _typeisExpanded = false;
                                });
                              },
                              selected: _selectedCampType == campName,
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ],
              if (_dayExpanded) ...[
                FutureBuilder<void>(
                  future: Future<void>.delayed(Duration(seconds: 1)),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: LinearProgressIndicator(
                          color: Colors.orange,
                        ),
                      );
                    } else {
                      return Container(
                         height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: daysOfWeek.length,
                          itemBuilder: (BuildContext context, int index) {
                            final dayName = daysOfWeek[index];
                            return ListTile(
                              title: Text(dayName),
                              onTap: () {
                                setState(() {
                                  _selectedDay = dayName;
                                  _dayExpanded = false;
                                });
                              },
                            );
                          },
                        ),
                      );
                    }
                  },
                )
              ],
              if (_menuExpanded) ...[
                FutureBuilder(
                  future: getMenudata(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: LinearProgressIndicator(
                          color: Colors.orange,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final camps = snapshot.data!;
                      return ListView.builder(
                        
                        shrinkWrap: true,
                        itemCount: camps.length,
                        itemBuilder: (BuildContext context, int index) {
                          final campName = camps[index]['menuName'];
                          final selectedIdMenu = camps[index]['id'];
                          return ListTile(
                            title: Text(campName),
                            onTap: () {
                              setState(() {
                                _selectedMenu = campName;
                                selectedMenuId = selectedIdMenu.toString();
                                _menuExpanded = false;
                              });
                            },
                            selected: _selectedCamp == campName,
                          );
                        },
                      );
                    }
                  },
                ),
              ],
              if (_selectedMenu != null) ...[
                Container(
                  margin: const EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      print("id sent.....................");
                      print(selectedMenuId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MenuScreen(menuId: selectedMenuId ?? "")),
                      );
                    },
                    child: const Text(
                      "Check Menu",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
