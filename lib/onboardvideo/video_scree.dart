import 'package:flutter/material.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/onboardvideo/quze.dart';
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
  bool _isVideo1Visible = true;
  bool _isVideo2Visible = true;
  bool _isVideo3Visible = true;

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

  Widget buildVideoPlayer(VideoPlayerController controller) {
    return controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          )
        : Center(child: CircularProgressIndicator());
  }

  void _onQuizSubmitted(int videoNumber) {
    // Hide the video after the quiz is submitted
    setState(() {
      if (videoNumber == 1) {
        _isVideo1Visible = false;
      } else if (videoNumber == 2) {
        _isVideo2Visible = false;
      } else if (videoNumber == 3) {
        _isVideo3Visible = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Videos',
          style: TextStyle(color: kwhite),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
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
              // Video 1
              if (_isVideo1Visible)
                _buildVideoCard(1, _controller1, _isVideo1Watched),
              SizedBox(height: 20),
              // Video 2
              if (_isVideo2Visible)
                _buildVideoCard(2, _controller2, _isVideo2Watched),
              SizedBox(height: 20),
              // Video 3
              if (_isVideo3Visible)
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
                  // Handle quiz submission
                  _onQuizSubmitted(videoNumber); // Hide the video
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QuizScreen(videoNumber: videoNumber),
                    ),
                  );
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
