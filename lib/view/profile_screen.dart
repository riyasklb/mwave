import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../constants/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Fetch user details from Firestore based on user ID
  Future<Map<String, dynamic>> _getUserDetails() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Reference to Firestore 'users' collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.email)
          .get();

      if (userDoc.exists) {
        // Return user data
        return userDoc.data() as Map<String, dynamic>;
      } else {
        throw Exception("User not found");
      }
    } else {
      throw Exception("No user logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserDetails(),
        builder: (context, snapshot) {
          // Skeleton loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Skeletonizer(
              enabled: true,
              child: _buildSkeletonLoading(), // Display skeleton when loading
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching profile details'));
          }

          if (snapshot.hasData) {
            // Extract user details from Firestore
            final userData = snapshot.data!;
            final String name = userData['username'] ?? 'No username';
            final String email = userData['email'] ?? 'No email';
            final String phone = userData['phone'] ?? 'No phone';
            final String address = userData['address'] ?? 'No address';
            final String place = userData['place'] ?? 'No place';
            final String referralId = userData['referralId'] ?? 'No referral ID';
            final String uid = userData['uid'] ?? 'No UID';
            // final String avatarUrl = userData['avatar'] ?? 'assets/images/default_avatar.png';

            return Stack(
              children: [
                // Background image using BoxDecoration
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(custombagroundimage), // Background image path
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
                          'Profile',
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
                    SizedBox(height: 20.h), // Responsive spacing

                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Avatar section
                            // CircleAvatar(
                            //   radius: 50,
                            //   backgroundImage: avatarUrl.startsWith('http') 
                            //       ? NetworkImage(avatarUrl) // If avatar is a URL
                            //       : AssetImage(avatarUrl), // Local image fallback
                            // ),
                            SizedBox(height: 20.h),

                            // Profile information sections
                            buildProfileInfoSection(Icons.person, 'Username', name),
                            SizedBox(height: 20.h),
                            buildProfileInfoSection(Icons.email, 'Email', email),
                            SizedBox(height: 20.h),
                            buildProfileInfoSection(Icons.phone, 'Phone', phone),
                            SizedBox(height: 20.h),
                            buildProfileInfoSection(Icons.home, 'Address', address),
                            SizedBox(height: 20.h),
                            buildProfileInfoSection(Icons.location_on, 'Place', place),
                            SizedBox(height: 20.h),
                            buildProfileInfoSection(Icons.code, 'Referral ID', referralId),
                            SizedBox(height: 20.h),
                            buildProfileInfoSection(Icons.vpn_key, 'UID', uid),
                            SizedBox(height: 40.h),

                            // Save Profile Button with gradient
                            // Center(
                            //   child: ElevatedButton(
                            //     onPressed: () {
                            //       // Show a snackbar when button is pressed
                            //       ScaffoldMessenger.of(context).showSnackBar(
                            //         const SnackBar(
                            //           content: Text('Profile saved successfully!'),
                            //         ),
                            //       );
                            //     },
                            //     style: ElevatedButton.styleFrom(
                            //       padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(30), // Rounded button
                            //       ),
                            //       elevation: 5, // Button shadow
                            //     ),
                            //     child: Text(
                            //       'Save Profile',
                            //       style: TextStyle(
                            //         fontSize: 18.sp,
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.white,
                            //         letterSpacing: 1.2,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          return const Center(child: Text('No profile data found'));
        },
      ),
    );
  }

  // Helper function to create styled profile info sections
  Widget buildProfileInfoSection(IconData icon, String title, String value) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), // Slightly transparent white background
        borderRadius: BorderRadius.circular(20), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5), // Shadow effect
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6A00D7), size: 28.w), // Add icon to section
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

  // Function to build skeleton loading UI
  Widget _buildSkeletonLoading() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: List.generate(6, (index) => _skeletonLoadingItem()), // Create multiple skeleton items
    );
  }

  // Function to create a single skeleton loading item
  Widget _skeletonLoadingItem() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Skeletonizer(
        enabled: true,
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9), // Slightly transparent white background
            borderRadius: BorderRadius.circular(20), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5), // Shadow effect
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                color: Colors.grey[300], // Placeholder for icon
              ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100.w,
                    height: 16.h,
                    color: Colors.grey[300], // Placeholder for title
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    width: 80.w,
                    height: 16.h,
                    color: Colors.grey[300], // Placeholder for value
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
