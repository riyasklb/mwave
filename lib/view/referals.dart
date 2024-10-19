import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/controllers/referal_controller.dart';
import 'package:intl/intl.dart'; // Importing intl for DateFormat

class MyReferalsScreen extends StatelessWidget {
  final ReferralController referralController = Get.put(ReferralController());

  MyReferalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              custombagroundimage, // Ensure this path is correct
              fit: BoxFit.cover,    // Adjust the fit as necessary
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.0.sp), // Use ScreenUtil for responsive padding
            child: GetBuilder<ReferralController>(
              builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!controller.referralUsed.value) SizedBox(height: 40.h),
                    _buildYourReferralsTitle(),
                    Expanded(child: _buildReferralList(controller)), // Use Expanded here
                  ],
                );
              },
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
        SizedBox(height: 40.h), // Responsive height using ScreenUtil
        Text(
          'Your Referrals',
          style: GoogleFonts.poppins(
            fontSize: 24.sp, // Responsive font size
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildReferralList(ReferralController controller) {
    return ListView.builder(
      itemCount: controller.referrals.length,
      itemBuilder: (context, index) {
        final referral = controller.referrals[index];

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 16.0.sp), // Use ScreenUtil for margins
          child: ListTile(
            contentPadding: EdgeInsets.all(16.0.sp), // Use ScreenUtil for padding
            leading: CircleAvatar(
              child: Text(referral.username[0].toUpperCase()), // Capitalize the first letter
            ),
            title: Text(
              _capitalizeFirstLetter(referral.username), // Capitalize the first letter of the username
              style: GoogleFonts.poppins(
                fontSize: 18.sp, // Responsive font size
                fontWeight: FontWeight.w500,
                color: Colors.black, // Adjust color as needed
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  referral.email,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp, // Responsive font size
                    color: Colors.black54, // Adjust color as needed
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "Referred on: ${DateFormat('yyyy-MM-dd').format(referral.referredOn)}",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp, // Responsive font size
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8.0),
                referral.subReferrals.isNotEmpty
                    ? ExpansionTile(
                        title: Text(
                          "Sub-referrals",
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp, // Responsive font size
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        children: referral.subReferrals.map((subReferral) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ListTile(
                              leading: const Icon(Icons.arrow_right),
                              title: Text(
                                _capitalizeFirstLetter(subReferral.username), // Capitalize the first letter of sub-referral username
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp, // Responsive font size
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                "Referred on: ${DateFormat('yyyy-MM-dd').format(subReferral.referredOn)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp, // Responsive font size
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text; // Return empty if the text is empty
    return text[0].toUpperCase() + text.substring(1); // Capitalize first letter and append the rest
  }
}
