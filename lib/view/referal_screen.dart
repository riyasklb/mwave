import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReferralScreen extends StatefulWidget {
  @override
  _ReferralScreenState createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final TextEditingController _referralCodeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? uid;
  String? username;
  String? email;
  String? phone;
  String? address;
  String? place;
  bool referralUsed = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      setState(() {
        uid = currentUser.uid;
      });

      var userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        setState(() {
          username = userDoc['username'];
          email = userDoc['email'];
          phone = userDoc['phone'];
          address = userDoc['address'];
          place = userDoc['place'];
          referralUsed = userDoc['referralUsed'] ?? false; // Check if referral code has been used
        });
      }
    }
  }

  Future<void> addReferral(String referralId) async {
    try {
      print(referralUsed);
      // Step 1: Check if the user (C) has already used a referral code
      if (referralUsed) {

        Get.snackbar(
          'Error',
          'You have already used a referral code.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Step 2: Find the user with the referralId (User B)
      var referrerDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('referralId', isEqualTo: referralId)
          .get();
 print('----------------------1------------------------------');
      if (referrerDoc.docs.isNotEmpty) {
        // User B found
         print('-------------------2---------------------------------');
        String referrerUid = referrerDoc.docs.first.id;
        var referrerData = referrerDoc.docs.first.data();
 print('---------------------------3-------------------------');
        // Step 3: Update User B's wallet (add ₹50)
        int referrerWallet = referrerData.containsKey('wallet') ? referrerData['wallet'] : 0;
        await FirebaseFirestore.instance.collection('users').doc(referrerUid).update({
          'wallet': referrerWallet + 50,
          
        });
 print('-----------------------------4-----------------------');
        // Step 4: Check if User B has a referrer (User A)
        if (referrerData.containsKey('referrerUid')) {
          print('---------------------5--------------${referrerData['referrerUid']}-----------------');
          String firstReferrerUid = referrerData['referrerUid'];

          // Fetch User A (the first referrer)
          var firstReferrerDoc = await FirebaseFirestore.instance.collection('users').doc(firstReferrerUid).get();

          if (firstReferrerDoc.exists) {
            // User A found, update their wallet
            int firstReferrerWallet = firstReferrerDoc.data()!.containsKey('wallet')
                ? firstReferrerDoc['wallet']
                : 0;

            // Step 5: Add ₹10 to User A's wallet
            await FirebaseFirestore.instance.collection('users').doc(firstReferrerUid).update({
              'wallet': firstReferrerWallet + 10,
            });

            print('Added ₹10 to User A\'s wallet');
          } else {
            print('First referrer (User A) not found.');
          }
        }

        // Step 6: Mark referral as used for the current user (User C)
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'referralUsed': true,
        });

        Get.snackbar(
          'Success',
          'Referral successfully added. ₹50 added to referrer’s wallet and ₹10 to their referrer.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Invalid referral code. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error adding referral: $e');
      Get.snackbar(
        'Error',
        'An error occurred. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Referral Code',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Referral Code',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _referralCodeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Referral Code',
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (referralUsed) {
                  print(referralUsed);
                  Get.snackbar(
                    'Error',
                    'You have already used a referral code.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  String referralId = _referralCodeController.text.trim();
                  if (referralId.isNotEmpty) {
                    print(referralId);
                    addReferral(referralId);
                  } else {
                    Get.snackbar(
                      'Error',
                      'Please enter a referral code.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
