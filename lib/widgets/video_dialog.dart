import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../modals/menu_modal.dart';
import '../service/services.dart';

class VideoDialog extends StatefulWidget {
  final String menuId;

  VideoDialog({
    Key? key,
    required this.menuId,
  }) : super(key: key);

  @override
  _VideoDialogState createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  late bool _isLoading;
  late YoutubePlayerController _youtubeController;
  final service = Services();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    getMenuDetails_();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  Future<void> getMenuDetails_() async {
    final menuModel = Provider.of<MenuModel>(context, listen: false);
    menuModel.setLoading(false);
    updateVideoUrl(menuModel.data['video']);
  }

  void updateVideoUrl(String? newUrl) {
    if (newUrl != null) {
      setState(() {
        _isLoading = false;
        _youtubeController = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(newUrl)!,
          flags: YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height / 2;

    return Dialog(
      child: Container(
        width: screenWidth,
        height: screenHeight,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : YoutubePlayer(
  controller: _youtubeController,
  showVideoProgressIndicator: true,
  onReady: () {
    _youtubeController.addListener(() {
      if (!_youtubeController.value.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  },
),
          ],
        ),
      ),
    );
  }
}
