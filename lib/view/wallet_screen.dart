import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mwave/constants/colors.dart';

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
            .doc(currentUser.email)
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
        await FirebaseFirestore.instance.collection('withdrawRequests').add({
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
    return Scaffold(backgroundColor: kblue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Wallet',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,color: kwhite
          ),
        ),
        centerTitle: true,
        leading: Icon(Icons.menu, color: kwhite),
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.notifications, color: kwhite),
        )],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Wallet Balance Container
            Container(height: 200,width: 200,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Balance',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '₹$walletAmount',
                    style: GoogleFonts.poppins(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '89,598.43 BGP', // Example secondary currency
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),

            // Send & Receive Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton('Send', Icons.arrow_upward, Colors.purple),
                _buildActionButton('Receive', Icons.arrow_downward, Colors.teal),
              ],
            ),
            SizedBox(height: 32.h),

            // Transaction History
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Transaction History',
                style: GoogleFonts.poppins(color: kwhite,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // List of Transactions (Placeholder)
            _buildTransactionItem(
              'Sent', '-112.40 GBP', 'unconfirmed', Colors.red,
            ),
            _buildTransactionItem(
              'Received', '+12.19 GBP', 'confirmed', Colors.green,
            ),
            _buildTransactionItem(
              'Sent', '-112.40 GBP', 'Cancelled', Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  // Action Button Widget (Send/Receive)
  Widget _buildActionButton(String title, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w500),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  // Transaction Item Widget
  Widget _buildTransactionItem(
      String type, String amount, String status, Color amountColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(type, style: GoogleFonts.poppins(fontSize: 16.sp)),
              SizedBox(height: 4.h),
              Text('13 Jan 2019 • $status',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  )),
            ],
          ),
          Text(
            amount,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
