import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mwave/constants/colors.dart';
import 'package:flutter/services.dart'; // Import for input formatters

class WithdrawScreen extends StatefulWidget {
  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  @override
  void initState() {
    _loadWalletAmount();
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  int walletAmount = 0;
  bool isLoading = true;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key

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
          setState(() {
            walletAmount = 0;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
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

  void _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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
        return const Center(
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
          'status': 'Pending',
          'requestedAt': FieldValue.serverTimestamp(),
        };

        DocumentReference requestRef = await FirebaseFirestore.instance
            .collection('withdraw_requests')
            .add(withdrawalRequest);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .collection('withdrawal_history')
            .doc(requestRef.id)
            .set(withdrawalRequest);

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
      Get.snackbar(
        'Error',
        'Unable to submit your withdrawal request. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        child: Form(
          key: _formKey, // Assign form key
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
              TextFormField(
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
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 10, // Limit to 10 digits
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow digits only
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number.';
                  } else if (value.length != 10) {
                    return 'Mobile number must be exactly 10 digits.';
                  }
                  return null;
                },
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
      ),
    );
  }
}
