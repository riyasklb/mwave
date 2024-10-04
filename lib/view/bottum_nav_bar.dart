import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/view/dashboard_screen.dart';
import 'package:mwave/view/history_screeen.dart';
import 'package:mwave/view/more_scree.dart';
import 'package:mwave/view/referal_screen.dart';
import 'package:mwave/view/wallet_screen.dart';

class BottumNavBar extends StatefulWidget {
  final int initialIndex;

  BottumNavBar({this.initialIndex = 0});

  @override
  _BottumNavBarState createState() => _BottumNavBarState();
}

class _BottumNavBarState extends State<BottumNavBar> {
  late int _bottomNavIndex;

  @override
  void initState() {
    super.initState();
    _bottomNavIndex = widget.initialIndex;
  }

final iconList = <IconData>[
  Icons.home,          // Home icon
  Icons.history,       // History icon
  Icons.group,         // Referral icon (group icon as a placeholder for referral)
  Icons.account_balance_wallet,  // Wallet icon
  Icons.more_horiz,    // More icon
];


  final List<Widget> _screens = [
    DashboardPage(),
    HistoryScreeen(),
    ReferalScreen(),
    WalletScreen(),
    MoreScreen(),
  ];

  final List<String> _titles = [
    'Home',
    'History',
    'Referal',
    'Wallet',
    'More',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: const Color(0xFF6A00D7),
        automaticallyImplyLeading: false,
        title: Text(
          _titles[_bottomNavIndex],
          style: GoogleFonts.lato(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,color: Colors.white
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                 // Get.to(NotificationScreen());
                  // Handle notification icon press
                },
              ),
              Positioned(
                right: 8.0,
                top: 8.0,
                child: Container(
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: 20.0,
                    maxHeight: 20.0,
                  ),
                  child: Center(
                    child: Text(
                      '3', // Replace with the number of notifications
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _screens[_bottomNavIndex],
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        backgroundColor: Colors.white,
        activeColor: Color(0xFFA166F3),
        inactiveColor: Colors.grey,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
