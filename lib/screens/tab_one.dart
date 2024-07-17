import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../modals/menu_modal.dart';
import '../service/services.dart';

class MenuTab1 extends StatefulWidget {
  final String? menuId;
  const MenuTab1({Key? key, this.menuId}) : super(key: key);

  @override
  State<MenuTab1> createState() => _MenuTab1State();
}

class _MenuTab1State extends State<MenuTab1> {
  final service = Services();
  String? selectedDish;
  int selectedPortion = 1;
  List<dynamic> dishNames = [];

  @override
  void initState() {
    super.initState();
    final menuModel = Provider.of<MenuModel>(context, listen: false);
    getMenuDetails_(menuModel.menuID);
  }

  Future<void> getMenuDetails_(String? menuID) async {
    final menuModel = Provider.of<MenuModel>(context, listen: false);
    final menus = await service.getMenuDetails(menuID);
    menuModel.setData(menus);
    menuModel.setLoading(false);
    setState(() {
      dishNames = menus["otherDishesFromSelectedMenu"];
      if (dishNames.isNotEmpty && selectedDish == null) {
        selectedDish = dishNames[0]["id"].toString();
      }
    });
  }

  Future<void> getUpdatedMenuDetails_(String selectedID) async {
    final menuModel = Provider.of<MenuModel>(context, listen: false);
    final menus     = await service.getMenuByDishes(selectedID);
    menuModel.setData(menus);
    setState(() {
      dishNames = menus["otherDishesFromSelectedMenu"];
    });
  }

  void updatePortions(int newPortion) {
    setState(() {
      selectedPortion = newPortion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuModel = Provider.of<MenuModel>(context);
    final data = menuModel.data;
    final portions = data["portions"] as List<dynamic>? ?? [];
    final dish = data["dish"] as Map<String, dynamic>? ?? {};
    final imageourl = data["image"] ?? '';
    final isLoading = menuModel.isLoading;

    return Scaffold(
      body: SingleChildScrollView(
        child: isLoading
            ? _buildShimmerLoading()
            : _buildContent(portions, dish, imageourl),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 20,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                Table(
                  children: List.generate(
                      5,
                      (index) => TableRow(children: [
                            Container(
                              height: 20,
                              color: Colors.grey,
                            ),
                            Container(
                              height: 20,
                              color: Colors.grey,
                            ),
                          ])),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  3,
                  (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey,
                        ),
                      )),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
      List<dynamic> portions, Map<String, dynamic> dish, String imageourl) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Select to choose a Dish",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.blue, width: 0.5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: dishNames.isNotEmpty
                ? DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                      hint: const Text(
                        "Change dishes",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      value: selectedDish,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedDish = newValue;
                          });
                          getUpdatedMenuDetails_(selectedDish!);
                        }
                      },
                      items: dishNames
                          .map<DropdownMenuItem<String>>((dynamic value) {
                        return DropdownMenuItem<String>(
                          value: value["id"].toString(),
                          child: Text(
                            value["dishName"],
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                        );
                      }).toList(),
                      dropdownColor: Colors.white,
                      isExpanded: true,
                    ),
                  )
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Portions Configurations",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      "Number of pax",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.remove,
                      size: 15,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      if (selectedPortion > 1) {
                        updatePortions(selectedPortion - 1);
                      }
                    },
                  ),
                  Text(
                    '$selectedPortion',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                      size: 15,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      if (selectedPortion < 10) {
                        updatePortions(selectedPortion + 1);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Table(
            border: TableBorder.all(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(3),
            ),
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                children: [
                  TableCell(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                          'Product Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                          'Unit Needed',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              for (var portion in portions)
                TableRow(
                  children: [
                    TableCell(
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                                 portion['productName'],
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        if(portion['extraDetails'] != null)...[
                          Text(
                              '(${portion['extraDetails']})',
                              style: const TextStyle(
                                color: Colors.orange,
                              ),
                            )
                        ] 
                          ],
                        )
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: portion['multiply'] == 1
                            ? Text(
                          '${(double.parse(portion['unitNeeded'].replaceAll(',', '')) * selectedPortion).toStringAsFixed(2)} (${portion['unit'].replaceAll(',', '')})',
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              )
                            : Text(
                          '${(double.parse(portion['unitNeeded'].replaceAll(',', ''))).toStringAsFixed(2)} (${portion['unit'].replaceAll(',', '')})',
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (imageourl.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Dish Image",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Container(
              constraints: BoxConstraints(
                minHeight: 300,
                minWidth: MediaQuery.of(context).size.width,
              ),
              padding: const EdgeInsets.all(16.0),
              child: Image.network(
                width: MediaQuery.of(context).size.width,
                height: 350,
                imageourl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
