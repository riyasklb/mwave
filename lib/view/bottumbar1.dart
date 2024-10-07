import 'dart:developer';
import 'dart:math';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/view/home_screen.dart';
import 'package:mwave/view/history_screeen.dart';
import 'package:mwave/view/more_scree.dart';
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
    /// widget list
    final List<Widget> bottomBarPages = [
      HomeScreen(
       
          ),
      const HistoryScreeen(),
      const ReferalScreen(),
      const WalletScreen(),
      const MoreScreen(),
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
              color: Colors.white,
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 5,
              kBottomRadius: 28.0,

              notchShader: SweepGradient(
                startAngle: 0,
                endAngle: pi / 2,
                colors: [kwhite, kwhite, kwhite],
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
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Color(0xFF6A00D7),
                  ),
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.history, color: Colors.blueGrey),
                  activeItem: Icon(
                    Icons.history,
                    color: Color(0xFF6A00D7),
                  ),
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.group,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.group,
                    color: Color(0xFF6A00D7),
                  ),
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.account_balance_wallet,
                    color: Color(0xFF6A00D7),
                  ),
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.more_horiz,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.more_horiz,
                    color: Color(0xFF6A00D7),
                  ),
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
