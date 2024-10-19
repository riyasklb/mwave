import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mwave/auth/login_screen.dart';
import 'package:mwave/auth/register_screen.dart';
import 'package:mwave/constants/colors.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure ScreenUtil is initialized before using
    

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              custombagroundimage, // Replace with your background image path
              fit: BoxFit.cover, // Ensure the image covers the entire screen
            ),
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kblue.withOpacity(0.1),
                  const Color(0xFF8E2DE2).withOpacity(0.1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Main content
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo at the top center
                  CircleAvatar(
                    radius: 129.r, // Adjust with ScreenUtil
                    backgroundImage: const AssetImage(
                      'assets/images/WhatsApp Image 2024-10-03 at 2.50.54 PM(1).jpeg',
                    ),
                  ),
                  SizedBox(height: 40.h), // Adjusted height

                  // Welcome Text
                  Text(
                    'Money Wave',
                    style: GoogleFonts.poppins(
                      color: kblue,
                      fontSize: 35.sp, // Scaled font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 39.h), // Adjusted height

                  // Login Button
                  SizedBox(
                    width: double.infinity, // Full-width button
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        Get.to(LoginPage());
                      },
                      child: Text(
                        'Log in',
                        style: GoogleFonts.poppins(
                          color: kblue,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        backgroundColor: kblue, // No background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      child: Text(
                        'Register',
                        style: GoogleFonts.poppins(
                          color: kwhite,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Help Text
                  TextButton(
                    onPressed: () {
                      // Add help functionality here
                    },
                    child: Text(
                      'Need Help?',
                      style: GoogleFonts.poppins(
                        color: kblue,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
