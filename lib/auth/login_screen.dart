import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'otp_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void loginWithPhoneNumber() async {
  if (_formKey.currentState?.validate() ?? false) {
    setState(() {
      isLoading = true;
    });
    print('--------------1--------------');
    try {
      // Add +91 prefix to the phone number
      String phoneNumberWithPrefix = '+91' + phoneController.text.trim();

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumberWithPrefix,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatically handles SMS code (optional)
          print('--------------2--------------');
          await _auth.signInWithCredential(credential);
          setState(() {
            isLoading = false;
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpPage(
                phoneNumber: phoneNumberWithPrefix,
                verificationId: verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieve timeout
        },
      );
    } catch (e) {
      print('--------------errorlast--------------');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
        backgroundColor: const Color(0xFF6A00D7),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter your phone number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

             TextFormField(
  controller: phoneController,
  decoration: const InputDecoration(
    labelText: 'Phone Number',
    hintText: 'e.g. 123 456 7890',
    border: OutlineInputBorder(),
    prefixText: '+91 ', // Adding the +91 prefix
  ),
  keyboardType: TextInputType.phone,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length < 10) {
      return 'Enter a valid phone number';
    }
    return null;
  },
),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : loginWithPhoneNumber,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A00D7),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login with OTP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
