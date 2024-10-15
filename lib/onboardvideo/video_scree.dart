import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/onboardvideo/quze.dart';
import 'package:mwave/view/paymet_screen.dart';
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

  bool _isInitialized = false; // New flag to track initialization

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    // Initialize all controllers asynchronously
    _controller1 = VideoPlayerController.asset('assets/images/viddeo1.mp4')
      ..addListener(_checkVideo1Status);

    _controller2 = VideoPlayerController.asset('assets/images/vedio2.mp4')
      ..addListener(_checkVideo2Status);

    _controller3 = VideoPlayerController.asset('assets/images/video3.MP4')
      ..addListener(_checkVideo3Status);

    // Wait for all controllers to initialize
    await Future.wait([
      _controller1.initialize(),
      _controller2.initialize(),
      _controller3.initialize(),
    ]);

    // Ensure the UI updates after initialization
    setState(() {
      _isInitialized = true;
    });

    _showLanguageSelectionDialog();
  }

  void _checkVideo1Status() {
    if (_controller1.value.position == _controller1.value.duration) {
      setState(() {
        _isVideo1Watched = true;
      });
    }
  }

  void _checkVideo2Status() {
    if (_controller2.value.position == _controller2.value.duration) {
      setState(() {
        _isVideo2Watched = true;
      });
    }
  }

  void _checkVideo3Status() {
    if (_controller3.value.position == _controller3.value.duration) {
      setState(() {
        _isVideo3Watched = true;
      });
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('English', 'en'),
              _buildLanguageOption('Tamil', 'ta'),
            ],
          ),
        );
      },
    );
  }

  ListTile _buildLanguageOption(String title, String value) {
    return ListTile(
      title: Text(title),
      leading: Radio<String>(
        value: value,
        groupValue: _selectedLanguage,
        onChanged: (String? newValue) {
          setState(() {
            _selectedLanguage = newValue!;
            Navigator.of(context).pop();
          });
        },
      ),
    );
  }

  void _onQuizSubmitted(int videoNumber) {
    setState(() {
      _currentVideoIndex = videoNumber + 1;
    });

    if (videoNumber == 3) {
      Get.to(QuizScreen(
        videoNumber: videoNumber,
        language: _selectedLanguage,
      ));
    } else {
      Get.to(QuizScreen(
        videoNumber: videoNumber,
        language: _selectedLanguage,
      ));
    }
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
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: kwhite,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: kwhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kblue,
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
            if (isWatched)
              ElevatedButton(
                onPressed: () => _onQuizSubmitted(videoNumber),
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
        ),
      ),
    );
  }
}
