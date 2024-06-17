import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mksc_mobile/screens/vegetable_screen.dart';
import 'package:mksc_mobile/screens/viewuploadeddata.dart';
import 'package:mksc_mobile/service/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
// widget.title == 'Vegetable'
import '../modals/itemcategory.dart';
import '../widgets/dropdownbutton.dart';

class AddData extends StatefulWidget {
  const AddData({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _countController = TextEditingController();
  bool tokenExpired = false;
  int _currentStep = 0;
  final Services _serv = Services();
  bool isLoading = false;
  String token = '';
  bool showFail = false;
  final _formKey = GlobalKey<FormState>();
  int selectedIndex = -1;
  String selectedCategory = "";
  List<Map<String, dynamic>>? data;

  final List<ItemCategory> categories = [
    ItemCategory(svgicon: 'assets/icons/chicken_.svg', name: 'Cock'),
    ItemCategory(svgicon: 'assets/icons/hen.svg', name: 'Hen'),
    ItemCategory(svgicon: 'assets/icons/chick.svg', name: 'Chick'),
    ItemCategory(svgicon: 'assets/icons/egg.svg', name: 'eggs'),
  ];
  String selectedData = "All Data";
  bool isDropdownVisible = false;

  Future<void> checkData() async {
    try {
      final jsonData = await _serv.getData('daydata');
      setState(() {
        data = List<Map<String, dynamic>>.from(jsonData['data']);
        print("data ...................................");
        print(data);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void showDropdown() {
    setState(() {
      isDropdownVisible = !isDropdownVisible;
    });
  }

  saveData(codeNo, dataCount, selectedCategory) async {
    String category = widget.title;
    int? data = int.tryParse(dataCount);
    String modifiedselectedCategory = selectedCategory.toLowerCase();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (modifiedselectedCategory != '' && dataCount != '') {
      _serv
          .postData(token!, widget.title, data!, modifiedselectedCategory)
          .then((result) {
        setState(() {
          isLoading = false;
        });
        if (result) {
          print("Authentication successful!");
          Fluttertoast.showToast(
              msg: "Successfully Saved",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AddData(title: 'Chicken House'),
            ),
          );
          _countController.clear();
        } else {
          setState(() {
            isLoading = false;
            showFail = true;
          });
        }
      });
    }
    // if (tokenExpired == true) {
    //   if (codeNo != '' && dataCount != '') {
    //     _serv
    //         .authenticateUser(
    //             context, category, codeNo, data!, modifiedselectedCategory)
    //         .then((result) {
    //       setState(() {
    //         isLoading = false;
    //       });
    //       print("response data ----------------- $result");

    //       if (result.success) {
    //         print("Authentication successful! Token: ${result.data}");
    //         Fluttertoast.showToast(
    //             msg: "Successfully Saved",
    //             toastLength: Toast.LENGTH_SHORT,
    //             gravity: ToastGravity.BOTTOM,
    //             timeInSecForIosWeb: 1,
    //             backgroundColor: Colors.green,
    //             textColor: Colors.white,
    //             fontSize: 16.0);
    //         _countController.clear();
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AddData(title: 'Chicken House'),
    //   ),
    // );
    //       } else {
    //         setState(() {
    //           isLoading = false;
    //           showFail = true;
    //         });
    //       }
    //     });
    //   }
    // } else {

    // }
  }

  @override
  void initState() {
    super.initState();
    checkTokenExpiry();
    checkData();
  }

  Future<void> checkTokenExpiry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = widget.title == "Vegetable"
        ? prefs.getString('vegetabletoken')
        : prefs.getString('token');

    String? savedTimeString = widget.title == "Vegetable"
        ? prefs.getString('vegetablecurrentTime')
        : prefs.getString('currentTime');

    print("token check here...................................");
    print(token);
    print(savedTimeString);

    if (savedTimeString == null || savedTimeString.isEmpty) {
      print("in i am now =============================>");
      DateTime defaultSavedTime = DateTime.now().subtract(Duration(hours: 4));
      savedTimeString = defaultSavedTime.toIso8601String();
      await prefs.setString('currentTime', savedTimeString);
      print(
          "Saved Time String set to default 4 hours earlier: $savedTimeString");
    }

    if (token != null && token.isNotEmpty) {
      print("am in now ...............................");

      try {
        DateTime savedTime = DateTime.parse(savedTimeString);
        DateTime currentTime = DateTime.now();
        print("Timesaved Time ...................");
        print(savedTime);
        // Check if the difference between current time and saved time is more than 3 hours
        if (currentTime.difference(savedTime).inHours > 3) {
          print("time excuted ...................");
          print(savedTime);
          // Clear token and time if expired
          if (widget.title == "Vegetable") {
            await prefs.setString('vegetabletoken', '');
            await prefs.setString('vegetablecurrentTime', '');
          } else {
            await prefs.setString('token', '');
            await prefs.setString('currentTime', '');
          }

          setState(() {
            tokenExpired = true;
            _currentStep = 0;
          });
        } else {
          setState(() {
            tokenExpired = false;
            _currentStep = 1;
          });
        }
      } catch (e) {
        print("Error parsing saved time: $e");
        setState(() {
          tokenExpired = true;
          _currentStep = 0;
        });
      }
    } else {
      print("Token is null or empty.");
      setState(() {
        tokenExpired = true;
        _currentStep = 0;
      });
    }
  }

  bool isCategoryMatched(String categoryName) {
    if (data != null) {
      for (var item in data!) {
        if (item['item'].toString().toLowerCase() ==
            categoryName.toLowerCase()) {
          return true;
        }
      }
    }
    return false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [],
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue,
                  Color.fromARGB(255, 196, 216, 233),
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.title == 'Vegetable' && _currentStep == 1) ...[
                      //implementation for vegetable List
                      const SizedBox(height: 10),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.transparent,
                        child: VegetableScreen(
                          title: widget.title,
                        ),
                      )
                    ],
                    if (tokenExpired == true && _currentStep == 0) ...[
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Chicken House",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Enter Code to Input Data for ${widget.title}",
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white70,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            hintText: 'Enter Code',
                            hintStyle: TextStyle(color: Colors.white60),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 49, 49, 49)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your code';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_currentStep < 1) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                final resp = await _serv.authentication(context,
                                    widget.title, _codeController.text);
                                if (resp != null || resp != '') {
                                  setState(() {
                                    token = resp;
                                  });
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (_currentStep < 2) {
                                    setState(() {
                                      _currentStep += 1;
                                    });
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Authentication failed!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              }
                            },
                            child: const Text('Continue'),
                          ),
                        ),
                      ],
                    ],

                    if (_currentStep >= 1 && widget.title != "Vegetable") ...[
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Select Item To Add Data ",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.13,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                              childAspectRatio:
                                  MediaQuery.of(context).size.width /
                                      (MediaQuery.of(context).size.height / 8),
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final categoryName = categories[index].name;
                              final isMatched = isCategoryMatched(categoryName);
                              return GestureDetector(
                                onTap: isMatched
                                    ? null
                                    : () {
                                        setState(() {
                                          selectedIndex = index;
                                          selectedCategory = categoryName;
                                          _currentStep += 1;
                                        });
                                      },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blue.withOpacity(0),
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: isMatched
                                        ? Colors.orange.withOpacity(0.7)
                                        : selectedIndex == index
                                            ? Colors.orange.withOpacity(0.7)
                                            : Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 18.0),
                                          child: SvgPicture.asset(
                                            categories[index].svgicon,
                                            height: 20,
                                            width: 20,
                                            color: isMatched
                                                ? Colors.white
                                                : selectedIndex == index
                                                    ? Colors.white
                                                    : Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(height: 18.0),
                                        Text(
                                          categoryName,
                                          style: TextStyle(
                                              color: isMatched
                                                  ? Colors.white
                                                  : selectedIndex == index
                                                      ? Colors.white
                                                      : Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                    if (_currentStep >= 2 && widget.title != "Vegetable") ...[
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Enter data for ${widget.title}",
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white70,
                              fontWeight: FontWeight.w200),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _countController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            //  labelText: 'Enter data',
                            // labelStyle: TextStyle(color: Color.fromARGB(211, 65, 156, 230)),
                            hintText: 'Enter data',
                            hintStyle: TextStyle(color: Colors.white60),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 49, 49, 49)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter ${widget.title} data';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_currentStep > 0) {
                                    setState(() {
                                      _currentStep -= 1;
                                    });
                                  }
                                }
                              },
                              child: const Text('Back'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  saveData(_codeController.text,
                                      _countController.text, selectedCategory);
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ],
                        ),
                      ),
                    ],
                    //implementation for data views
                    if (widget.title != "Vegetable") ...[
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 400,
                          color: Colors.transparent,
                          child: GetData(tokenExpired: tokenExpired),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Positioned(
              bottom: 20.0,
              left: MediaQuery.of(context).size.width / 2 - 25.0,
              child: Container(
                child: const Center(
                  child: SpinKitCircle(
                    color: Colors.white,
                    size: 40.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
