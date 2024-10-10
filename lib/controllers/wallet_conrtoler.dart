import 'package:get/get.dart';

class Transaction {
  final String description;
  final double amount;
  final DateTime date;

  Transaction({required this.description, required this.amount, required this.date});
}

class WalletController extends GetxController {
  var balance = 0.0.obs;
  var transactions = <Transaction>[].obs;

  WalletController() {
    // Load initial balance and transactions
    loadWalletData();
  }

  void loadWalletData() {
    // Simulate loading data (replace with your logic)
    balance.value = 100.00; // Example balance
    transactions.addAll([
      Transaction(description: 'Added Funds', amount: 50.00, date: DateTime.now()),
      Transaction(description: 'Purchase', amount: -10.00, date: DateTime.now().subtract(Duration(days: 1))),
    ]);
  }

  // Add additional methods for adding and withdrawing funds
}
