import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mwave/constants/colors.dart';

class WithdrawScreen extends StatefulWidget {
  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
@override
  void initState() {
    _loadWalletAmount();
    // TODO: implement initState
    super.initState();
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;

   int walletAmount = 0;
  bool isLoading = true; 
Future<void> _loadWalletAmount() async {
  try {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.email)
          .get();

      if (userDoc.exists) {
        setState(() {
          walletAmount = userDoc.data()?['wallet'] ?? 0; // Default to 0
          isLoading = false;
        });
      } else {
        print('User document does not exist');
        setState(() {
          walletAmount = 0;
          isLoading = false;
        });
      }
    } else {
      print('No user logged in');
      setState(() {
        isLoading = false;
      });
    }
  } catch (e) {
    print('Error fetching wallet amount: $e');
    Get.snackbar(
      'Error',
      'Unable to fetch wallet amount. Please try again later.',
      snackPosition: SnackPosition.BOTTOM,
    );
    setState(() {
      isLoading = false;
    });
  }
}


  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();


void _submitRequest() async {
  final amount = int.tryParse(_amountController.text) ?? 0;
  final mobileNumber = _mobileController.text.trim();

  if (amount < 200) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Invalid Amount',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        content: Text(
          'You can only withdraw an amount above ₹200.',
          style: GoogleFonts.poppins(fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: kblue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
    return;
  }

  if (mobileNumber.isEmpty) {
    Get.snackbar(
      'Error',
      'Please enter a valid mobile number.',
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  if (amount > walletAmount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Insufficient Balance',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        content: Text(
          'You do not have enough balance to withdraw ₹$amount.',
          style: GoogleFonts.poppins(fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: kblue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
    return;
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  try {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      final withdrawalRequest = {
        'email': currentUser.email,
        'amount': amount,
        'mobileNumber': mobileNumber,
        'status': 'Pending', // Default status
        'requestedAt': FieldValue.serverTimestamp(),
      };

      // Add the withdrawal request to the general collection
      DocumentReference requestRef = await FirebaseFirestore.instance
          .collection('withdraw_requests')
          .add(withdrawalRequest);

      // Store the withdrawal request under the user's document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.email)
          .collection('withdrawal_history')
          .doc(requestRef.id)
          .set(withdrawalRequest);

      // Deduct the amount from the wallet
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.email)
          .update({
        'wallet': walletAmount - amount,
      });

      setState(() {
        walletAmount -= amount;
      });

      Get.snackbar(
        'Success',
        'Your withdrawal request has been submitted successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      _amountController.clear();
      _mobileController.clear();
    }
  } catch (e) {
    print('Error submitting withdrawal request: $e');
    Get.snackbar(
      'Error',
      'Unable to submit your withdrawal request. Please try again later.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    Navigator.pop(context); // Close the loader
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Withdraw',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: kwhite,
          ),
        ),
        centerTitle: true,
        backgroundColor: kblue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         Text(
  isLoading
      ? 'Loading wallet amount...'
      : 'Wallet Amount: ₹${walletAmount.toStringAsFixed(2)}',
  style: GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  ),
),

            SizedBox(height: 20.h),
            Text(
              'Enter Withdrawal Details',
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                labelStyle: GoogleFonts.poppins(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kblue, width: 2.w),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                prefixIcon: Icon(Icons.money, color: kblue),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Enter Mobile Number',
                labelStyle: GoogleFonts.poppins(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kblue, width: 2.w),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                prefixIcon: Icon(Icons.phone, color: kblue),
              ),
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: _submitRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: kblue,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Center(
                child: Text(
                  'Submit Request',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: kwhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
