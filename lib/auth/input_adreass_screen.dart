import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mwave/auth/onboard_screen.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/onboardvideo/video_scree.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AddressAndPhoneCollectionScreen extends StatefulWidget {
  final String? photo;
  final String email;
  final String? username;

  AddressAndPhoneCollectionScreen({
    this.photo,
    required this.email,
    required this.username,
  });

  @override
  State<AddressAndPhoneCollectionScreen> createState() => _AddressAndPhoneCollectionScreenState();
}

class _AddressAndPhoneCollectionScreenState extends State<AddressAndPhoneCollectionScreen> {
  bool isLoading=false;

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _placeController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _submitData(BuildContext context) async {
    final address = _addressController.text.trim();
    final phone = _phoneController.text.trim();
    final place = _placeController.text.trim();

    if (address.isEmpty || phone.isEmpty || place.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      setState(() {
          isLoading=true; 
      });
   
      final User? user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not authenticated. Please log in.')),
        );
        Get.to(OnboardScreen());
        return;
      }

      String uid = user.uid;
      await _firestore.collection('users').doc(widget.email).set({
        'uid': uid,
        'email': widget.email,
        'username': widget.username ?? 'Anonymous',
        'photo': widget.photo ?? '',
        'address': address,
        'phone': phone,
        'place': place,
        'referralUsed': false,
        'referralId': _generateReferralCode(widget.email),
      });

      await _storeRegistrationStatus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Details submitted successfully!')),
      );

      _addressController.clear();
      _phoneController.clear();
      _placeController.clear();
      Get.offAll(VideoSelectionScreen());
      setState(() {
        isLoading=false;
      });
      
    } catch (e) {
       setState(() {
        isLoading=false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit details: $e')),
      );
    }
  }

  Future<void> _storeRegistrationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRegistered', true);
    await prefs.setString('email', widget.email);
  }

  Future<void> _logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await _googleSignIn.signOut();
      await _auth.signOut();
      await prefs.setBool('isRegistered', false);
      Get.to(OnboardScreen());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to logout: $e')),
      );
    }
  }

  String _generateReferralCode(String email) {
    return email.hashCode.toString().substring(0, 6);
  }

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
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40.w,
                      backgroundImage: widget.photo != null && widget.photo!.isNotEmpty
                          ? NetworkImage(widget.photo!)
                          : null,
                      child: widget.photo == null || widget.photo!.isEmpty
                          ? Icon(Icons.person, size: 40.sp)
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      widget.username ?? 'Anonymous',
                      style: GoogleFonts.poppins(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: kblack),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      widget.email,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        color: kblack,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildTextField('Address', _addressController),
                    _buildTextField(
  'Phone Number',
  _phoneController,
  keyboardType: TextInputType.phone,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly, // Allows only numeric input
    LengthLimitingTextInputFormatter(10),  // Limits input to 10 characters
  ],
),

              
                    _buildTextField('Place', _placeController),
                    SizedBox(height: 16.h),
                    Text(
                      'Your Referral Code: ${_generateReferralCode(widget.email)}',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => _submitData(context),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity,
                            40.h), // Full-width and taller button
                        backgroundColor: kblue, // Custom background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30.r), // Rounded button
                        ),
                        elevation: 8, // Elevation for shadow effect
                        padding: EdgeInsets.symmetric(
                            vertical: 16.h), // Increased padding
                      ),
                      child: Text(
                        'Submit',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          color: Colors.white, // Text color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),



                   isLoading==true ? CircularProgressIndicator(): ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          print('---------------------- Starting logout');

                          // Sign out from Google if used
                          final GoogleSignIn googleSignIn = GoogleSignIn();
                          if (await googleSignIn.isSignedIn()) {
                            await googleSignIn.signOut();
                            print(
                                '---------------------- Google sign-out successful');
                          }

                          // Sign out from Firebase
                          await FirebaseAuth.instance.signOut();
                          print(
                              '---------------------- Firebase sign-out successful');

                          // Clear all preferences
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.clear();
                          print(
                              '---------------------- SharedPreferences cleared');

                          // Navigate to Onboard Screen
                          Get.offAll(() => OnboardScreen());
                        } catch (e) {
                          print('---------------------- Logout failed: $e');
                        }
                        Get.back();
                      },
                      // _logout(context),
                      icon:
                          Icon(Icons.logout, size: 24.sp, color: Colors.white),
                      label: Text(
                        'Logout',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(double.infinity, 40.h), // Full-width button
                        backgroundColor:
                            Colors.redAccent, // Logout button color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30.r), // Rounded corners
                        ),
                        elevation: 8, // Shadow effect
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildTextField(String label, TextEditingController controller,
    {TextInputType keyboardType = TextInputType.text, List<TextInputFormatter>? inputFormatters}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters, // Add input formatters here
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        contentPadding:
            EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r), // Circular border
          borderSide: BorderSide.none, // Removes the default border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(color: kblue, width: 2),
        ),
      ),
      style: TextStyle(fontSize: 16.sp),
    ),
  );
}

}
