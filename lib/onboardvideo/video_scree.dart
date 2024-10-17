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
  bool _isInitialized = false; // Track initialization

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    _controller1 = VideoPlayerController.asset('assets/images/viddeo1.mp4')
      ..addListener(_checkVideo1Status);
    _controller2 = VideoPlayerController.asset('assets/images/vedio2.mp4')
      ..addListener(_checkVideo2Status);
    _controller3 = VideoPlayerController.asset('assets/images/video3.MP4')
      ..addListener(_checkVideo3Status);

    await Future.wait([
      _controller1.initialize(),
      _controller2.initialize(),
      _controller3.initialize(),
    ]);

    setState(() {
      _isInitialized = true;
    });

    _showLanguageSelectionDialog();
  }

  void _checkVideo1Status() {
    if (_controller1.value.position == _controller1.value.duration) {
      setState(() => _isVideo1Watched = true);
    }
  }

  void _checkVideo2Status() {
    if (_controller2.value.position == _controller2.value.duration) {
      setState(() => _isVideo2Watched = true);
    }
  }

  void _checkVideo3Status() {
    if (_controller3.value.position == _controller3.value.duration) {
      setState(() => _isVideo3Watched = true);
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
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Select Language',
            style: GoogleFonts.lato(fontSize: 20.sp, fontWeight: FontWeight.w600),
          ),
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
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16.sp),
      ),
      leading: Radio<String>(
        value: value,
        groupValue: _selectedLanguage,
        onChanged: (newValue) {
          setState(() {
            _selectedLanguage = newValue!;
            Navigator.of(context).pop();
          });
        },
      ),
    );
  }

  void _onQuizSubmitted(int videoNumber) {
    setState(() => _currentVideoIndex = videoNumber + 1);
    Get.to(
      QuizScreen(videoNumber: videoNumber, language: _selectedLanguage),
    );
  }

  Widget buildVideoPlayer(VideoPlayerController controller) {
    return controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: VideoPlayer(controller),
            ),
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
        backgroundColor: kblue,
        title: Text(
          _selectedLanguage == 'en' ? 'Videos' : 'வீடியோக்கள்',
          style: GoogleFonts.lato(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_currentVideoIndex == 1)
                _buildVideoCard(1, _controller1, _isVideo1Watched),
              SizedBox(height: 20.h),
              if (_currentVideoIndex == 2)
                _buildVideoCard(2, _controller2, _isVideo2Watched),
              SizedBox(height: 20.h),
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
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            buildVideoPlayer(controller),
            SizedBox(height: 10.h),
            IconButton(
              icon: Icon(
                controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: kblue,
                size: 28.sp,
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
                child: Text(
                  _selectedLanguage == 'en'
                      ? 'Take Quiz for Video $videoNumber'
                      : 'வீடியோ $videoNumber க்கான வினாடி வினா எடுக்கவும்',
                  style: GoogleFonts.poppins(fontSize: 16.sp),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kblue,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
