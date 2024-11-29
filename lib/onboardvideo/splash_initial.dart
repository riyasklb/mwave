import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mwave/onboardvideo/splash_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoplashScreen extends StatefulWidget {
  const VideoplashScreen({Key? key}) : super(key: key);

  @override
  State<VideoplashScreen> createState() => _VideoplashScreenState();
}

class _VideoplashScreenState extends State<VideoplashScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    _videoController = VideoPlayerController.asset('assets/images/VID_4649.MP4')
      ..initialize().then((_) {
        // Play video and loop it
      //  _videoController.setLooping(true);
        _videoController.play();
        setState(() {}); // Update the UI after initialization
      });

    // Navigate to next screen after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Get.offAll(SplashScreen());
 
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        //fit: StackFit.expand,
        children: [
          // Video background
          _videoController.value.isInitialized
              ? VideoPlayer(_videoController)
              : Center(child: CircularProgressIndicator()),

          // Overlay for logo or app name
         
        ],
      ),
    );
  }
}
