import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/constants/colors.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> courses = [
      {
        'title': 'Flutter Development',
        'description':
            'Learn how to build beautiful and responsive mobile apps.',
        'image':
            'assets/images/WhatsApp Image 2024-10-03 at 2.50.54 PM(1).jpeg',
      },
      {
        'title': 'Web Development',
        'description': 'Master the basics of HTML, CSS, and JavaScript.',
        'image':
            'assets/images/WhatsApp Image 2024-10-03 at 2.50.54 PM(1).jpeg',
      },
      {
        'title': 'Data Science',
        'description': 'Dive into data analysis, machine learning, and AI.',
        'image':
            'assets/images/WhatsApp Image 2024-10-03 at 2.50.54 PM(1).jpeg',
      },
      {
        'title': 'UI/UX Design',
        'description':
            'Learn the principles of great user experience and design.',
        'image':
            'assets/images/WhatsApp Image 2024-10-03 at 2.50.54 PM(1).jpeg',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          'Courses',
          style: GoogleFonts.poppins(
              fontSize: 24.sp, fontWeight: FontWeight.bold, color: kwhite),
        ),
        backgroundColor: const Color(0xFF6A00D7),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return _buildCourseCard(
              context,
              title: course['title']!,
              description: course['description']!,
              image: course['image']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildCourseCard(
    BuildContext context, {
    required String title,
    required String description,
    required String image,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 5,
      margin: EdgeInsets.only(bottom: 16.h),
      child: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Row(
          children: [
            // Course Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                image,
                width: 80.w,
                height: 80.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.w),

            // Course Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: const Color(0xFF666666),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
