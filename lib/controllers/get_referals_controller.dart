import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetReferralController extends GetxController {
  // Observables for referrals and loading state
  var referrals = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReferrals(); // Fetch referrals when the controller initializes
  }

  // Method to fetch referrals and update UI state
  Future<void> fetchReferrals() async {
    try {
     isLoading.value = true;  // Set loading state to true

      final referralsList = await _fetchReferralsWithSubReferrals();
      referrals.value = referralsList; // Update the referrals list
print(referralsList);
      print('Referrals fetched successfully.');
    } catch (e) {
      print("Error fetching referrals: $e");
      Get.snackbar('Error', 'Failed to fetch referrals.');
    } finally {
      isLoading.value =   false; // Stop loading state
    }
  }

  // Helper function to fetch referrals with sub-referrals from Firestore
  Future<List<Map<String, dynamic>>> _fetchReferralsWithSubReferrals() async {
    try {
      final referralsCollection = FirebaseFirestore.instance.collection('referrals');
      final referralsSnapshot = await referralsCollection.get();

      // Use Future.wait to fetch all sub-referrals in parallel
      List<Map<String, dynamic>> referralsList = await Future.wait(
        referralsSnapshot.docs.map((referralDoc) async {
          Map<String, dynamic> referralData = referralDoc.data();

          // Fetch sub-referrals collection for each referral
          final subReferralsSnapshot = await referralDoc.reference
              .collection('sub_referrals')
              .get();

          // Add the sub-referrals data to the referral map
          referralData['sub_referrals'] = subReferralsSnapshot.docs.map((doc) => doc.data()).toList();

          return referralData;
        }).toList(),
      );

      return referralsList;
    } catch (e) {
      print("Error fetching referrals with sub-referrals: $e");
      throw e; // Rethrow the error for higher-level handling
    }
  }
}
