import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mwave/constants/colors.dart';
import 'package:mwave/controllers/referal_controller.dart';

import 'package:mwave/view/bottumbar1.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReferralScreen extends StatelessWidget {
  final TextEditingController _referralCodeController = TextEditingController();
  final ReferralController controller = Get.put(ReferralController());

  /// **Flag to determine where to navigate after submission**

  ReferralScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kblue,
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     custombagroundimage,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.all(24.0.sp),
              child: GetBuilder<ReferralController>(
                builder: (controller) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        kheight40,
                        GestureDetector(
                          onTap: () {
                            Get.offAll(() => BottumNavBar());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.offAll(() => BottumNavBar());
                                  //  Get.offAll(() => BottumNavBar());
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
                              Icon(
                                Icons.arrow_forward,
                                color: kwhite,
                              )
                            ],
                          ),
                        ),
                        kheight40,
                        _buildLottieAnimation(),
                        _buildReferralInput(controller),
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

  Widget _buildReferralInput(ReferralController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40.h),
        Text(
          'Enter Referral Code',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16.h),
        _buildReferralTextField(),
        SizedBox(height: 24.h),
        _buildSubmitButton(controller),
      ],
    );
  }

  Widget _buildReferralTextField() {
    return TextFormField(
      controller: _referralCodeController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0.r), // More curved edges
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(30.0.r), // Matching curve when focused
          borderSide: BorderSide(
            color: kblue,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0.r),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        hintText: 'Referral Code',
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildSubmitButton(ReferralController controller) {
  return GetBuilder<ReferralController>(
    builder: (context) {
      return Center(
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: controller.isLoading 
                ? null // Disable the button if loading
                : () async {
                    String referralId = _referralCodeController.text.trim();
                    if (referralId.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please enter a referral code.',
                        snackPosition: SnackPosition.TOP,
                      );
                    } else {
                      // Set loading to true
                      controller.isLoading = true;
                      controller.update(); // Notify the controller to update the UI
                      
                      await controller.addReferral(referralId);

                      // Set loading to false
                      controller.isLoading = false;
                      controller.update(); // Notify the controller to update the UI

                      if (controller.referralUsed.value) {
                        Get.offAll(() => BottumNavBar());
                      }
                    }
                  },
            child: controller.isLoading
                ? SizedBox(
                    height: 20.h, // Adjust height for better visibility
                    width: 20.h, // Adjust width for better visibility
                    child: CircularProgressIndicator(
                      color: Colors.black, // Black for visibility on white background
                      strokeWidth: 2, // Adjust thickness as necessary
                    ),
                  )
                : Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black, // Black text for contrast
                    ),
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // White button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              elevation: 2, // Optional: Slight shadow for better visibility
              textStyle: GoogleFonts.poppins(fontSize: 30.sp),
            ),
          ),
        ),
      );
    },
  );
}


  Widget _buildLottieAnimation() {
    return SizedBox(child: Image.asset('assets/images/rb_7121.png')
        // Lottie.asset(lottiereferal),
        );
  }
}
