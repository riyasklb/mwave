import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/onboardvideo/quze.dart';
import 'package:mwave/view/bottum_nav_bar.dart';
import 'package:mwave/view/bottumbar1.dart';
import 'package:video_player/video_player.dart';

class VideoSelectionScreen extends StatefulWidget {
  @override
  _VideoSelectionScreenState createState() => _VideoSelectionScreenState();
}

class _VideoSelectionScreenState extends State<VideoSelectionScreen> {
  late VideoPlayerController _controller1;
  late VideoPlayerController _controller2;
  late VideoPlayerController _controller3;
  bool _isVideo1Watched = false;
  bool _isVideo2Watched = false;
  bool _isVideo3Watched = false;

  // State variables to control video visibility
  int _currentVideoIndex = 1; // Controls which video is shown

  @override
  void initState() {
    super.initState();

    // Initialize the video players for each video
    _controller1 = VideoPlayerController.asset('assets/images/viddeo1.mp4')
      ..initialize().then((_) => setState(() {}))
      ..addListener(() {
        if (_controller1.value.position == _controller1.value.duration) {
          setState(() {
            _isVideo1Watched = true;
          });
        }
      });

    _controller2 = VideoPlayerController.asset('assets/images/vedio2.mp4')
      ..initialize().then((_) => setState(() {}))
      ..addListener(() {
        if (_controller2.value.position == _controller2.value.duration) {
          setState(() {
            _isVideo2Watched = true;
          });
        }
      });

    _controller3 = VideoPlayerController.asset('assets/images/video3.mp4')
      ..initialize().then((_) => setState(() {}))
      ..addListener(() {
        if (_controller3.value.position == _controller3.value.duration) {
          setState(() {
            _isVideo3Watched = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  void _onQuizSubmitted(int videoNumber) {
    setState(() {
      // After each quiz submission, show the next video
      if (videoNumber == 1) {
        _currentVideoIndex = 2;
      } else if (videoNumber == 2) {
        _currentVideoIndex = 3;
      } else if (videoNumber == 3) {
        // After the third video quiz submission, navigate to home or perform another action
        Get.to(BottumNavBar());
      }
    });
  }

  Widget buildVideoPlayer(VideoPlayerController controller) {
    return controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          )
        : Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: kwhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,  backgroundColor: const Color(0xFF6A00D7), 
        title: Text(
          'Videos',
          style: GoogleFonts.lato(
      fontSize: 24.sp, // Adjust the font size as needed
      fontWeight: FontWeight.bold, // Bold text
      color: Colors.white, // Text color
      letterSpacing: 1.2, // Adds a little spacing between letters
    ),
        ),
        centerTitle: true,

      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Display video 1 only if _currentVideoIndex is 1
              if (_currentVideoIndex == 1)
                _buildVideoCard(1, _controller1, _isVideo1Watched),
              SizedBox(height: 20),

              // Display video 2 only if _currentVideoIndex is 2
              if (_currentVideoIndex == 2)
                _buildVideoCard(2, _controller2, _isVideo2Watched),
              SizedBox(height: 20),

              // Display video 3 only if _currentVideoIndex is 3
              if (_currentVideoIndex == 3)
                _buildVideoCard(3, _controller3, _isVideo3Watched),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoCard(
      int videoNumber, VideoPlayerController controller, bool isWatched) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildVideoPlayer(controller),
            IconButton(
              icon: Icon(
                controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.blueAccent,
                size: 32,
              ),
              onPressed: () {
                setState(() {
                  controller.value.isPlaying
                      ? controller.pause()
                      : controller.play();
                });
              },
            ),
            if (isWatched) ...[
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _onQuizSubmitted(videoNumber);
                Get.to( QuizScreen(videoNumber: videoNumber),);
                },
                child: Text('Take Quiz for Video $videoNumber'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ), // Text color
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
