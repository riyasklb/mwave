import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/view/wallet/withdraw_screen.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  

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

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kblue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Wallet',
          style: GoogleFonts.poppins(
              fontSize: 24.sp, fontWeight: FontWeight.w600, color: kwhite),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.notifications, color: kwhite),
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: kwhite))
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: buildWalletContent(),
            ),
    );
  }

  Widget buildWalletContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Wallet Balance Container
        Container(
          height: 200,
          width: 200,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
            ],
          ),
        ),
        SizedBox(height: 30.h),

        // Send & Receive Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton('Withdraw', Icons.money, Colors.teal),
            _buildActionButton('Receive', Icons.arrow_downward, Colors.teal),
          ],
        ),
        SizedBox(height: 32.h),

        // Transaction History
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Transaction History',
            style: GoogleFonts.poppins(
              color: kwhite,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // List of Transactions
Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection('withdrawal_history')
        .orderBy('requestedAt', descending: true)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator(color: kwhite));
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(
          child: Text(
            'No withdrawal history found',
            style: GoogleFonts.poppins(color: kwhite, fontSize: 16.sp),
          ),
        );
      }
      final withdrawals = snapshot.data!.docs;
      return ListView.builder(
        itemCount: withdrawals.length,
        itemBuilder: (context, index) {
          var withdrawal = withdrawals[index];
          return _buildTransactionItem(
            'Withdraw', // Label for this transaction
            '₹${withdrawal['amount']}', // Amount
            withdrawal['status'], // Status (e.g., Pending, Completed)
            withdrawal['status'] == 'Completed' ? Colors.green : Colors.red,
           withdrawal['requestedAt'].toDate(), // Converts Timestamp to DateTime
           withdrawal['email'], // Email address
           withdrawal['mobileNumber'], // Mobile number
          );
        },
      );
    },
  ),
),


      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {
        if (title == 'Withdraw') {
          Get.to(() => WithdrawScreen());
        } else {
          // Handle other actions if needed
        }
      },
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

Widget _buildTransactionItem(
  String label,
  String amount,
  String status,
  Color statusColor,
  DateTime requestedAt,
  String email,
  String mobileNumber,
) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
    color: kwhite,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    child: Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.grey,),
          ),
          SizedBox(height: 8.h),
          Text(
            amount,
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status: $status',
                style: GoogleFonts.poppins(color: statusColor, fontSize: 14.sp),
              ),
              Text(
                'Date: ${DateFormat('dd MMM yyyy, hh:mm a').format(requestedAt)}',
                style: GoogleFonts.poppins(color:Colors.grey, fontSize: 12.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Email: $email',
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12.sp),
          ),
          Text(
            'Mobile: $mobileNumber',
            style: GoogleFonts.poppins(color:Colors.grey, fontSize: 12.sp),
          ),
        ],
      ),
    ),
  );
}

}
