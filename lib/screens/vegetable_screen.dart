import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mksc_mobile/service/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class VegetableScreen extends StatefulWidget {
  final String title;
  const VegetableScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<VegetableScreen> createState() => _VegetableScreenState();
}

class _VegetableScreenState extends State<VegetableScreen> {
  List<Map<String, dynamic>>? data;
  List<Map<String, dynamic>>? todaydata;
  final Services _service = Services();
  bool isLoading = false;
  bool isauthLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchAvailableData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final jsonData = await _service.getVegetableList();
      setState(() {
        data = List<Map<String, dynamic>>.from(jsonData['data']);
        print("listed data ....................${data}");
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAvailableData() async {
    try {
      final jsonData = await _service.getAvailableVegetableList();
      setState(() {
        todaydata = List<Map<String, dynamic>>.from(jsonData['data']);
        print("incoming data ...............${todaydata}");
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
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
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
        ),
        const SizedBox(
          height: 20,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
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
        ),
        const SizedBox(
          height: 10,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
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
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildCardShimmer() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 7, bottom: 7),
      child: _buildShimmerEffect(),
    );
  }

  _showTwoStepModal(selectedname) {
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
              titlePadding: EdgeInsets.zero,
              title: Container(
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28))),
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Add $selectedname Data',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
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

                          final enteredData = int.tryParse(codeController.text);
                          if (enteredData == '' || enteredData == null) {
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
                          } else {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            setState(() {
                              token = prefs.getString('token');
                            });
                          }

                          final resp = await _service.postData(
                              token!,
                              widget.title,
                              enteredData,
                              selectedname.toLowerCase());
                          if (resp) {
                            fetchData();
                            fetchAvailableData();
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

  void _showEditModal(String selectedname, String selectedvalue, int itemid) {
    print("itemid .............................");
    print(itemid);
    TextEditingController codeController =
        TextEditingController(text: selectedvalue.toString());
    bool isSubmitButtonLoading = false;
    String? token;
    bool hasChanged = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            codeController.addListener(() {
              if (codeController.text != selectedvalue) {
                setState(() {
                  hasChanged = true;
                });
              } else {
                setState(() {
                  hasChanged = false;
                });
              }
            });

            return AlertDialog(
              titlePadding: EdgeInsets.zero,
              title: Container(
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28))),
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Edit $selectedname Data',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: codeController,
                    decoration: const InputDecoration(labelText: 'Edit data'),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: (!hasChanged || isSubmitButtonLoading)
                      ? null
                      : () async {
                          setState(() {
                            isSubmitButtonLoading = true;
                          });

                          final enteredData = int.tryParse(codeController.text);
                          if (enteredData == '' || enteredData == null) {
                            Fluttertoast.showToast(
                                msg: "Please change to update",
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
                          print("Data Updated: $enteredData");
                          if (widget.title == "Vegetable") {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            setState(() {
                              token = prefs.getString('vegetabletoken');
                            });
                          } else {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            setState(() {
                              token = prefs.getString('token');
                            });
                          }

                          final resp = await _service.editVegetableData(
                            token!,
                            widget.title,
                            enteredData,
                            selectedname.toLowerCase(),
                            itemid
                          );
                          if (resp) {
                            fetchData();
                            fetchAvailableData();
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(
                                msg: "Successfully Updated!",
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
                      : const Text('Update'),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 120.0),
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
                          "Welcome to the Vegetable Data Management",
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
                        'Please wait ....',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    item["image"] != null && item["image"] != ""
                                        ? Image.network(
                                            item["image"]!,
                                            width: 140,
                                            height: 140,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 70.0, left: 15),
                                                child: Icon(
                                                  Icons.image,
                                                  size: 50,
                                                  color: Colors.blue[300],
                                                ),
                                              );
                                            },
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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  // const Text("Click to feed data"),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      MaterialButton(
                                        elevation: 0.5,
                                        onPressed: () {
                                          bool isDataAvailable = todaydata?.any(
                                                  (element) =>
                                                      element['item'] ==
                                                      item['name']) ??
                                              false;
                                          if (isDataAvailable) {
                                            _showEditModal(
                                                " ${item["name"]}",
                                                todaydata?.firstWhere(
                                                    (element) =>
                                                        element['item'] ==
                                                        item['name'])['number'],
                                                todaydata?.firstWhere(
                                                    (element) =>
                                                        element['item'] ==
                                                        item['name'])['id']);
                                          } else {
                                            _showTwoStepModal(
                                                "${item["name"]}");
                                          }
                                        },
                                        color: todaydata?.any((element) =>
                                                    element['item'] ==
                                                    item['name']) ??
                                                false
                                            ? Colors.orange
                                            : Colors.blue,
                                        textColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          todaydata?.any((element) =>
                                                      element['item'] ==
                                                      item['name']) ??
                                                  false
                                              ? "Edit Data"
                                              : "Add Data",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      if (todaydata?.any((element) =>
                                              element['item'] ==
                                              item['name']) ??
                                          false)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, bottom: 4),
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                // Use the number value from the response
                                                todaydata?.firstWhere(
                                                    (element) =>
                                                        element['item'] ==
                                                        item['name'])['number'],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
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
          ),
        ],
      ),
    );
  }
}
