import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';
import 'package:chewie/chewie.dart';

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
  late ChewieController _chewieController;
  final service = Services();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    getMenuDetails_();
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
        _chewieController = ChewieController(
          videoPlayerController: VideoPlayerController.network(newUrl),
          autoInitialize: true,
          autoPlay: true,
          looping: true,
          showControls: true,
        );
      });
    }
  }

  @override
  void dispose() {
    _chewieController.dispose();
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
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: screenWidth - 40,
                      height: screenHeight / 2 - 40,
                      color: Colors.white,
                    ),
                  )
                : AspectRatio(
                    aspectRatio: screenWidth/ (screenHeight / 1.5),
                    child: Chewie(controller: _chewieController),
                  ),
          ],
        ),
      ),
    );
  }
}
