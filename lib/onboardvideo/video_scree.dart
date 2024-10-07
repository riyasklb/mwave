import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/onboardvideo/quze.dart';
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
  int _currentVideoIndex = 1;
  String _selectedLanguage = 'en'; // Default language

  @override
  void initState() {
    super.initState();

    setDefault();
  }

  setDefault() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
 

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
          _showLanguageSelectionDialog();
    });
  }

  void _showLanguageSelectionDialog() {
    // Show a dialog asking for the language
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English'),
                leading: Radio<String>(
                  value: 'en',
                  groupValue: _selectedLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value!;
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Tamil'),
                leading: Radio<String>(
                  value: 'ta',
                  groupValue: _selectedLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value!;
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
      if (videoNumber == 1) {
        _currentVideoIndex = 2;
      } else if (videoNumber == 2) {
        _currentVideoIndex = 3;
      } else if (videoNumber == 3) {
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
    return Scaffold(
      backgroundColor: kwhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:  kblue,
        title: Text(
          _selectedLanguage == 'en' ? 'Videos' : 'வீடியோக்கள்',
          style: GoogleFonts.lato(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
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
              if (_currentVideoIndex == 1)
                _buildVideoCard(1, _controller1, _isVideo1Watched),
              SizedBox(height: 20),
              if (_currentVideoIndex == 2)
                _buildVideoCard(2, _controller2, _isVideo2Watched),
              SizedBox(height: 20),
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
                  Get.to(
                    QuizScreen(
                      videoNumber: videoNumber,
                      language: _selectedLanguage,
                    ),
                  );
                },
                child: Text(_selectedLanguage == 'en'
                    ? 'Take Quiz for Video $videoNumber'
                    : 'வீடியோ $videoNumber க்கான வினாடி வினா எடுக்கவும்'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
