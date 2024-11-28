import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/controllers/referal_controller.dart';
import 'package:mwave/desclimer/desclimer_screen.dart';
import 'package:mwave/view/bottumbar1.dart';

class ReferralScreen extends StatelessWidget {
  final TextEditingController _referralCodeController = TextEditingController();
  final ReferralController controller = Get.put(ReferralController());

  ReferralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                colors: [ Color.fromARGB(255, 98, 154, 251),kblue,],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(24.0.sp),
              child: GetBuilder<ReferralController>(
                builder: (controller) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40.h),
                        _buildSkipButton(),
                        SizedBox(height: 40.h),
                        _buildLottieAnimation(),
                        SizedBox(height: 20.h),
                        _buildReferralInput(),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkipButton() {
    return GestureDetector(
      onTap: () {
        Get.offAll(() =>  DisclaimerPage());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Get.offAll(() =>  DisclaimerPage());
            },
            child: Text(
              'Skip',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildLottieAnimation() {
    return Center(
      child: Lottie.asset(
        'assets/images/Animation - 1731992642948.json',
      //  height: 250.h,
      ),
    );
  }

  Widget _buildReferralInput() {
    return Center(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Referral Code',
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: kblue,
                ),
              ),
              SizedBox(height: 16.h),
              _buildReferralTextField(),
              SizedBox(height: 24.h),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReferralTextField() {
    return TextFormField(
      controller: _referralCodeController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0.r),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0.r),
          borderSide: const BorderSide(color: Color(0xFF6A11CB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0.r),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        hintText: 'Referral Code',
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GetBuilder<ReferralController>(
      builder: (controller) {
        return Center(
          child: SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: controller.isLoading
                  ? null
                  : () async {
                      String referralId = _referralCodeController.text.trim();
                      if (referralId.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please enter a referral code.',
                          snackPosition: SnackPosition.TOP,
                        );
                      } else {
                        controller.isLoading = true;
                        controller.update();

                        await controller.addReferral(referralId);

                        controller.isLoading = false;
                        controller.update();

                        if (controller.referralUsed.value) {
                          Get.offAll(() => BottumNavBar());
                        }
                      }
                    },
              child: controller.isLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A11CB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                elevation: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}
