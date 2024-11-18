
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mwave/constants/colors.dart';
import 'package:mwave/view/couces_screen.dart';



import '../controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({Key? key}) : super(key: key);

   final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(custombagroundimage),
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
          ),
          // Overlay for the content
          Padding(
            padding: EdgeInsets.all(16.0.w),
            child: GetBuilder<AuthController>(
              builder: (_) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent, // Make the AppBar transparent
                      title: Text(
                        'Dashboard',
                        style: GoogleFonts.lato(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      centerTitle: true,
                    ),
                    SizedBox(height: 20.h),
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
                              Get.to(() => CoursesScreen());
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
                            onTap: () => _showLogoutDialog(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  // Method to show logout confirmation dialog
  Future<void> _showLogoutDialog(BuildContext context) async {
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
           Get.back();
            },
          ),
          TextButton(
            child: Text(
              "Logout",
              style: TextStyle(
                fontSize: 18.sp, // Use ScreenUtil for responsive sizing
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              authController.logoutUser(context);
              // Return true on logout
            },
          ),
        ],
      ),
    );


  }

  // // Refactored Logout Logic
  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: kblue.withOpacity(0.8), // Slightly transparent
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
