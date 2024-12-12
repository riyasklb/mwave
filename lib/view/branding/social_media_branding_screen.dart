import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/view/branding/pdf_view_screen.dart';



class SocialMediaBrandingScreen extends StatelessWidget {
  const SocialMediaBrandingScreen({Key? key}) : super(key: key);

  // Video Tile Widget
  Widget _videoTile({
    required String thumbnail,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 690.h,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instagram-like Header (Profile image and username)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.r),
                  child: Image.network(
                    'https://randomuser.me/api/portraits/men/1.jpg', // Replace with the profile image URL
                    height: 30.h,
                    width: 30.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Username', // Replace with the actual username
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Video Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                thumbnail,
                //height: 200.h, // Adjust height as needed
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12.h),

            // Action Buttons (Like, Comment, Share)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.heart,
                      size: 20.sp,
                      color: Colors.black87,
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      FontAwesomeIcons.comment,
                      size: 20.sp,
                      color: Colors.black87,
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      FontAwesomeIcons.share,
                      size: 20.sp,
                      color: Colors.black87,
                    ),
                  ],
                ),
                // Add a "Save" Icon (Optional)
                Icon(
                  FontAwesomeIcons.bookmark,
                  size: 20.sp,
                  color: Colors.black87,
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Title/Description Text
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
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
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kblue, Color.fromARGB(255, 247, 244, 247)],
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
                SizedBox(height: 16.h),

                // PDF Button
              Container(
  margin: EdgeInsets.symmetric(vertical: 20.h), // Add margin for spacing
  padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w), // Add padding for better button sizing
  height: 120.h,  // Specify the height of the container
  decoration: BoxDecoration(
    color: kblue, // Background color
    borderRadius: BorderRadius.circular(12.r), // Rounded corners
   
  ),
  child: InkWell(
    onTap: () {
      // Navigate to the PDF view screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(),
        ),
      );
    },
    child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [Icon(
          FontAwesomeIcons.play, // Play icon from FontAwesome
          color: Colors.white,
          size: 30.sp,  // Icon size
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            SizedBox(width: 12.w),  // Space between the icon and text
            Text(
              'View PDF',
              style: GoogleFonts.poppins(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    ),
  ),
)
,
             //   SizedBox(height: 32.h),

                // Social Media Tiles
                SizedBox(height: 10.h),

                // Instagram-like model view for videos
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
                            'assets/images/addimg1.jpg', // Replace with video thumbnail URLs
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
                            'assets/images/addimg2.jpg',
                                 title: 'Video Title 2',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Play Video 2')),
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
