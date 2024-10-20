import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mwave/auth/onboard_screen.dart';
import 'package:mwave/view/bottumbar1.dart';
import 'package:mwave/view/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mwave/constants/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
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

  _navigateBasedOnRegistrationStatus();
  }

  
 Future<void> _navigateBasedOnRegistrationStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool isRegistered = prefs.getBool('isRegistered') ?? false;
      

      // Simulate splash screen delay (optional)
      await Future.delayed(const Duration(seconds: 2));
 print(isRegistered);
      if (isRegistered ) {
        print(isRegistered);
        // Navigate to Home Screen if registered
        Get.off(() => BottumNavBar());
      } else {
        // Navigate to Onboard Screen if not registered
        Get.off(() => OnboardScreen());
      }
    } catch (e) {
      print('Error during splash screen navigation: $e');
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
            children: [
              Lottie.asset('assets/images/Animation - 1729157358008.json'), // Lottie animation
              SizedBox(height: 20.h),

              // App Name
              Text(
                'MoneyWave',
                style: GoogleFonts.poppins(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              // Optional Tagline (commented out)
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
