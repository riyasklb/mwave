import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore for storing user details
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mwave/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mwave/controllers/auth_controller.dart';
import 'otp_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
   final AuthController authController = Get.put(AuthController());
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance

  // Check if the phone number is registered in Firestore
  Future<bool> isPhoneNumberRegistered(String phoneNumber) async {
    final querySnapshot = await _firestore
        .collection('users') // Assuming you have a collection named 'users'
        .where('phone', isEqualTo: phoneNumber)
        .get();

    return querySnapshot
        .docs.isNotEmpty; // If docs exist, phone number is registered
  }

  void loginWithPhoneNumber() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      String phoneNumberWithPrefix = '+91' + phoneController.text.trim();

      // Check if the phone number is registered
      bool isRegistered = await isPhoneNumberRegistered(phoneController.text);

      if (isRegistered) {
        try {
          await _auth.verifyPhoneNumber(
            phoneNumber: phoneNumberWithPrefix,
            timeout: const Duration(seconds: 60),
            verificationCompleted: (PhoneAuthCredential credential) async {
              await _auth.signInWithCredential(credential);
              setState(() {
                isLoading = false;
              });
            },
            verificationFailed: (FirebaseAuthException e) {
              setState(() {
                isLoading = false;
              });
  authController.showToasr(context,
          text: 'Verification failed: ${e.message}',
          icon: Icons.error,
        );

              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text('Verification failed: ${e.message}')),
              // );
            },
            codeSent: (String verificationId, int? resendToken) {
              setState(() {
                isLoading = false;
              });
              authController.showToasr(context,
          text: 'OTP Sent to your phone',
          icon: Icons.check,
        );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtpPage(
                    phoneNumber: phoneController.text,
                    verificationId: verificationId,
                  ),
                ),
              );
            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          );
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          authController.showToasr(context,
          text: 'Error: ${e.toString()}',
          icon: Icons.error,
        );
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Error: ${e.toString()}')),
          // );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        authController.showToasr(context,
          text: 'This phone number is not registered',
          icon: Icons.error,
        );

   
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(custombagroundimage),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              kheight40,
              AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  'Log in',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.transparent,
              ),
              kheight40,
              kheight40,
              kheight40,
              kheight40,
              kheight40,
              kheight40,
              Text(
                'Enter your phone number',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                  hintText: 'Please enter your phone number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: kblue, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '🇮🇳', // Indian flag emoji as the icon
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                            width: 5), // Spacing between flag and prefix text
                        Text(
                          '+91',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 10.0),
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
                    backgroundColor: kblue,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login with OTP'),
                ),
              ),
              kheight40,
              kheight40,
              kheight40,
              kheight40,
            ],
          ),
        ),
      ),
    );
  }
}
