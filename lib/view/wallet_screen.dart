import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

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
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            walletAmount = userDoc.data()?['wallet'] ?? 0; // Default to 0 if no wallet field
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
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Wallet Balance',
                    style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '₹$walletAmount',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loadWalletAmount,
                    child: Text(
                      'Refresh',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
