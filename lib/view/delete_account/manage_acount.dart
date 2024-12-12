import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/controllers/auth_controller.dart';
import 'package:mwave/onboardvideo/splash_initial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Delete Account",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: kblue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Are you sure you want to delete your account?",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Deleting your account will remove all your data permanently. This action cannot be undone.",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kblue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () async {
                bool confirm = await _showConfirmationDialog(context);
                if (confirm) {
                  await _deleteAccount(context);
                }
              },
              child: Text(
                "Delete My Account",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Confirmation Dialog
  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Confirm Deletion",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              content: Text(
                "This action cannot be undone. Are you sure you want to delete your account?",
                style: GoogleFonts.poppins(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kblue,
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    "Delete",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if dialog is dismissed
  }

Future<void> _deleteAccount(BuildContext context) async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user is signed in.',
      );
    }

    // Initialize Firestore
    final firestore = FirebaseFirestore.instance;

    // Reference to the user's main document
    final userDocRef = firestore.collection('users').doc(user.email);

    // Delete all documents in the 'payments' subcollection
    final paymentsSnapshot = await userDocRef.collection('payments').get();
    for (final paymentDoc in paymentsSnapshot.docs) {
      await paymentDoc.reference.delete();
    }

    // Delete all documents in the 'referrals' subcollection
    final referralsSnapshot = await userDocRef.collection('referrals').get();
    for (final referralDoc in referralsSnapshot.docs) {
      await referralDoc.reference.delete();
    }

      final withdrawalSnapshot = await userDocRef.collection('withdrawal_history').get();
    for (final withdrawalDoc in withdrawalSnapshot.docs) {
      await withdrawalDoc.reference.delete();
    }

    // Delete the main user document
    await userDocRef.delete();

    // Clear SharedPreferences (local data)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Logout user using AuthController
    final AuthController authController = Get.put(AuthController());
    authController.logoutUser(context);

    // Delete the Firebase Authentication account
  //  await user.delete();

    // Show success message
    Get.snackbar(
      "Account Deleted",
      "Your account and all associated data have been successfully deleted.",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );

    // Navigate to splash screen
    Get.offAll(VideoSplashScreen());
  } catch (e) {
    print(e);
    Get.snackbar(
      "Error",
      "An error occurred while deleting your account. Please try again.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

}
