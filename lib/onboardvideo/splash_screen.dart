import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mwave/auth/onboard_screen.dart';
import 'package:mwave/view/bottumbar1.dart';
import 'package:mwave/view/paymet_screen.dart';

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
    
    if (isRegistered) {
      // If the user is registered, check the payment status from Firestore
      bool paymentStatus = await _checkPaymentStatus();
      
      if (paymentStatus) {
        // Navigate to Home Screen if payment is done
        Get.off(() => BottumNavBar());
      } else {
        // Navigate to Payment Screen if payment is pending
        Get.off(() => PaymentPage());
      }
    } else {
      // Navigate to Onboard Screen if not registered
      Get.off(() => OnboardScreen());
    }
  } catch (e) {
    print('Error during splash screen navigation: $e');
  }
}

// Helper function to check payment status from Firestore
Future<bool> _checkPaymentStatus() async {
  try {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String? emailId = currentUser.email;

      // Fetch the user's payment status from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(emailId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        // Return payment status if available, else false
        return userDoc['paymentStatus'] ?? false;
      }
    }
  } catch (e) {
    print('Error fetching payment status: $e');
  }
  return false; // Default to false if there's any error or missing data
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
