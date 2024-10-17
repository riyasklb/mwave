import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _withdrawAmountController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  
  int walletAmount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWalletAmount();
  }

  Future<void> _loadWalletAmount() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            walletAmount = userDoc.data()?['wallet'] ?? 0;
            isLoading = false;
          });
        }
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

  Future<void> _submitWithdrawalRequest() async {
    int withdrawAmount = int.parse(_withdrawAmountController.text);

    if (withdrawAmount > walletAmount) {
      Get.snackbar(
        'Error',
        'Insufficient balance',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('withdrawRequests')
            .add({
          'uid': currentUser.uid,
          'amount': withdrawAmount,
          'mobile': _mobileController.text,
          'timestamp': Timestamp.now(),
        });

        Get.snackbar(
          'Success',
          'Your withdrawal request has been submitted.',
          snackPosition: SnackPosition.BOTTOM,
        );

        _withdrawAmountController.clear();
        _mobileController.clear();
      }
    } catch (e) {
      print('Error submitting withdrawal request: $e');
      Get.snackbar(
        'Error',
        'Unable to submit request. Try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text(
            'Wallet',
            style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.w600),
          ),
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your Wallet Balance',
                        style: GoogleFonts.poppins(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        '₹$walletAmount',
                        style: GoogleFonts.poppins(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton(
                        onPressed: _loadWalletAmount,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200.w, 50.h),
                        ),
                        child: Text(
                          'Refresh',
                          style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      if (walletAmount >= 200) ...[
                        Text(
                          'Enter Withdrawal Amount',
                          style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: _withdrawAmountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter amount',
                          ),
                        ),
                        SizedBox(height: 16.h),
                        TextField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter mobile number',
                          ),
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: _submitWithdrawalRequest,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(200.w, 50.h),
                          ),
                          child: Text(
                            'Withdraw',
                            style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'The amount will be credited within 24 hours.',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      );
    
  }
}
