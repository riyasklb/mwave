import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/auth/auth_link/auth_service.dart';
import 'package:mwave/auth/input_adreass_screen.dart';

class Verifyhome extends StatefulWidget {
  const Verifyhome({super.key});

  @override
  State<Verifyhome> createState() => _VerifyhomeState();
}

class _VerifyhomeState extends State<Verifyhome> {
  final _auth = AuthService();
  Timer? _timer;
  String? photo;
  String? email;
  String? username;
  bool isResending = false; // To handle the resend button state

  @override
  void initState() {
    super.initState();
    _auth.sendEmailVerification();
    // Periodically check for email verification
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser!.reload(); // Refresh user data
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        timer.cancel(); // Stop the timer if verified
        // Fetch user details
        setState(() {
          photo = user.photoURL;
          email = user.email;
          username = email?.split('@').first;
        });
        Get.to(AddressAndPhoneCollectionScreen(
          email: email!,
          username: username!,
          photo: photo ?? '',
        )); // Navigate to the next screen
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> resendEmailVerification() async {
    setState(() {
      isResending = true; // Show a loader or disable button while resending
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send verification email: $e')),
      );
    } finally {
      setState(() {
        isResending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Background color for the screen
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Email Verification",
                style: GoogleFonts.poppins(
                  fontSize: 24.sp, // Responsive font size using ScreenUtil
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "We’ve sent a verification link to your email. Please check your inbox and verify your email address.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp, // Responsive font size using ScreenUtil
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: isResending
                    ? null // Disable button while resending
                    : resendEmailVerification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: isResending
                    ? const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                          "Resend Verification Email",
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
