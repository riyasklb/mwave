import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mwave/constants/colors.dart';

class ShareReferralScreen extends StatefulWidget {
  const ShareReferralScreen({Key? key}) : super(key: key);

  @override
  _ShareReferralScreenState createState() => _ShareReferralScreenState();
}

class _ShareReferralScreenState extends State<ShareReferralScreen> {
  String referralCode = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReferralCode();
  }



Future<void> fetchReferralCode() async {
  try {
    // Get the current user ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception('User not logged in');
    }

    // Fetch the referralId for the logged-in user
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
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
      appBar: AppBar(
        title: Text(
          'Share Referral Code',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0.sp),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  Text(
                    'Your Referral Code',
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: kwhite,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _buildReferralCodeDisplay(),
                  SizedBox(height: 40.h),
                  _buildShareButtons(),
                ],
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
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.sp),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        ElevatedButton.icon(
          icon: Icon(Icons.close),
          label: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context); // Close the screen
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
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
}
