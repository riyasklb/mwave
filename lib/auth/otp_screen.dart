import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/view/bottumbar1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpPage({
    required this.phoneNumber,
    required this.verificationId,
    Key? key,
  }) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to verify OTP
  void _verifyOtp() async {
    setState(() {
      isLoading = true;
    });

    try {
      String _otp = otpController.text.trim();

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otp,
      );

      // Sign in with the OTP credential
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Get user ID from Firebase Auth
      String userId = userCredential.user!.uid;
print('----------------------------------------${widget.phoneNumber}}---------------------------------');
      // Check if phone number is already registered in Firestore
      await _checkUserByPhoneNumber(widget.phoneNumber);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verification failed: $e')),
      );
    }
  }

  // Method to check user details by phone number
  Future<void> _checkUserByPhoneNumber(String phoneNumber) async {
    try {
      // Query Firestore for a user with the provided phone number
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // User with this phone number exists
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Get the user ID (uid) from the document
        String userId = userDoc.id;

        // Store the user ID in SharedPreferences
        await _saveUserIdToPrefs(userId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User found and logged in successfully!')),
        );

        // Navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottumNavBar()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No account found with this phone number.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user details: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Save user ID in SharedPreferences
  Future<void> _saveUserIdToPrefs(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter OTP',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kblue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter the OTP sent to your phone',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: otpController,
              decoration: const InputDecoration(
                labelText: 'OTP',
                hintText: '000000',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kblue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Verify OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
