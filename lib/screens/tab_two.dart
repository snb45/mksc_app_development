// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_html/flutter_html.dart';
import '../service/services.dart';

class SecondTab extends StatefulWidget {
  final String? menuId;
  const SecondTab({Key? key, this.menuId}) : super(key: key);

  @override
  State<SecondTab> createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> {
  late String? _menuID;
  final service = Services();
  late Map<String, dynamic> data = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _menuID = widget.menuId;
    getMenuDetails_();
  }

  Future<void> getMenuDetails_() async {
    final menus = await service.getMenuDetails(_menuID);
    setState(() {
      data = menus;
      isLoading = false;
    });
  }

  Future<void> getVideoURL_() async {
    final menus = await service.getVideos(_menuID);
    print("Videos page ....................");
    print(menus);
    setState(() {
      data = menus;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final portions = data["portions"] as List<dynamic>? ?? [];
    final dish = data["dish"] as Map<String, dynamic>? ?? {};

    return Scaffold(
      body: SingleChildScrollView(
        child:
            isLoading ? _buildShimmerLoading() : _buildContent(portions, dish),
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

  Widget _buildContent(List<dynamic> portions, Map<String, dynamic> dish) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Recipe Details",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
        ),
        if (dish.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              constraints: BoxConstraints(
                minHeight: 200,
                minWidth: MediaQuery.of(context).size.width,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 227, 230, 233),
                    Color.fromARGB(255, 196, 216, 233),
                  ],
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Html(
                      data: dish['recipe'],
                      style: {
                        'body': Style(color: Colors.grey),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Tableware",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
        ),
        if (dish.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              constraints: BoxConstraints(
                minHeight: 100,
                minWidth: MediaQuery.of(context).size.width,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 227, 230, 233),
                    Color.fromARGB(255, 196, 216, 233),
                  ],
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Html(
                      data: dish['tableware'],
                      style: {
                        'body': Style(color: Colors.grey),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Utensils",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
        ),
        if (dish.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              constraints: BoxConstraints(
                minHeight: 100,
                minWidth: MediaQuery.of(context).size.width,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 227, 230, 233),
                    Color.fromARGB(255, 196, 216, 233),
                  ],
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Html(
                      data: dish['utensils'],
                      style: {
                        'body': Style(color: Colors.grey),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
