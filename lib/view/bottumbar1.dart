import 'dart:math';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/view/home_screen.dart';
import 'package:mwave/view/history_screeen.dart';
import 'package:mwave/view/menu_screen.dart';
import 'package:mwave/view/referal_screen.dart';
import 'package:mwave/view/wallet_screen.dart';

class BottumNavBar extends StatefulWidget {
  const BottumNavBar({Key? key}) : super(key: key);

  @override
  State<BottumNavBar> createState() => _BottumNavBarState();
}

class _BottumNavBarState extends State<BottumNavBar> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      HomeScreen(),
      const HistoryScreeen(),
       ReferralScreen(),
       WalletScreen(),
      const MenuScreen(),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: Color(0xFF9B87D5),
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 5,
              kBottomRadius: 28.0,

              notchShader: SweepGradient(
                startAngle: 0,
                endAngle: pi / 2,
                colors: [kblue, kblue, kblue],
                tileMode: TileMode.mirror,
              ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),
              notchColor: Colors.black87,

              /// restart app if you change removeMargins
              removeMargins: false,
              bottomBarWidth: 500,
              showShadow: false,
              durationInMilliSeconds: 300,

              itemLabelStyle: const TextStyle(fontSize: 10),

              elevation: 1,
              bottomBarItems: [
                BottomBarItem(
                  inActiveItem: Icon(Icons.home_filled, color: kwhite),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: kwhite,
                  ),
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.history, color: kwhite),
                  activeItem: Icon(Icons.history, color: kwhite),
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.group, color: kwhite),
                  activeItem: Icon(Icons.group, color: kwhite),
                ),
                BottomBarItem(
                  inActiveItem:
                      Icon(Icons.account_balance_wallet, color: kwhite),
                  activeItem: Icon(Icons.account_balance_wallet, color: kwhite),
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.menu, color: kwhite),
                  activeItem: Icon(Icons.menu, color: kwhite),
                ),
              ],
              onTap: (index) {
                //       log('current selected index $index');
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )
          : null,
    );
  }
}
