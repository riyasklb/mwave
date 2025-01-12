import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  Future<Map<String, dynamic>?> fetchCourseData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc('demo')
          .get();

      return docSnapshot.data();
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return null;
    }
  }

  void _playVideo(BuildContext context, String videoUrl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: 400.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  "Playing Video",
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: VideoPlayerScreen(videoUrl: videoUrl),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          body: FutureBuilder<Map<String, dynamic>?>(
            future: fetchCourseData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || snapshot.data == null) {
                return Center(
                  child: Text(
                    'Failed to load course data',
                    style: GoogleFonts.poppins(fontSize: 16.sp),
                  ),
                );
              }

              final data = snapshot.data!;
              final videos = data['videos'] as List<dynamic>? ?? [];

              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Banner
                      Stack(
                        children: [
                          Image.network(
                            data['profilePicUrl'] ?? '',
                            height: 250.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: 250.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16.h,
                            left: 16.w,
                            child: Text(
                              data['courseName'] ?? 'Course Name',
                              style: GoogleFonts.poppins(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // Course Details Card
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 8,
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'About the Course',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  data['courseDesc'] ?? 'Course Description',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                ElevatedButton(
                                  onPressed: () {
                                    // Action for starting the course
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 8.h,
                                    ),
                                    child: Text(
                                      'Start Course',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Videos Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          'Course Videos',
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          final videoUrl = videos[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 4,
                              child: ListTile(
                                leading: Icon(
                                  Icons.play_circle_fill,
                                  size: 32.sp,
                                  color: Colors.blueAccent,
                                ),
                                title: Text(
                                  'Video ${index + 1}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  'Tap to play',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                onTap: () {
                                  _playVideo(context, videoUrl);
                                },
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              );
            },
          ),
        );
  }
    
  }


class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  bool _isStretched = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
      showControls: true,
      aspectRatio: _controller.value.aspectRatio,
    );
  }

  void _toggleStretch() {
    setState(() {
      _isStretched = !_isStretched;
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: true,
        looping: true,
        showControls: true,
        aspectRatio: _isStretched ? 1.0 : _controller.value.aspectRatio, // Toggle between stretched and original aspect ratio
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Container(height: 300,
          child: Chewie(controller: _chewieController)),
        IconButton(
          icon: Icon(
            _isStretched ? Icons.fit_screen : Icons.aspect_ratio,
            size: 30.sp,
            color: Colors.black,
          ),
          onPressed: _toggleStretch,
        ),
      ],
    );
  }
}

