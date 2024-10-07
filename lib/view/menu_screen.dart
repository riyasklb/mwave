import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/view/profile_screen.dart';
import 'package:mwave/view/refund_and_policy.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image using BoxDecoration
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/pixelcut-export 3(1).jpeg'), // Path to your image
                fit: BoxFit.cover, // Cover the entire screen
           
              ),
            ),
          ),
           Column(
             children: [
               Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: AppBar(
                        backgroundColor:
                            Colors.transparent, // Make the AppBar transparent
                        title: Text(
                          'Dashboard',
                          style: GoogleFonts.lato(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        centerTitle: true,
                      ),
               ),
         Expanded(
           child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                buildCustomButton(
                  icon: Icons.person,
                  label: 'Profile',
                  onTap: () {
                    Get.to(ProfileScreen(
                      
                    ));
                    // Navigate to Profile screen
                  },
                ),
                buildCustomButton(
                  icon: Icons.policy,
                  label: 'Refund Policy',
                  onTap: () {
                    Get.to(RefundPolicyScreen());
                    // Navigate to Refund Policy screen
                  },
                ),
                buildCustomButton(
                  icon: Icons.privacy_tip,
                  label: 'Privacy Policy',
                  onTap: () {
                    // Navigate to Privacy Policy screen
                  },
                ),
                buildCustomButton(
                  icon: Icons.description,
                  label: 'Terms and Conditions',
                  onTap: () {
                    // Navigate to Terms and Conditions screen
                  },
                ),
                buildCustomButton(
                  icon: Icons.manage_accounts,
                  label: 'Manage Account',
                  onTap: () {
                    // Navigate to Manage Account screen
                  },
                ),
                buildCustomButton(
                  icon: Icons.share,
                  label: 'Share MoneyWave App',
                  onTap: () {
                    // Add share functionality
                  },
                ),
                buildCustomButton(
                  icon: Icons.help,
                  label: 'Help and Support',
                  onTap: () {
                    // Navigate to Help and Support screen
                  },
                ),
                buildCustomButton(
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () {
                    // Add logout functionality
                  },
                ),
              ],
            ),
         ),     ],
           ),
                SizedBox(height: 20.h),
          // Content ListView
         
        ],
      ),
    );
  }

  // Helper function to build custom buttons
  Widget buildCustomButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Space between buttons
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // Circular corners
        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1), // Button border
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
        color: Colors.white, // Button background
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF6A00D7)), // Icon with your primary color
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
