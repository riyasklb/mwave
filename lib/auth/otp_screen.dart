import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/onboardvideo/video_scree.dart';


class OtpPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpPage({required this.phoneNumber, required this.verificationId, Key? key}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void verifyOtp() async {
    setState(() {
      isLoading = true;
    });

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpController.text,
      );
      await _auth.signInWithCredential(credential);

      setState(() {
        isLoading = false;
      });

      // Navigate to home page or show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
        Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  VideoSelectionScreen()),
                  );
// Optionally pop the screen or navigate elsewhere
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP',style: TextStyle(color: Colors.white),),
        backgroundColor:  kblue,
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
                onPressed: isLoading ? null : verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor:  kblue,
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
