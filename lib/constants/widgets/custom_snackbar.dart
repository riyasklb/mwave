// import 'package:flutter/material.dart';

// class CustomSnackBarsucsses extends StatelessWidget {
//   final String message;
//   final Color backgroundColor;
//   final String actionLabel;
//   final VoidCallback onActionPressed;

//   const CustomSnackBarsucsses(
//     String s, {
//     Key? key,
//     required this.message,
//     this.backgroundColor = Colors.green, // Default background color
//     this.actionLabel = 'OK', // Default action label
//     required this.onActionPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SnackBar(
//       content: Text(
//         message,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//       ),
//       backgroundColor: backgroundColor,
//       behavior: SnackBarBehavior.floating,
//       action: SnackBarAction(
//         label: actionLabel,
//         textColor: Colors.white,
//         onPressed: onActionPressed,
//       ),
//     );
//   }
// }

// class CustomSnackBarfaied extends StatelessWidget {
//   final String message;
//   final Color backgroundColor;
//   final String actionLabel;
//   final VoidCallback onActionPressed;

//   const CustomSnackBarfaied({
//     Key? key,
//     required this.message,
//     this.backgroundColor = Colors.redAccent, // Default background color
//     this.actionLabel = 'OK', // Default action label
//     required this.onActionPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SnackBar(
//       content: Text(
//         message,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//       ),
//       backgroundColor: backgroundColor,
//       behavior: SnackBarBehavior.floating,
//       action: SnackBarAction(
//         label: actionLabel,
//         textColor: Colors.white,
//         onPressed: onActionPressed,
//       ),
//     );
//   }
// }
