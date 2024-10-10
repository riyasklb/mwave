import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/controllers/wallet_conrtoler.dart';
// Assume you have a WalletController for handling wallet logic
import 'package:get/get.dart';

class WalletScreen extends StatelessWidget {
  final WalletController walletController = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.w600, color: kwhite),
        ),
        backgroundColor: kblue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Section
            Text(
              'Balance',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Obx(() => Text(
                  '\$${walletController.balance.value.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                      fontSize: 36, fontWeight: FontWeight.bold, color: kblue),
                )),
            SizedBox(height: 40),

            // Transaction History Section
            Text(
              'Transaction History',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (walletController.transactions.isEmpty) {
                  return Center(
                    child: Text(
                      'No transactions yet.',
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: walletController.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = walletController.transactions[index];
                    return ListTile(
                      title: Text(
                        transaction.description,
                        style: GoogleFonts.poppins(),
                      ),
                      subtitle: Text(
                        transaction.date.toString(),
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                      trailing: Text(
                        '\$${transaction.amount.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                            color: transaction.amount >= 0
                                ? Colors.green
                                : Colors.red),
                      ),
                    );
                  },
                );
              }),
            ),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Add Funds screen
                    Get.to(AddFundsScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kblue,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('Add Funds'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Withdraw Funds screen
                    Get.to(WithdrawFundsScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kblue,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('Withdraw'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Assuming you have AddFundsScreen and WithdrawFundsScreen implemented
class AddFundsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Add your implementation for adding funds
    return Scaffold(
      appBar: AppBar(title: Text('Add Funds')),
      body: Center(child: Text('Add Funds Functionality')),
    );
  }
}

class WithdrawFundsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Add your implementation for withdrawing funds
    return Scaffold(
      appBar: AppBar(title: Text('Withdraw')),
      body: Center(child: Text('Withdraw Funds Functionality')),
    );
  }
}
