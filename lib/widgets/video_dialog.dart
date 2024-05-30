import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';

import '../service/services.dart';

class VideoDialog extends StatefulWidget {
  final VideoPlayerController controller;
  String menuId;
  VideoDialog({Key? key, required this.controller, required this.menuId})
      : super(key: key);

  @override
  _VideoDialogState createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  late bool _isLoading;
  late String? _menuID;
  VideoPlayerController? _controller;
  final service = Services();
  String? videoURL;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _menuID = widget.menuId;
    getVideoURL_();
  }

  Future<void> getVideoURL_() async {
    print("function called......................$_menuID");
    final menus = await service.getVideos(4);
    setState(() {
      videoURL = menus;
      if (videoURL != null) {
        _controller = VideoPlayerController.network(videoURL!)
          ..initialize().then((_) {
            _isLoading = false;
            setState(() {
            });
          });
      } else {
        _isLoading = false;
      }
    });
    print("Videos page ....................");
    print(_controller
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      child: Container(
        width: screenWidth,
        height: screenHeight / 2,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            _isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 300,
                      height: screenHeight / 3,
                      color: Colors.white,
                    ),
                  )
                : _controller != null && _controller!.value.isInitialized
                    ? Column(
                        children: [
                          AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          ),
                          SizedBox(height: 20),
                          Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.lightBlue,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: Icon(
                                _controller!.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                              color: Colors.white,
                              onPressed: () {
                                setState(() {
                                  _controller!.value.isPlaying
                                      ? _controller!.pause()
                                      : _controller!.play();
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}