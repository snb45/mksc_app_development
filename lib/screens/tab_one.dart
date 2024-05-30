import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_html/flutter_html.dart';
import '../service/services.dart';

class MenuTab1 extends StatefulWidget {
  final String? menuId;
  const MenuTab1({Key? key, this.menuId}) : super(key: key);

  @override
  State<MenuTab1> createState() => _MenuTab1State();
}

class _MenuTab1State extends State<MenuTab1> {
  late String? _menuID;
  final service = Services();
  late Map<String, dynamic> data = {};
  bool isLoading = true;
  String selectedDish = "Soup dish";
  int selectedPortion = 1;

  final List<String> dishNames = [
    "Soup dish",
    "Chick chok dish",
    "Bilian dish"
  ];

  @override
  void initState() {
    super.initState();
    _menuID = widget.menuId;
    getMenuDetails_();
  }

  Future<void> getMenuDetails_() async {
    final menus = await service.getMenuDetails(_menuID);
    print("data page Two....................${_menuID}");
    setState(() {
      data = menus;
      isLoading = false;
    });
  }

  Future<void> getVideoURL_() async {
    final menus = await service.getVideos(_menuID);
    print(menus);
    setState(() {
      data = menus;
      isLoading = false;
    });
  }

  void updatePortions(int newPortion) {
    setState(() {
      selectedPortion = newPortion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final portions = data["portions"] as List<dynamic>? ?? [];
    final dish = data["dish"] as Map<String, dynamic>? ?? {};
    final imageourl = data["image"];
    print(imageourl);
    print(data);

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
            "Filter Dishes",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.grey,
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
            child: DropdownButtonHideUnderline(
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
                  setState(() {
                    selectedDish = newValue!;
                  });
                },
                items: dishNames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.blue),
                    ),
                  );
                }).toList(),
                dropdownColor: Colors.white,
                isExpanded: true,
              ),
            ),
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
                  "Portions",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      "Number of pax",
                      style: TextStyle(fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.grey,),
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
          padding: const EdgeInsets.only(left:8.0,right: 8),
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
                        child: Text(
                          portion['productName'],
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: portion['multiply']== '1' ?  Text(
                          (int.parse(portion['unitNeeded']
                                      .replaceAll(',', '')) *
                                  selectedPortion)
                              .toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ):Text(
                          (int.parse(portion['unitNeeded']
                                      .replaceAll(',', '')))
                              .toString(),
                          style: const TextStyle(
                            color: Colors.grey,
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
              "Menu Images",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ),
        ]
      ],
    );
  }
}
