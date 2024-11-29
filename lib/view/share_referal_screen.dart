import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mwave/auth/input_adreass_screen.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/controllers/referal_controller.dart';
import 'package:share_plus/share_plus.dart';

class ShareReferralScreen extends StatefulWidget {
  const ShareReferralScreen({Key? key}) : super(key: key);

  @override
  _ShareReferralScreenState createState() => _ShareReferralScreenState();
}

class _ShareReferralScreenState extends State<ShareReferralScreen> {
   final ReferralController referralController = Get.put(ReferralController());
  String referralCode = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReferralCode();
  }

  Future<void> fetchReferralCode() async {
    try {
      String? emailId = FirebaseAuth.instance.currentUser?.email;

      if (emailId == null) {
        throw Exception('User not logged in');
      }

      var documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(emailId)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          referralCode = documentSnapshot['referralId'] ?? 'No Referral Code';
          isLoading = false;
        });
      } else {
        setState(() {
          referralCode = 'No Referral Code Available';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching referral code: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // leading: InkWell(onTap: (){Get.back();},
        // child: Icon(Icons.arrow_back,color: kwhite,)),
        title: Text(
          'Share Referral Code',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,color: kwhite
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [kblue, Color.fromARGB(255, 247, 244, 247)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.0.sp),
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.white))
              : ListView(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [kheight40,kheight40,
                    
                     
                        Lottie.asset(
                          'assets/images/Animation - 1731991731436.json',
                          // width: 200.w,
                          // height: 200.h,
                          repeat: true,
                        ),
                        SizedBox(height: 20.h),
                        _buildReferralCodeDisplay(),
                        SizedBox(height: 40.h),
                        _buildShareButtons(),kheight40,  Row(
                          children: [
                            Text(
                                  'Your Referrals',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                          ],
                        ),kheight10,
                         _buildReferralList(referralController),
                      ],
                    ),
                ],
              ),
        ),
      ),
    );
  }

  Widget _buildReferralCodeDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.sp,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            referralCode,
            style: GoogleFonts.poppins(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy, color: Colors.grey),
            onPressed: () {
              _copyReferralCode(referralCode);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShareButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.share),
          label: Text('Share Code'),
          onPressed: () {
            Share.share('$referralCode');
            _showShareSuccessAnimation();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.sp),
            ),
          ),
        ),
        
      ],
    );
  }

  void _copyReferralCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Referral Code Copied!')),
    );
  }

  void _showShareSuccessAnimation() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Lottie.asset(
            'assets/images/Animation - 1731991731436.json',
            width: 200.w,
            height: 200.h,
          ),
        );
      },
    );
  }


 Widget _buildReferralList(ReferralController controller) {
  if (controller.referrals.isEmpty) {
    return Center(
      child: Text(
        "No referrals found",
        style: GoogleFonts.poppins(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  return ListView.builder(
    shrinkWrap: true, // Ensures it does not take infinite height
    physics: NeverScrollableScrollPhysics(), // Avoids nested scrolling issues
    itemCount: controller.referrals.length,
    itemBuilder: (context, index) {
      final referral = controller.referrals[index];

      return Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Leading Circle Avatar
            CircleAvatar(
              radius: 20.r,
              backgroundColor: Colors.blue,
              child: Text(
                referral.username[0].toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Referral Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _capitalizeFirstLetter(referral.username),
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    referral.email,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Referral Date
            // Text(
            //   "${DateFormat('MM/dd').format(referral.referredOn)}",
            //   style: GoogleFonts.poppins(
            //     fontSize: 12.sp,
            //     color: Colors.grey,
            //   ),
            // ),
          ],
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
