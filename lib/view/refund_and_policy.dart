import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                image: AssetImage('assets/images/pixelcut-export 3(1).jpeg',), // Background image
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildInfoSection(Icons.person, 'Name', 'John Doe'), // Replace with actual data
                      SizedBox(height: 20.h), // Responsive spacing
                      buildInfoSection(Icons.assignment_ind, 'IO Number', '123456'),
                      SizedBox(height: 20.h),
                      buildInfoSection(Icons.phone, 'Phone Number', '+123 456 7890'),
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
                ),
              ),
            ],
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
