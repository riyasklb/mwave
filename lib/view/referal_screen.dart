import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/controllers/referal_controller.dart';
import 'package:mwave/model/referal_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReferralScreen extends StatelessWidget {
  final TextEditingController _referralCodeController = TextEditingController();
  final ReferralController controller = Get.put(ReferralController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              custombagroundimage, // Add your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Foreground content
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.all(24.0.sp),
              child: GetBuilder<ReferralController>(
                builder: (controller) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        if (!controller.referralUsed)
                         // Only show if referral not used
                          _buildReferralInput(controller),
                        SizedBox(height: 40.h),
                        _buildYourReferralsTitle(),
                        _buildReferralList(controller),
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

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        'Add Referral Code',
        style: GoogleFonts.poppins(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: kwhite,
        ),
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
    return TextField(
      controller: _referralCodeController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(),
        hintText: 'Referral Code',
        hintStyle: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildSubmitButton(ReferralController controller) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (controller.isLoading) return;

          String referralId = _referralCodeController.text.trim();
          if (referralId.isEmpty) {
            Get.snackbar('Error', 'Please enter a referral code.',
                snackPosition: SnackPosition.BOTTOM);
          } else {
            controller.addReferral(referralId);
          }
        },
        child: controller.isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text('Submit', style: TextStyle(fontSize: 16.sp)),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 32.sp, vertical: 12.sp),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildYourReferralsTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40.h),
        Text(
          'Your Referrals',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildReferralList(ReferralController controller) {
    return FutureBuilder<List<Referral>>(
      future: controller.getReferrals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              SizedBox(height: 10.h),
              Skeletonizer(
                child: Card(
                  child: Container(
                    height: 60.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kwhite,
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final referral = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text(referral.username),
                  subtitle: Text(referral.email),
                ),
              );
            },
          );
        } else {
          return Text('No referrals yet.');
        }
      },
    );
  }
}
