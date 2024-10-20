import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/controllers/auth_controller.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:social_media_buttons/social_media_button.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil to use device-specific dimensions
  

    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(custombagroundimage),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Stack(
        children: [
          _buildAppBar(),
          _buildForm(context),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 40.h,
      left: 0,
      right: 0,
      child: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Log in',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLottieAnimation(),
             // SizedBox(height: 24.h),
             // _buildPhoneNumberInput(),
             // SizedBox(height: 24.h),
            //  _buildLoginButton(context),
              SizedBox(height: 60.h),
             // buildLoginOptions(),
              SizedBox(height: 16.h),
              _buildGoogleLoginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLottieAnimation() {
    return SizedBox(
      height: 200.h,
      child: Lottie.asset(lottielogingif),
    );
  }
Widget buildLoginOptions() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center, // Center-align the row
    children: [
      GestureDetector(
        onTap: () {
          // Handle OTP login tap event
          print("Login with OTP tapped");
        },
        child: Text(
          'Login with OTP',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey, // Make it look like a clickable link
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(width: 10), // Space between the texts
      Text(
        'OR', // Separator
        style: TextStyle(
          fontSize: 16.sp,
          color: kblack,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(width: 10), // Space between the texts
      GestureDetector(
        onTap: () {
          // Handle Google login tap event
          print("Google Login tapped");
        },
        child: Text(
          'Google Login',
          style: TextStyle(
            fontSize: 16.sp,
            color:Colors.grey,// Same link style for consistency
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

  Widget _buildPhoneNumberInput() {
    return Column(
      children: [
        Text(
          'Enter your phone number',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: kblue,
          ),
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: phoneController,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
            ),
            hintText: 'Please enter your phone number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: kblue, width: 2.w),
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 5.w),
                  const Text('+91', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length < 10) {
              return 'Enter a valid phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: authController.isLoading.value
              ? null
              : () => authController.loginWithPhoneNumber(
                    phoneController.text,
                    context,
                  ),
          style: ElevatedButton.styleFrom(
            backgroundColor: kblue,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            textStyle: TextStyle(fontSize: 18.sp),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: authController.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Login with OTP'),
        ),
      ),
    );
  }

  Widget _buildGoogleLoginButton(BuildContext context) {
    return SignInButton(padding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
  Buttons.google,
  onPressed: () { authController.loginWithGoogle();},
);

  }
}
