import 'package:flutter/material.dart';
import 'package:mksc_mobile/modules/menu/video_screen.dart';
import 'package:provider/provider.dart';
import 'package:mksc_mobile/screens/tab_one.dart';
import 'package:mksc_mobile/screens/tab_two.dart';
import 'package:mksc_mobile/service/services.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../modals/menu_modal.dart';
import '../widgets/video_dialog.dart';

class MenuScreen extends StatefulWidget {
  final String? menuId;
  const MenuScreen({Key? key, this.menuId}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  final service = Services();

  @override
  void initState() {
    super.initState();
    final menuModel = Provider.of<MenuModel>(context, listen: false);
    menuModel.setMenuID(widget.menuId);
    getMenuDetails_();
  }

  Future<void> getMenuDetails_() async {
    final menuModel = Provider.of<MenuModel>(context, listen: false);
    final menus = await service.getMenuDetails(menuModel.menuID);
    menuModel.setData(menus);
    menuModel.setLoading(false);

    updateVideoUrl(menuModel.data['video']);
  }

  void updateVideoUrl(String? newUrl) {
    if (newUrl != null) {
      _videoPlayerController?.dispose();
      _videoPlayerController = VideoPlayerController.network(newUrl)
        ..initialize().then((_) {
          setState(() {});
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController!,
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            autoPlay: true,
            looping: true,
          );
        });
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
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
              MenuTab1(),
              SecondTab(),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 35.0, right: 10),
            child: Consumer<MenuModel>(
              builder: (context, menuModel, child) {
                if (menuModel.data['video'] == null ||
                    menuModel.data['video'] == '') {
                  return Container();
                }

                return FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoScreen(
                          menuId: menuModel.data['video'] ?? '',
                        ),
                      ),
                    );
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(
                    Icons.ondemand_video,
                    size: 30,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        ),
      ),
    );
  }
}
