import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mwave/model/referal_model.dart';

class ReferralController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String? uid;
  bool referralUsed = false;
  List<Map<String, dynamic>> referrals = [];

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      uid = currentUser.uid;
      var userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        referralUsed = userDoc.data()?['referralUsed'] ?? false;
        await getReferrals();
        update();
      }
    }
  }

  Future<List<Referral>> getReferrals() async {
    List<Referral> referrals = [];
    if (uid != null) {
      var referralDocs = await _firestore
          .collection('users')
          .doc(uid)
          .collection('referrals')
          .get();

      for (var doc in referralDocs.docs) {
        referrals.add(Referral(
          username: doc['username'],
          email: doc['email'],
        ));
      }
    }
    return referrals;
  }

Future<void> addReferral(String referralId) async {
   var userDoc = await _firestore.collection('users').doc(uid).get();
  if (referralUsed) {
    Get.snackbar(
      'Error',
      'You have already used a referral code.',
      snackPosition: SnackPosition.TOP,
    );
    return;
  }

  try {
    isLoading = true;
    update(); // Update the UI to show loading state

    // Check if the referral ID exists
    var referrerDoc = await _firestore
        .collection('users')
        .where('referralId', isEqualTo: referralId)
        .get();

    if (referrerDoc.docs.isNotEmpty) {
      String referrerUid = referrerDoc.docs.first.id;

      // Update referrer's wallet
      int currentWallet = referrerDoc.docs.first.data()['wallet'] ?? 0;
      await _firestore.collection('users').doc(referrerUid).update({
        'wallet': currentWallet + 50,
      });

      // Add current user to referrer's referrals
      await _firestore
          .collection('users')
          .doc(referrerUid)
          .collection('referrals')
          .doc(uid)
          .set({
         'username': userDoc.data()?['username'] ?? 'Anonymous',
          'email': userDoc.data()?['email'] ?? 'N/A',
        'referredOn': DateTime.now(),
      });

      // Handle first referrer scenario (if applicable)
      if (referrerDoc.docs.first.data().containsKey('referrerUid')) {
        String firstReferrerUid = referrerDoc.docs.first['referrerUid'];
        var firstReferrerDoc =
            await _firestore.collection('users').doc(firstReferrerUid).get();

        if (firstReferrerDoc.exists) {
          int firstReferrerWallet =
              firstReferrerDoc.data()?['wallet'] ?? 0;

          await _firestore.collection('users').doc(firstReferrerUid).update({
            'wallet': firstReferrerWallet + 10,
          });
        }
      }

      // Mark referral as used immediately
      referralUsed = true;
      await _firestore.collection('users').doc(uid).update({
        'referralUsed': true,
        'referrerUid': referrerUid,
      });

      await getReferrals();
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
    print(e);
    Get.snackbar(
      'Error',
      'An error occurred. Please try again later.',
      snackPosition: SnackPosition.BOTTOM,
    );
  } finally {
    isLoading = false;
    update(); // Stop loading state
  }
}

}
