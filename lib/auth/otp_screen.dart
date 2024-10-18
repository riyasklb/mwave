import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/controllers/auth_controller.dart';

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

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

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

  void _verifyOtp() async {
    setState(() {
      isLoading = true;
    });

    String otp = otpController.text.trim();

    try {
      await authController.verifyOtp(widget.verificationId, otp);
    } catch (e) {
      // Handle errors here (if necessary)
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _resendOtp() {
    if (canResend) {
      setState(() {
        canResend = false;
        timerSeconds = 30; // Reset the timer
      });
      _startTimer();
      authController.resendOtp(widget.phoneNumber, context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(custombagroundimage), // Background image path
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Stack(
        children: [
          _buildAppBar(),
      
          _buildOtpForm(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 40,
      left: 0,
      right: 0,
      child: AppBar(
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
    );
  }

  Widget _buildOtpForm() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60), 
            _buildLottieAnimation(),kheight40,// Space for the AppBar
            _buildOtpInstructions(),
            const SizedBox(height: 16),
            _buildOtpInputField(),
            const SizedBox(height: 24),
            _buildResendOtpButton(),
            const SizedBox(height: 16),
            _buildVerifyButton(),
            const SizedBox(height: 16),
            _buildEditPhoneNumberButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpInstructions() {
    return Text(
      'Enter the OTP sent to your phone',
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: kblue,
      ),
      textAlign: TextAlign.center,
    );
  }
  Widget _buildLottieAnimation() {
    return SizedBox(
      height: 200.h,
      child: Lottie.asset(lottielogingif),
    );
  }
  Widget _buildOtpInputField() {
    return TextFormField(
      controller: otpController,
      decoration: InputDecoration(
        hintText: 'Enter OTP',
        hintStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: kblue,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide:BorderSide(
            color: kblue,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide:  BorderSide(
            color: kblue,
            width: 1.0,
          ),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildResendOtpButton() {
    if (timerSeconds > 0) {
      return Text(
        'Resend OTP in $timerSeconds seconds',
        style: const TextStyle(color: Colors.grey),
      );
    } else {
      return TextButton(
        onPressed: _resendOtp,
        child: Text(
          'Resend OTP',
          style: TextStyle(
            color: canResend ? kblue : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  Widget _buildVerifyButton() {
    return SizedBox(
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
    );
  }

  Widget _buildEditPhoneNumberButton() {
    return TextButton(
      onPressed: () {
        Get.back(); // Navigate back to the previous screen
      },
      child: Text(
        'Edit Phone Number',
        style: TextStyle(color: kblue),
      ),
    );
  }
  
}
