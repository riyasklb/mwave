import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/view/branding/pdf_view_screen.dart';

class SocialMediaBrandingScreen extends StatelessWidget {
  const SocialMediaBrandingScreen({Key? key}) : super(key: key);

  // Social Media Tile Widget
  Widget _socialMediaTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: kwhite,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 28.sp),
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: kblue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Video Tile Widget
  Widget _videoTile({
    required String thumbnail,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                thumbnail,
                height: 60.h,
                width: 100.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 74, 87, 198), kblue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Follow Us',
                  style: GoogleFonts.poppins(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Stay connected with us on social media!',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 32.h),

                // Social Media Tiles
                Column(
                  children: [
                    _socialMediaTile(
                      icon: FontAwesomeIcons.facebook,
                      title: 'Facebook',
                      color: const Color(0xFF3b5998),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PDFViewerScreen(),
                          ),
                        );
                      },
                    ),
                    _socialMediaTile(
                      icon: FontAwesomeIcons.instagram,
                      title: 'Instagram',
                      color: const Color(0xFFE4405F),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PDFViewerScreen(),
                          ),
                        );
                      },
                    ),
                    _socialMediaTile(
                      icon: FontAwesomeIcons.twitter,
                      title: 'Twitter',
                      color: const Color(0xFF1DA1F2),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PDFViewerScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 32.h),

                // Dummy Video List
                Text(
                  'Our Videos',
                  style: GoogleFonts.poppins(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: ListView(
                    children: [
                      _videoTile(
                        thumbnail:
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1uPDKhNqzPiGJko5UBlwm0rGj5OzX-0rCCQ&s', // Replace with video thumbnail URLs
                        title: 'Video Title 1',
                        onTap: () {
                          // Placeholder for video playback
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Play Video 1')),
                          );
                        },
                      ),
                      _videoTile(
                        thumbnail:
                            'https://www.articlecube.com/sites/default/files/styles/article_full/adaptive-image/public/field/image/32132/The%20Ultimate%20Guide%20to%20Create%20an%20Engaging%20E-learning%20App%20with%20Machine%20Learning%20for%20Modern%20Learners.jpg?itok=Yqi34y_F', // Replace with video thumbnail URLs
                        title: 'Video Title 2',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Play Video 2')),
                          );
                        },
                      ),
                      _videoTile(
                        thumbnail:
                            'https://www.articlecube.com/sites/default/files/styles/article_full/adaptive-image/public/field/image/24287/Asset%20Management%20Software.jpg?itok=aCpMtjaN', // Replace with video thumbnail URLs
                        title: 'Video Title 3',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Play Video 3')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
