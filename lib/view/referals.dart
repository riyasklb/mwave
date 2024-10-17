import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/controllers/referal_controller.dart';
import 'package:mwave/model/referal_model.dart';

import 'package:skeletonizer/skeletonizer.dart';

import 'package:flutter/widgets.dart';






class MyReferalsScreen extends StatelessWidget {

  final ReferralController controller = Get.put(ReferralController());

  /// **Flag to determine where to navigate after submission**
 

  MyReferalsScreen({Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              custombagroundimage,
              fit: BoxFit.cover,
            ),
          ),
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
