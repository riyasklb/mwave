import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mwave/auth/otp_screen.dart';
import 'package:mwave/onboardvideo/video_scree.dart';
import 'package:mwave/view/bottumbar1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  var isLoading = false.obs; // Observable loading state

  void showToast(BuildContext context, { 
    required String text,
    IconData icon = Icons.info,
  }) {
    try {
      DelightToastBar(
        autoDismiss: true,
        position: DelightSnackbarPosition.top,
        builder: (context) {
          return ToastCard(
            leading: Icon(
              icon,
              size: 28,
            ),
            title: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          );
        },
      ).show(context); // Now context is passed here
    } catch (e) {
      print(e);
    }
  }

  Future<bool> isPhoneNumberRegistered(String phoneNumber) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phoneNumber)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking phone number: $e');
      return false;
    }
  }

  void loginWithPhoneNumber(String phoneNumber, BuildContext context) async {
    if (phoneNumber.isEmpty || phoneNumber.length < 10) {
      showToast(context, text: 'Enter a valid phone number', icon: Icons.error);
      return;
    }

    isLoading.value = true;
    String phoneNumberWithPrefix = '+91' + phoneNumber.trim(); // For OTP verification

    bool isRegistered = await isPhoneNumberRegistered(phoneNumber); // Check without prefix

    if (isRegistered) {
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumberWithPrefix,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            isLoading.value = false;
            await checkUserByPhoneNumber(phoneNumber); // Check without prefix
          },
          verificationFailed: (FirebaseAuthException e) {
            isLoading.value = false;
            showToast(context, text: 'Verification failed: ${e.message}', icon: Icons.error);
          },
          codeSent: (String verificationId, int? resendToken) {
            isLoading.value = false;
            showToast(context, text: 'OTP sent to your phone', icon: Icons.check);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpPage(
                  phoneNumber: phoneNumber,
                  verificationId: verificationId,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } catch (e) {
        isLoading.value = false;
        showToast(context, text: 'Error: ${e.toString()}', icon: Icons.error);
      }
    } else {
      isLoading.value = false;
      showToast(context, text: 'This phone number is not registered', icon: Icons.error);
    }
  }

  Future<void> verifyOtp(String verificationId, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      showToast(Get.context!, text: 'User logged in successfully!', icon: Icons.check);
      
      await checkUserByPhoneNumber(userCredential.user?.phoneNumber?.replaceFirst('+91', '') ?? ''); // Check without prefix
    } catch (e) {
      showToast(Get.context!, text: 'OTP verification failed: $e', icon: Icons.error);
      throw e; // Rethrow the exception to handle it in the calling method if needed
    }
  }

 Future<void> checkUserByPhoneNumber(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        String userId = userDoc.id;
        await saveUserIdToPrefs(userId);
        showToast(Get.context!, text: 'User found and logged in successfully!', icon: Icons.check);
        
        Get.offAll(BottumNavBar());
      } else {
        showToast(Get.context!, text: 'No account found with this phone number.', icon: Icons.error);
      }
    } catch (e) {
      showToast(Get.context!, text: 'Error fetching user details: $e', icon: Icons.error);
    }
  }

  Future<void> saveUserIdToPrefs(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', userId);
  }

Future<void> resendOtp(String phoneNumber, BuildContext context) async {
  if (phoneNumber.isEmpty || phoneNumber.length < 10) {
    showToast(context, text: 'Enter a valid phone number', icon: Icons.error);
    return;
  }

  isLoading.value = true; // Start loading

  try {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber', // Add country code for India
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatically sign in if the verification is successful
        await _auth.signInWithCredential(credential);
        isLoading.value = false; // Stop loading
        showToast(context, text: 'User logged in successfully!', icon: Icons.check);
        await checkUserByPhoneNumber(phoneNumber); // Check without prefix
      },
      verificationFailed: (FirebaseAuthException e) {
        isLoading.value = false; // Stop loading
        showToast(context, text: 'Failed to resend OTP: ${e.message}', icon: Icons.error);
      },
      codeSent: (String verificationId, int? resendToken) {
        isLoading.value = false; // Stop loading
        showToast(context, text: 'OTP resent successfully!', icon: Icons.check);
        // Optionally navigate to OTP verification page if needed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpPage(
              phoneNumber: phoneNumber,
              verificationId: verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle auto-retrieval timeout if needed
        isLoading.value = false; // Stop loading
      },
    );
  } catch (e) {
    isLoading.value = false; // Stop loading
    showToast(context, text: 'Error: ${e.toString()}', icon: Icons.error);
  }
}

  final GoogleSignIn _googleSignIn = GoogleSignIn();
//  var isLoading = false.obs;

  Future<void> loginWithGoogle() async {
    try {
     // isLoading.value = true;
      final user = await _googleSignIn.signIn();
      if (user != null) {
        print('Google User: ${user.displayName}');
        // Handle navigation or authentication logic here.
      }
    } catch (e) {
      print('Error during Google Sign-In: $e');
    } finally {
    //  isLoading.value = false;
    }
  }

}
