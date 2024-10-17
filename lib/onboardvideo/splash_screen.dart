import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mwave/auth/onboard_screen.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/view/bottumbar1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Animation duration
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // Check user login status after the splash screen
    _checkUserLoginStatus();
  }

  // Function to retrieve user id from shared preferences
  Future<String?> _getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  // Check if the user is logged in and navigate accordingly
  void _checkUserLoginStatus() async {
    String? userId = await _getUserIdFromPrefs();
    if (userId != null) {
      print('User ID: $userId');
      // If the user is logged in, navigate to the home screen
      Future.delayed(Duration(seconds: 3), () {
        Get.offAll(
            () => BottumNavBar()); // Change this to your actual HomeScreen
      });
    } else {
      print('No user logged in');
      // If no user is logged in, navigate to the onboard screen
      Future.delayed(Duration(seconds: 3), () {
        Get.offAll(() => Onboard_screen()); // Navigate to Onboard_screen
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kblue, // Background color
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ Lottie.asset('assets/images/Animation - 1729157358008.json'),
              // App Logo (replace with your actual logo asset)
              // Icon(
              //   Icons.attach_money, // Placeholder for logo
              //   size: 100.w,
              //   color: Colors.white,
              // ),
            //  SizedBox(height: 20.h),

              // App Name
              Text(
                'MoneyWave',
                style: GoogleFonts.poppins(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              // Tagline
              // Text(
              //   'Manage your finances effortlessly',
              //   style: GoogleFonts.poppins(
              //     fontSize: 16.sp,
              //     color: Colors.white70,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
