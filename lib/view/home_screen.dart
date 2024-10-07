import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/auth/login_screen.dart';

import 'package:mwave/view/couces_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A00D7), // Custom background color
        title: Text(
          'Dashboard', // Replace with your desired title
          style: GoogleFonts.lato(
            fontSize: 24.sp, // Adjust the font size as needed
            fontWeight: FontWeight.bold, // Bold text
            color: Colors.white, // Text color
            letterSpacing: 1.2, // Adds a little spacing between letters
          ),
        ),
        centerTitle: true, // Centers the title in the AppBar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.h),

            // Dashboard Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                children: [
                  _buildDashboardCard(
                    context,
                    title: 'Courses',
                    icon: Icons.school,
                    onTap: () {
                      Get.to(() => CoursesScreen()); // Navigate to Courses
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Profile',
                    icon: Icons.person,
                    onTap: () {
                      // Navigate to Profile screen
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Achievements',
                    icon: Icons.star,
                    onTap: () {
                      // Navigate to Achievements screen
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Messages',
                    icon: Icons.message,
                    onTap: () {
                      // Navigate to Messages screen
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Analytics',
                    icon: Icons.bar_chart,
                    onTap: () {
                      // Navigate to Analytics screen
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Log out',
                    icon: Icons.logout,
                    onTap: () {
                      Get.to(
                          () => LoginPage()); // Log out and navigate to login
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color(0xFF6A00D7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48.sp, color: Colors.white),
              SizedBox(height: 16.h),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
