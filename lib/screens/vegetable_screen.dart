// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mksc_mobile/service/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package

class VegetableScreen extends StatefulWidget {
  final String title;
  const VegetableScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<VegetableScreen> createState() => _VegetableScreenState();
}

class _VegetableScreenState extends State<VegetableScreen> {
  List<Map<String, dynamic>>? data;
  final Services _service = Services();
  bool isLoading = false;
  bool isauthLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final jsonData = await _service.getVegetableList();
      setState(() {
        data = List<Map<String, dynamic>>.from(jsonData['data']);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildShimmerEffect() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width,
          height: 140,
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 150, 193, 228)!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width,
          height: 140,
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 150, 193, 228)!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width,
          height: 140,
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 150, 193, 228)!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width,
          height: 140,
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 150, 193, 228)!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardShimmer() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 7, bottom: 7),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.white,
              Color.fromARGB(255, 150, 193, 228),
            ],
          ),
        ),
        constraints: const BoxConstraints(minHeight: 150.0),
        width: MediaQuery.of(context).size.width,
        child: _buildShimmerEffect(),
      ),
    );
  }

  void _showTwoStepModal(selectedname) {
    TextEditingController codeController = TextEditingController();
    TextEditingController dataController = TextEditingController();
    bool isCodeVerified = false;
    bool isButtonLoading = false;
    bool isSubmitButtonLoading = false;
    String? token;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Enter $selectedname Data'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: codeController,
                    decoration: const InputDecoration(labelText: 'Enter data'),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: isSubmitButtonLoading
                      ? null
                      : () async {
                          setState(() {
                            isSubmitButtonLoading = true;
                          });
                          // Parse the dataController.text to an integer
                          final enteredData = int.tryParse(codeController.text);
                          if (enteredData == '' || enteredData == null) {
                            // Handle parsing error if input is not a valid integer
                            Fluttertoast.showToast(
                                msg: "Please enter a valid integer",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            setState(() {
                              isSubmitButtonLoading = false;
                            });
                            return;
                          }

                          // Handle data submission
                          print("Data Entered: $enteredData");
                          if (widget.title == "Vegetable") {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            setState(() {
                              token = prefs.getString('vegetabletoken');
                            });

                            print(
                                "vegetabletoken ..........................${token}");
                          } else {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            setState(() {
                              token = prefs.getString('token');
                            });

                            print("token ..........................${token}");
                          }
                          print("here i am ..........................${token}");
                          final resp = await _service.postData(token!, "",
                              enteredData, selectedname.toLowerCase());
                          if (resp) {
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(
                                msg: "Successfully saved!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(
                                msg: "Failed to save data",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                          setState(() {
                            isSubmitButtonLoading = false;
                          });
                        },
                  child: isSubmitButtonLoading
                      ? const SpinKitChasingDots(
                          color: Colors.blue,
                        )
                      : const Text('Save Data'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   title: Text(
      //     widget.title,
      //     style: const TextStyle(color: Colors.white),
      //   ),
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.arrow_back,
      //       color: Colors.white,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   actions: [],
      // ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: const Center(
                  child: Text(
                    "Select Vegetable to Fill Data",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ),
            if (isLoading)
              _buildCardShimmer()
            else if (data == null || data!.isEmpty)
              const Center(
                child: Text(
                  'No data available',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            else
              for (final item in data!)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10, top: 7, bottom: 7),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white,
                          Color.fromARGB(255, 150, 193, 228),
                        ],
                      ),
                    ),
                    constraints: const BoxConstraints(minHeight: 150.0),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Show Image, Image icon, or shimmer effect to handle null value or empty image
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: item["image"] != null && item["image"] != ""
                              ? Image.network(
                                  item["image"]!,
                                  width: 140,
                                  height: 140,
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      right: 70.0, left: 15),
                                  child: Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.blue[300],
                                  ),
                                ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["name"] ?? 'Unknown',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const Text("Click to feed data"),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                MaterialButton(
                                  elevation: 0.5,
                                  onPressed: () {
                                    _showTwoStepModal(item["name"]);
                                  },
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Add Data",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
