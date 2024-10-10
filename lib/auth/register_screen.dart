import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/constants/widgets/custom_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:mwave/onboardvideo/video_scree.dart';

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
              _isOtpSent = true;
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

      await _auth.signInWithCredential(credential);
      await _saveUserToFirestore();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => VideoSelectionScreen()));
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
      String uid = _auth.currentUser!.uid;
      String referralId = _generateReferralId();

      await _firestore.collection('users').doc(uid).set({
        'username': _username,
        'email': _email,
        'phone': _phone,
        'address': _address,
        'place': _place,
        'referralId': referralId,
        'uid': uid,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', uid);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('User registered successfully with Referral ID!')),
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

  String _generateReferralId() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/pixelcut-export 3(1).jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(
                    _isOtpSent ? 'Verify OTP' : 'Register',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                Form(
                  key: _formKey,
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: Center(
                            child: ListView(
                              children: [
                                kheight40,
                                kheight40,
                                if (!_isOtpSent) ...[
                                  CustomTextField(
                                    hintText: 'Username',
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
                                  CustomTextField(
                                    hintText: 'Email',
                                    keyboardType: TextInputType.emailAddress,
                                    onSaved: (value) {
                                      _email = value!;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !value.contains('@')) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextField(
                                    hintText: 'Phone Number',
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
                                  CustomTextField(
                                    hintText: 'Address',
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
                                  CustomTextField(
                                    hintText: 'Place',
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
                                  kheight40,
                                  ElevatedButton(
                                    onPressed: _sendOtp,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: const Text('Send OTP',
                                          style: TextStyle(fontSize: 18)),
                                    ),
                                  ),
                                ],
                                if (_isOtpSent) ...[
                                  kheight40,
                                  kheight40,
                                  kheight40,
                                  kheight40,
                                  CustomTextField(
                                    hintText: 'Enter OTP',
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
                                  ElevatedButton(
                                    onPressed: _verifyOtp,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: const Text('Verify OTP',
                                          style: TextStyle(fontSize: 18)),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
