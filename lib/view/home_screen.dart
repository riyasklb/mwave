import 'package:flutter/material.dart';

import 'package:mwave/auth/login_screen.dart';
import 'package:mwave/auth/register_screen.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Center the entire content
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Vertically center the items
            crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center the items
            children: [
              // Logo at the top center
              Image.asset('assets/images/WhatsApp Image 2024-10-03 at 2.50.54 PM(1).jpeg', height: 120), // Add your logo here
              const SizedBox(height: 40),

              // Login Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Log in', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 16),

              // Register Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text(
                  'Register',
                  style: TextStyle(color: Color(0xFF6A00D7), fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),

              // Help Text
              TextButton(
                onPressed: () {
                  // Add help functionality
                },
                child: const Text('Need Help?', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
