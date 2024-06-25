import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mksc_mobile/screens/viewdata.dart';

import '../modals/grid_item.dart';
import '../widgets/grid_item_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _greetUser() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<GridItem> modules = [
      GridItem(svgicon: 'assets/icons/chicken_.svg', title: 'Chicken House'),
      // GridItem(svgicon: 'assets/icons/menu.svg', title: 'Menu'),
      // GridItem(svgicon: 'assets/icons/vegetables.svg', title: 'Vegetable'),
      // GridItem(svgicon: 'assets/icons/laundry.svg', title: 'Laundry'),
      // GridItem(svgicon: 'assets/icons/beverage.svg', title: 'Beverage'),
      // GridItem(svgicon: 'assets/icons/bed.svg', title: 'Lodge Rooms'),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: MediaQuery.of(context).size.width,
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
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: 40,
                  left: 10,
                  child: CircleAvatar(
                    
                    backgroundColor: Color.fromRGBO(218, 242, 250, 1),
                    radius: 28,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        
                      ),
                    ),
                  )),
              Positioned(
                top: MediaQuery.of(context).size.height / 6.5,
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height / 1.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        _greetUser(), // Updated to call the greeting function
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 2.0, left: 10),
                      child: Text(
                        "Welcome to MKSC Official Data Collection App",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w200),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: Card(
                          color: const Color.fromRGBO(218, 242, 250, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Export All Module Summary Reports",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  // Icon(
                                  //   Ionicons.paper_plane,
                                  //   color: Colors.green,
                                  //   size: 20,
                                  // ),
                                  Text(
                                    "Report",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.yellow[600],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const ViewData(
                                                title: '',
                                              )),
                                    );
                                  },
                                  child: const Text(
                                    "Export PDF",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.58,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(218, 242, 250, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            itemCount: modules.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            itemBuilder: (context, index) {
                              return GridItemWidget(item: modules[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
