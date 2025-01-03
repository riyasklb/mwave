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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _navigateBasedOnRegistrationStatus();
  }

  /// Initialize animation
  void _initializeAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  Future<void> _navigateBasedOnRegistrationStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool isRegistered = prefs.getBool('isRegistered') ?? false;

      // Simulate splash screen delay
      await Future.delayed(const Duration(seconds: 2));

      if (isRegistered==false) {
        print(
            '----------------------is registerd ${isRegistered}-------------------------------------------------------------');
        print(
            '----------------------is registerd ${isRegistered}-------------------------------------------------------------');
        print(
            '----------------------is registerd ${isRegistered}-------------------------------------------------------------');
        print(
            '----------------------is registerd ${isRegistered}-------------------------------------------------------------');
        print(
            '----------------------is registerd ${isRegistered}-------------------------------------------------------------');
        // Navigate to Onboard Screen for new users
        Get.off(() => OnboardScreen());
        return; // Exit the method early to avoid further checks
      }

      // Check payment status if the user is registered
      bool paymentStatus = await _checkPaymentStatus();
      if (paymentStatus) {
        // Navigate to Home Screen if payment is complete
        Get.off(() => BottumNavBar());
      } else {
        // Navigate to Payment Screen if payment is pending
        Get.off(() => PaymentPage());
      }
    } catch (e) {
      print('Error during splash screen navigation: $e');
      // Fallback to Onboard Screen in case of any errors
      Get.off(() => OnboardScreen());
    }
  }

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
          return userDoc['paymentStatus'] ?? false;
        }
      }
    } catch (e) {
      print('Error fetching payment status: $e');
    }

    // Default to false if there's any error or no user document
    return false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kblue,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/images/Animation - 1729157358008.json',
                width: 150.w,
                height: 150.h,
              ),
              SizedBox(height: 20.h),
              Text(
                'MoneyWave',
                style: GoogleFonts.poppins(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
