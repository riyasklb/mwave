import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/controllers/auth_controller.dart';
import 'package:mwave/view/bottumbar1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpPage({
    required this.phoneNumber,
    required this.verificationId,
    Key? key,
  }) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  bool canResend = false;
  int timerSeconds = 30;
  Timer? _timer;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  // Method to start the OTP expiration timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          canResend = true;
          timer.cancel();
        }
      });
    });
  }

  // Method to verify OTP
  void _verifyOtp() async {
    setState(() {
      isLoading = true;
    });

    try {
      String _otp = otpController.text.trim();

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otp,
      );

      // Sign in with the OTP credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Store user ID in SharedPreferences
      String userId = userCredential.user!.uid;
      await _saveUserIdToPrefs(userId);

      // Check if phone number is already registered in Firestore
      await _checkUserByPhoneNumber(widget.phoneNumber);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      authController.showToasr(context,
        text: 'OTP verification failed: $e',
        icon: Icons.error,
      );
    }
  }

  // Method to check user details by phone number
  Future<void> _checkUserByPhoneNumber(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        String userId = userDoc.id;
        await _saveUserIdToPrefs(userId);

        authController.showToasr(context,
          text: 'User found and logged in successfully!',
          icon: Icons.check,
        );

        Get.offAll(BottumNavBar());
      } else {
        authController.showToasr(context,
          text: 'No account found with this phone number.',
          icon: Icons.error,
        );
      }
    } catch (e) {
      authController.showToasr(context,
        text: 'Error fetching user details: $e',
        icon: Icons.error,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Save user ID in SharedPreferences
  Future<void> _saveUserIdToPrefs(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', userId);
  }

  // Method to resend OTP
  void _resendOtp() {
    setState(() {
      canResend = false;
      timerSeconds = 30;
    });
    _startTimer();

    authController.showToasr(context,
      text: 'OTP resent successfully!',
      icon: Icons.check,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(custombagroundimage), // Background image path
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            kheight40,
            AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Enter OTP',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
            kheight40,
            kheight40,
            kheight40,
            kheight40,
            const SizedBox(height: 24),
            Text(
              'Enter the OTP sent to your phone',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: otpController,
              decoration: InputDecoration(
                hintText: 'Enter OTP',
                hintStyle: TextStyle(
                  color: kblack,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Rounded border
                  borderSide: BorderSide.none, // No border line
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: kblue, // Change the border color when focused
                    width: 1.0, // Thickness of the border when focused
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            if (timerSeconds > 0)
              Text(
                'Resend OTP in $timerSeconds seconds',
                style: const TextStyle(color: Colors.white70),
              ),
            if (timerSeconds == 0)
              TextButton(
                onPressed: canResend ? _resendOtp : null,
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                    color: canResend ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kblue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Verify OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
