import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image using BoxDecoration
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/pixelcut-export 3(1).jpeg'), // Background image path
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppBar(
                  backgroundColor: Colors.transparent, // Transparent AppBar
                  title: Text(
                    'Edit Profile',
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
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/WhatsApp Image 2024-10-03 at 2.50.54 PM(1).jpeg'), // Update with your avatar image path
                      ),
                      SizedBox(height: 20.h),

                      // Profile information sections
                      buildProfileInfoSection(Icons.person, 'Name', 'John Doe'), // Replace with actual data
                      SizedBox(height: 20.h),
                      buildProfileInfoSection(Icons.cake, 'Date of Birth', 'XX/XX/XXXX'),
                      SizedBox(height: 20.h),
                      buildProfileInfoSection(Icons.male, 'Gender', 'Male'),
                      SizedBox(height: 20.h),
                      buildProfileInfoSection(Icons.location_on, 'State', 'California'),
                      SizedBox(height: 40.h),

                      // Save Profile Button with gradient
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Show a snackbar when button is pressed
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile saved successfully!'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), // Rounded button
                            ),
                            elevation: 5, // Button shadow
                          
                          ),
                          child:   Text(
                                'Save Profile',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
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
}
