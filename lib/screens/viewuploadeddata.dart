import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mksc_mobile/screens/formdata.dart';
import 'package:mksc_mobile/service/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetData extends StatefulWidget {
  final bool tokenExpired;

  const GetData({Key? key, required this.tokenExpired}) : super(key: key);

  @override
  State<GetData> createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
  List<Map<String, dynamic>>? data;
  final Services _service = Services();
  TextEditingController _dataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    print("widget.tokenExpired.............");
    print(widget.tokenExpired);
    try {
      final jsonData = await _service.getData('daydata');
      setState(() {
        data = List<Map<String, dynamic>>.from(jsonData['data']);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _showMyDialog(item) async {
    print(item['number']);
    print(item);
    // Set the initial value of _dataController
    _dataController.text = item['number'].toString();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Data',
              style: TextStyle(
                  fontSize: 20, color: Color.fromARGB(255, 48, 93, 131))),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text(
                    'Edit data below',
                  ),
                ),
                TextFormField(
                  controller: _dataController,
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
                  style:
                      const TextStyle(color: Color.fromARGB(255, 49, 49, 49)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Data required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10),
                child: Text(
                  'cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                print('Entered data: ${_dataController.text}');
                int newData = int.parse(_dataController.text);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString('token');
                print(item['item']);
                _service.editData(token!, newData, item['item'], item['id']);
                Navigator.of(context).pop();
                fetchData();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(right: 40.0, top: 0),
                  child: Center(
                    child: Text(
                      "Today Uploaded Data",
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ),
                ),
              ),
              if (data != null)
                for (var item in data!)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 2.0, right: 2),
                    child: InkWell(
                      onTap: () {
                        if (widget.tokenExpired == true) {
                          Fluttertoast.showToast(
                              msg: "Please Signin to Edit data",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          _showMyDialog(item);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(255, 99, 175, 236),
                              Color.fromARGB(255, 196, 216, 233),
                            ],
                          ),
                        ),
                        child: ListTile(
                          leading: item['item'].toString() == "cock"
                              ? SvgPicture.asset(
                                  'assets/icons/chicken_.svg',
                                  height: 30,
                                  width: 30,
                                  color: Colors.white,
                                )
                              : item['item'].toString() == "hen"
                                  ? SvgPicture.asset(
                                      'assets/icons/hen.svg',
                                      height: 30,
                                      width: 30,
                                      color: Colors.white,
                                    )
                                  : item['item'].toString() == "eggs"
                                      ? SvgPicture.asset(
                                          'assets/icons/egg.svg',
                                          height: 30,
                                          width: 30,
                                          color: Colors.white,
                                        )
                                      : item['item'].toString() == "chick"
                                          ? SvgPicture.asset(
                                              'assets/icons/chick.svg',
                                              height: 30,
                                              width: 30,
                                              color: Colors.white,
                                            )
                                          : SvgPicture.asset(
                                              'assets/icons/chick.svg',
                                              height: 30,
                                              width: 30,
                                              color: Colors.white,
                                            ),
                          tileColor: Colors.white,
                          title: Text(
                            item['item'].toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white70),
                          ),
                          subtitle: Text(
                            "Collected : ${item['number']}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
              else
                const Padding(
                  padding: EdgeInsets.only(top: 18.0),
                  child: SpinKitThreeBounce(
                    color: Colors.white,
                    size: 40,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
