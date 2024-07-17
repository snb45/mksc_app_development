import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mksc_mobile/service/services.dart';
import 'package:mksc_mobile/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaundryScreen extends StatefulWidget {
  @override
  State<LaundryScreen> createState() => _LaundryScreenState();
}

class _LaundryScreenState extends State<LaundryScreen> {
  final Services _serv = Services();

  Future<String?> getCampType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? campType = prefs.getString('selectedCamp');
    return campType;
  }

  TextEditingController controller = TextEditingController();
  TextEditingController editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var selectedCamp = getCampType();
    return Scaffold(
      appBar: AppBar(
        title: Text('Laundry', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
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
                child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Laundry data ",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FutureBuilder(
                    future: () async {
                      String? camp = await selectedCamp;
                      return _serv.getLaundryTodayData(camp);
                    }(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return FutureBuilder(
                          future: _serv.getMachineSize(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<String>> snapshot2) {
                            if (snapshot2.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot2.hasError) {
                              return Text('Error: ${snapshot2.error}');
                            } else {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: snapshot2.data!.map((machineSize) {
                                  return Container(
                                      width: 150,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: snapshot.data!.any(
                                                  (item) =>
                                                      item['machineType'] ==
                                                      machineSize)
                                              ? Color.fromARGB(255, 180, 132, 2)
                                              : Colors.white,
                                          foregroundColor: snapshot.data!.any(
                                                  (item) =>
                                                      item['machineType'] ==
                                                      machineSize)
                                              ? Colors.white
                                              : Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                        child:
                                            Text(Utils.capitalize(machineSize)),
                                        onPressed: snapshot.data!.any((item) =>
                                                item['machineType'] ==
                                                machineSize)
                                            ? null
                                            : () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Enter the number of circles'),
                                                      content: TextField(
                                                        controller: controller,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Number of circles',
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('Cancel'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text('Save'),
                                                          onPressed: () async {
                                                            int numberOfCircles =
                                                                int.parse(
                                                                    controller
                                                                        .text);

                                                            if (await _serv
                                                                .storeLaundryData(
                                                                    numberOfCircles,
                                                                    machineSize)) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                          content:
                                                                              Text('Data saved successfully')));
                                                              setState(() {});
                                                            } else {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(SnackBar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      content: Text(
                                                                          'Error saving data. Please try again later')));
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                      ));
                                }).toList(),
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Todays Data',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  FutureBuilder(
                    future: () async {
                      String? camp = await selectedCamp;
                      return _serv.getLaundryTodayData(camp);
                    }(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Container(
                          height: 500,
                          child: ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            Text('Edit the number of circles'),
                                        content: TextField(
                                          controller: editController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: 'Number of circles',
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Save'),
                                            onPressed: () async {
                                              // Save the number of circles
                                              int numberOfCircles = int.parse(
                                                  editController.text);
                                              if (await _serv.updateLaundryData(
                                                  numberOfCircles,
                                                  snapshot.data[index]
                                                      ['machineType'],
                                                  snapshot.data[index]['id'])) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Data updated successfully')));
                                                Navigator.of(context).pop();
                                                setState(() {});
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        content: Text(
                                                            'Error Updated Data. Please try again later')));
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.local_laundry_service,
                                    color: Colors.black38,
                                    size: 30,
                                  ),
                                  title: Text(Utils.capitalize(
                                      snapshot.data[index]['machineType'])),
                                  subtitle: Text(
                                    'Circles: ${snapshot.data[index]['circle']}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ),
                              );
                              ;
                            },
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }
}
