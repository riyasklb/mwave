import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mwave/constants/colors.dart';

class RefundPolicyScreen extends StatelessWidget {
  const RefundPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image using BoxDecoration
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(custombagroundimage), // Background image
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppBar(automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent, // Transparent AppBar
                  title: Text(
                    'Refund Policy',
                    style: GoogleFonts.lato(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  centerTitle: true,
                  elevation: 0, // Remove shadow under AppBar
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Please provide your details for initiating the refund process.',
                  style: GoogleFonts.lato(
                    fontSize: 14.sp,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.h), // Space between text and form

              // Refund Policy Section
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Refund Policy for MoneyWave',
                      style: GoogleFonts.lato(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      '• If you pay ₹100 and refer someone, you will not receive a refund in MoneyWave.\n\n'
                      '• If you pay ₹100 and refer no one, you will receive a refund after 100 days in MoneyWave.',
                      style: GoogleFonts.lato(
                        fontSize: 14.sp,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),

              Expanded(
                child: FutureBuilder<Map<String, String>>(
                  future: _fetchUserData(), // Fetch user data
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildSkeletonLoader(); // Display skeleton loader while fetching data
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text('Error fetching user data'));
                    }

                    if (snapshot.hasData) {
                      // Extract user details from fetched data
                      final userData = snapshot.data!;
                      final String name = userData['username'] ?? 'No name';
                      final String ioNumber = userData['referralId'] ?? 'No IO Number';
                      final String phoneNumber = userData['phone'] ?? 'No Phone Number';

                      return SingleChildScrollView(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildInfoSection(Icons.person, 'Name', name),
                            SizedBox(height: 20.h), // Responsive spacing
                            buildInfoSection(Icons.assignment_ind, 'IO Number', ioNumber),
                            SizedBox(height: 20.h),
                            buildInfoSection(Icons.phone, 'Phone Number', phoneNumber),
                            SizedBox(height: 40.h), // Space before the button

                            // Submit Button
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Add Submit logic here
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                                  backgroundColor: null,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.r), // Rounded button
                                  ),
                                  elevation: 5,
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 29.h),

                            // Footer Disclaimer
                            Center(
                              child: Text(
                                'By submitting, you agree to our refund policy.',
                                style: GoogleFonts.lato(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return const Center(child: Text('No profile data found'));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



Future<Map<String, String>> _fetchUserData() async {
  // Get the current user
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('User not logged in');
  }

  // Fetch user data from Firestore
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users') // Change 'users' to your Firestore collection name
      .doc(user.email) // Use the user ID as the document ID
      .get();

  if (!snapshot.exists) {
    throw Exception('User data not found');
  }

  // Assuming your document has 'username', 'referralId', and 'phone' fields
  final userData = snapshot.data() as Map<String, dynamic>;
  return {
    'username': userData['username'] ?? 'No name',
    'referralId': userData['referralId'] ?? 'No IO Number',
    'phone': userData['phone'] ?? 'No Phone Number',
  };
}


  // Build skeleton loader for profile info sections
  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSkeletonItem(),
          SizedBox(height: 20.h),
          _buildSkeletonItem(),
          SizedBox(height: 20.h),
          _buildSkeletonItem(),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  // Skeleton item widget
  Widget _buildSkeletonItem() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 252, 249, 249).withOpacity(0.3), // Light grey background
        borderRadius: BorderRadius.circular(20.r), // Rounded corners
      ),
      height: 60.h, // Fixed height for skeleton items
      child: Row(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 254, 254).withOpacity(0.5), // Grey circle
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 12.h,
                  color: const Color.fromARGB(255, 220, 217, 217).withOpacity(0.5), // Grey rectangle
                ),
                SizedBox(height: 5.h),
                Container(
                  width: double.infinity,
                  height: 12.h,
                  color: const Color.fromARGB(255, 217, 214, 214).withOpacity(0.5), // Grey rectangle
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to create styled info sections
  Widget buildInfoSection(IconData icon, String title, String value) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), // Slightly transparent white background
        borderRadius: BorderRadius.circular(20.r), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5), // Shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6A00D7), size: 28.w), // Add icon
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6A00D7), // Primary theme color
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
