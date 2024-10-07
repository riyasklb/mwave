// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mwave/constants/colors.dart';
// import 'package:mwave/view/dashboard_screen.dart';
// import 'package:mwave/view/history_screeen.dart';
// import 'package:mwave/view/more_scree.dart';
// import 'package:mwave/view/referal_screen.dart';
// import 'package:mwave/view/wallet_screen.dart';
// import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

// class BottumNavBar extends StatefulWidget {
//   final int initialIndex;

//   BottumNavBar({this.initialIndex = 0});

//   @override
//   _BottumNavBarState createState() => _BottumNavBarState();
// }

// class _BottumNavBarState extends State<BottumNavBar> {
//   late int _bottomNavIndex;

//   @override
//   void initState() {
//     super.initState();
//     _bottomNavIndex = widget.initialIndex;
//   }

//   final iconList = <Widget>[
//     Icon(Icons.home),
//     Icon(Icons.history),
//     Icon(Icons.group),
//     Icon(Icons.account_balance_wallet),
//     Icon(Icons.more_horiz),
//   ];

//   final List<Widget> _screens = [
//     DashboardPage(),
//     HistoryScreeen(),
//     ReferalScreen(),
//     WalletScreen(),
//     MoreScreen(),
//   ];

//   final List<String> _titles = [
//     'Home',
//     'History',
//     'Referal',
//     'Wallet',
//     'More',
//   ];
//   final NotchBottomBarController _controller = NotchBottomBarController(index: 0);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF6A00D7),
//         automaticallyImplyLeading: false,
//         title: Text(
//           _titles[_bottomNavIndex],
//           style: GoogleFonts.lato(
//               fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         actions: [
//           Stack(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.notifications, color: Colors.white),
//                 onPressed: () {
//                   // Handle notification icon press
//                 },
//               ),
//               Positioned(
//                 right: 8.0,
//                 top: 8.0,
//                 child: Container(
//                   padding: EdgeInsets.all(2.0),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(16.0),
//                   ),
//                   constraints: BoxConstraints(
//                     maxWidth: 20.0,
//                     maxHeight: 20.0,
//                   ),
//                   child: Center(
//                     child: Text(
//                       '3', // Replace with the number of notifications
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: _screens[_bottomNavIndex],
//       bottomNavigationBar: AnimatedNotchBottomBar(
//        // pageController: PageController(initialPage: _bottomNavIndex),
//         bottomBarItems: [
//           BottomBarItem(
//             inActiveItem: Icon(Icons.home, color: Colors.grey),
//             activeItem: Icon(Icons.home, color: kwhite),
//           ),
//           BottomBarItem(
//             inActiveItem: Icon(Icons.history, color: Colors.grey),
//             activeItem: Icon(Icons.history, color: Color(0xFFA166F3)),
//           ),
//           BottomBarItem(
//             inActiveItem: Icon(Icons.group, color: Colors.grey),
//             activeItem: Icon(Icons.group, color: Color(0xFFA166F3)),
//           ),
//           BottomBarItem(
//             inActiveItem: Icon(Icons.account_balance_wallet, color: Colors.grey),
//             activeItem: Icon(Icons.account_balance_wallet, color: Color(0xFFA166F3)),
//           ),
//           BottomBarItem(
//             inActiveItem: Icon(Icons.more_horiz, color: Colors.grey),
//             activeItem: Icon(Icons.more_horiz, color: kwhite),
//           ),
//         ],
//         color: Colors.white,
//         notchColor: Color(0xFFA166F3),
//         showLabel: false,
//         onTap: (index) {
//           setState(() {
//             _bottomNavIndex = index;
//           });
//         }, notchBottomBarController: _controller, kIconSize: 30, kBottomRadius: 28.0,
//       ),
//     );
//   }
// }
