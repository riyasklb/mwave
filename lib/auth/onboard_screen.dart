import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/auth/login_screen.dart';
import 'package:mwave/auth/register_screen.dart';

class Onboard_screen extends StatelessWidget {
  const Onboard_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient Background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A00D7), Color(0xFF8E2DE2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
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
                  backgroundImage: AssetImage(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: Text(
                      'Log in',
                      style: GoogleFonts.poppins(
                        color: const Color(
                            0xFF6A00D7), // Text color matches the theme
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                        color: Colors.white,
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
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}