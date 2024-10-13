import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/auth/login_screen.dart';
import 'package:mwave/auth/register_screen.dart';
import 'package:mwave/constants/colors.dart';

class Onboard_screen extends StatelessWidget {
  const Onboard_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use Stack to layer background image and gradient
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              custombagroundimage, // Replace with your background image path
              fit: BoxFit.cover, // Ensure the image covers the entire screen
            ),
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kblue.withOpacity(0.1),
                  const Color(0xFF8E2DE2).withOpacity(0.1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Vertically center the items
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Horizontally center the items
                children: [
                  // Logo at the top center
                  CircleAvatar(
                    radius: 80, // Half of the desired height
                    backgroundImage: const AssetImage(
                      'assets/images/WhatsApp Image 2024-10-03 at 2.50.54 PM(1).jpeg',
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Welcome Text
                  Text(
                    'Money Wave',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Login Button
                  SizedBox(
                    width: double.infinity, // Full-width button
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        ),
                        elevation: 5, // Shadow effect
                      ),
                      onPressed: () {

                        Get.to(LoginPage());
                     
                      },
                      child: Text(
                        'Log in',
                        style: GoogleFonts.poppins(
                          color: kblue, // Text color matches the theme
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity, // Full-width button
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: null,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        ),
                        elevation: 5, // Shadow effect
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      child: Text(
                        'Register',
                        style: GoogleFonts.poppins(
                          color: kwhite, // Text color matches the theme
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Help Text
                  TextButton(
                    onPressed: () {
                      // Add help functionality
                    },
                    child: Text(
                      'Need Help?',
                      style: GoogleFonts.poppins(
                        color: kblue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
