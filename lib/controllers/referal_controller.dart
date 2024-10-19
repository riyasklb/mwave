import 'dart:ffi';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mwave/model/referal_model.dart';

class ReferralController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String? uid;
  var referralUsed = false.obs;
  var referrals = <Referral>[].obs;

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
        referralUsed.value = userDoc.data()?['referralUsed'] ?? false;
        await getReferrals();
      }
    }
  }

  Future<void> getReferrals() async {
    
    print('-----------------------1----------------');
    if (uid != null) {
          print('------------------2---------------------');
      var referralDocs = await _firestore
          .collection('users')
          .doc(uid)
          .collection('referrals')
          .get();
    print('---------------------3------------------');
      referrals.value = referralDocs.docs.map((doc) {
            print('-------------------4--------------------');
        return Referral(
          username: doc['username'],
          email: doc['email'],
          referredOn: (doc['referredOn'] as Timestamp).toDate(),
          subReferrals: (doc['subReferrals'] as List<dynamic>?)
              ?.map((sub) => Referral.fromJson(sub))
              .toList() ?? [],
        );
      }).toList();
          print('---------------------5------------------');
    }
  }

Future<void> addReferral(String referralId) async {
  isLoading=true;
  
  print(isLoading);
  print('----------------------6-----------------');
  var userDoc = await _firestore.collection('users').doc(uid).get();
  print('---------------------7------------------');
  
  if (referralUsed.value) {
    Get.snackbar('Error', 'You have already used a referral code.');
    return;
  }
  
  print('--------------------------8-------------');
  try {
    isLoading=true;
    print('-------------------------9--------------');
    
    // Fetch the referrer by referralId
    var referrerDoc = await _firestore
        .collection('users')
        .where('referralId', isEqualTo: referralId)
        .get();
    print('------------------------10---------------');
    
    if (referrerDoc.docs.isNotEmpty) {
      String referrerUid = referrerDoc.docs.first.id;
      print('--------------11-------------------------');
      int currentWallet = referrerDoc.docs.first.data()['wallet'] ?? 0;
      print('------------------------12---------------');
      
      // Update the referrer's wallet
      await _firestore.collection('users').doc(referrerUid).update({
        'wallet': currentWallet + 50,
      });
      print('-------------------------13--------------');
      
      // Add the new referral under the referrer
      await _firestore
          .collection('users')
          .doc(referrerUid)
          .collection('referrals')
          .doc(uid)
          .set({
        'username': userDoc.data()?['username'] ?? 'Anonymous',
        'email': userDoc.data()?['email'] ?? 'N/A',
        'referredOn': DateTime.now(),
        'subReferrals': [],
      });
      print('----------------14-----------------------');
      
      // Check if the referrer has another referrer (for sub-referrals)
      if (referrerDoc.docs.first.data().containsKey('referrerUid')) {
        print('---------------15-----------------------');
        String firstReferrerUid = referrerDoc.docs.first['referrerUid'];
        print('------------------16---------------------');
        
        var firstReferrerDoc = await _firestore
            .collection('users')
            .doc(firstReferrerUid)
            .get();
        print('---------------------------17------------');
        
        if (firstReferrerDoc.exists) {
          int firstReferrerWallet = firstReferrerDoc.data()?['wallet'] ?? 0;
          print('----------------18-----------------------');
          
          // Update the first referrer's wallet for sub-referrals
          await _firestore
              .collection('users')
              .doc(firstReferrerUid)
              .update({'wallet': firstReferrerWallet + 10});
          print('----------------19-----------------------');
          
          // Add the sub-referral to the first referrer
          await _firestore
              .collection('users')
              .doc(firstReferrerUid)
              .collection('referrals')
              .doc(referrerUid)
              .update({
            'subReferrals': FieldValue.arrayUnion([{
              'userId': uid,
              'username': userDoc.data()?['username'] ?? 'Anonymous',
              'email': userDoc.data()?['email'] ?? 'N/A',
              'referredOn': DateTime.now(),
            }]),
          });
          print('----------------20-----------------------');
        }
      }
      
      // Mark the current user as having used a referral code
      referralUsed.value = true;
      await _firestore.collection('users').doc(uid).update({
        'referralUsed': true,
        'referrerUid': referrerUid,
      });
      print('-------------------------21--------------');
      
      // Fetch updated referrals
      await getReferrals();
       isLoading= false;
      Get.snackbar('Success', 'Referral added successfully.');
      print('-------------------22--------------------');
      
    } else {
      isLoading=false;
      Get.snackbar('Error', 'Invalid referral code.');
    }
  } catch (e) {
    isLoading=false;
    Get.snackbar('Error', 'An error occurred. Please try again later.');
  } finally {
    isLoading = false;
  }
}

}
