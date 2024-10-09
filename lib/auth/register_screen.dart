import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/onboardvideo/video_scree.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _username = '';
  String _email = '';
  String _phone = '';
  String _address = '';
  String _place = '';
  String _otp = '';

  bool _isLoading = false;
  bool _isOtpSent = false;
  String _verificationId = '';

  void _sendOtp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        String phoneNumberWithPrefix = '+91' + _phone.trim();

        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumberWithPrefix,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Automatically sign in if OTP is detected
            await _auth.signInWithCredential(credential);
            await _saveUserToFirestore();
          },
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Verification failed: ${e.message}')),
            );
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              _isLoading = false;
              _isOtpSent = true; // Show OTP input after OTP is sent
              _verificationId = verificationId;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP sent successfully!')),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          },
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otp,
      );

      // Sign in with the OTP credential
      await _auth.signInWithCredential(credential);
      await _saveUserToFirestore();
     Get.to( VideoSelectionScreen());
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verification failed: $e')),
      );
    }
  }




Future<void> _saveUserToFirestore() async {
  try {
    // Get the current user's UID
    String uid = _auth.currentUser!.uid;

    // Generate a unique referral ID
    String referralId = _generateReferralId();

    // Save user info to Firestore with the referral ID and uid
    await _firestore.collection('users').doc(uid).set({
      'username': _username,
      'email': _email,
      'phone': _phone,
      'address': _address,
      'place': _place,
      'referralId': referralId, // Store the referral ID
      'uid': uid, // Store the user UID
    });

    // Save UID to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);

    setState(() {
      _isLoading = false;
    });

    // Navigate to login screen or show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User registered successfully with Referral ID!')),
    );
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving user: $e')),
    );
  }
}

// Function to retrieve user id from shared preferences
Future<String?> _getUserIdFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('uid');
}


// Function to generate a unique referral ID
String _generateReferralId() {
  // Using UUID (universally unique identifier) to generate a unique ID
  var uuid = const Uuid();
  return uuid.v4(); // v4 is a random UUID
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _isOtpSent ? 'Verify OTP' : 'Register',
          style: TextStyle(color: kwhite),
        ),
        backgroundColor: kblue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    if (!_isOtpSent) ...[
                      // Username field
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Username'),
                        onSaved: (value) {
                          _username = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email field
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {
                          _email = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone number field
                      TextFormField(
                        decoration:
                            const InputDecoration(hintText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                        onSaved: (value) {
                          _phone = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          if (value.length != 10) {
                            return 'Enter a valid 10-digit phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Address field
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Address'),
                        onSaved: (value) {
                          _address = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Place field
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Place'),
                        onSaved: (value) {
                          _place = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a place';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Send OTP button
                      ElevatedButton(
                        onPressed: _sendOtp,
                        child: const Text('Send OTP',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ],

                    if (_isOtpSent) ...[
                      // OTP field
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Enter OTP'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _otp = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty || value.length != 6) {
                            return 'Please enter a valid 6-digit OTP';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Verify OTP button
                      ElevatedButton(
                        onPressed: _verifyOtp,
                        child: const Text('Verify OTP',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
