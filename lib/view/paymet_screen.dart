import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/controllers/auth_controller.dart';

import 'package:mwave/view/referal_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay razorpay;
 final AuthController authController = Get.put(AuthController());
  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  @override
  void dispose() {
    razorpay.clear(); // Dispose of Razorpay to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kblue,
        title: Text(
          'Payment',
          style: GoogleFonts.lato(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Amount to Pay:',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              '₹100', // The amount to pay
              style: GoogleFonts.poppins(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: openPaymentGateway,
              style: ElevatedButton.styleFrom(
                backgroundColor:kblue,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Pay Now',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
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

  // Open Razorpay Payment Gateway
  void openPaymentGateway() {
    var options = {
      'key': 'rzp_test_sWnFHSJbOds7ZX',
      'amount': 10000, // Amount in paise (₹100 = 10000 paise)
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '9633749714', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    razorpay.open(options);
  }

void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
  try {
    // Get the current user's UID
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String? emailId = currentUser.email;

      // Store payment details in the user's Firestore payments subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(emailId) // Use email as document ID
          .collection('payments')
          .add({
        'orderId': response.orderId,
        'paymentId': response.paymentId,
        'signature': response.signature,
        'amount': 100, // Amount in INR
        'timestamp': Timestamp.now(), // Current timestamp
      });

      // Update payment status in the user's main document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(emailId)
          .update({'paymentStatus': true});

      // Show success message using your AuthController
      authController.showToast(
        context,
        text: 'Payment Successful\nPayment ID: ${response.paymentId}',
        icon: Icons.check,
      );

      // Navigate to the ReferralScreen after payment success
      Get.offAll(ReferralScreen());
    } else {
      // If the user is not logged in, show an error message
      authController.showToast(
        context,
        text: 'Error\nNo user is currently logged in.',
        icon: Icons.error,
      );
    }
  } catch (e) {
    print('Error storing payment details: $e');
    showAlertDialog(context, "Error", "Failed to store payment details.");
  }
}


  // Handle Payment Error
  void handlePaymentErrorResponse(PaymentFailureResponse response) {

    authController.showToast(context,
          text: 'Payment Failed',
          icon: Icons.error,
        );
    showAlertDialog(
      context,
      "Payment Failed",
      "Code: ${response.code}\nDescription: ${response.message}\nMetadata: ${response.error.toString()}",
    );
  }

  // Handle External Wallet Selection
  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }

  // Show Alert Dialog
  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              child: const Text("Continue"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
