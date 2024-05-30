import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mksc_mobile/screens/tab_one.dart';
import 'package:mksc_mobile/screens/tab_two.dart';
import 'package:mksc_mobile/service/services.dart';
import 'package:video_player/video_player.dart';
import '../widgets/video_dialog.dart';

class MenuScreen extends StatefulWidget {
  final String? menuId;
  const MenuScreen({Key? key, this.menuId}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late VideoPlayerController _controller;
  late String? _menuID;
  final service = Services();
  String videourl = '';
  @override
  void initState() {
    super.initState();
    _menuID = widget.menuId;
    getMenuDetails_();
    print("video ...............................screen");
    print(videourl);
    _controller = VideoPlayerController.network(videourl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  getMenuDetails_() async {
    print("data tracing  in function....................$_menuID");
    final menus = await service.getMenuDetails(_menuID);

    setState(() {
      videourl = menus["video"];
    });
    return menus["video"];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
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
            bottom: const TabBar(
              indicatorColor: Colors.orange,
              indicatorWeight: 2,
              tabs: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Portion Configurations',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Recipe',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            title: const Text(
              'Menu Screen',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          body: TabBarView(
            children: [
              MenuTab1(menuId: _menuID ?? ""),
              SecondTab(menuId: _menuID ?? ""),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 35.0, right: 10),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return VideoDialog(
                        controller: _controller, menuId: _menuID ?? "");
                  },
                );
              },
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.ondemand_video,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        ),
      ),
    );
  }
}
