
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mwave/auth/onboard_screen.dart';






import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {


  var isLoading = false.obs; // Observable loading state

  void showToast(
    BuildContext context, {
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





Future<void> logoutUser(BuildContext context) async {
  try {
    print('---------------------- Starting logout');

    final GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
      print('---------------------- Google sign-out successful');
    }

    await FirebaseAuth.instance.signOut();
    print('---------------------- Firebase sign-out successful');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('---------------------- SharedPreferences cleared');

    // Optionally wait for a moment before checking the user state
    await Future.delayed(Duration(seconds: 1));

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('User is logged out successfully.');
    } else {
      print('User is still logged in: ${currentUser.uid}');
    }

    Get.offAll(() => OnboardScreen());update();
  } catch (e) {
    print('---------------------- Logout failed: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logout failed: $e')),
    );
  }
}


}
