import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mwave/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
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
      try {
        // Add +91 prefix to the phone number
        String phoneNumberWithPrefix = '+91' + phoneController.text.trim();

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
        automaticallyImplyLeading: false,
        title: Text(
          'Log in',
          style: TextStyle(color: kwhite),
        ),
        backgroundColor: const Color(0xFF6A00D7),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A00D7), Color(0xFF8E2DE2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter your phone number',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Updated TextFormField
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                //  labelText: 'Phone Number',
                  hintText: 'e.g. 96337497xx',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    borderSide: BorderSide(color: Colors.white), // Border color
                  ),
                   focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF6A00D7), width: 2), // Focused border color
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixText: '+91 ',
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
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
