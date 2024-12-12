import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mwave/onboardvideo/splash_screen.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({Key? key}) : super(key: key);

  @override
  State<VideoSplashScreen> createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    _videoController = VideoPlayerController.asset('assets/images/VID_4649.MP4')
      ..initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: true,
          looping: false, // Set to true if you want the video to loop
          showControls: false, // Hide controls for a splash screen
        );
        setState(() {}); // Update the UI after initialization
      });

    // Navigate to the next screen after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Get.offAll(SplashScreen());
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video background
          _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(controller: _chewieController!)
              : Center(child: CircularProgressIndicator()),

          // Optional overlay (logo, app name, etc.)
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Text(
              'Your App Name',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
