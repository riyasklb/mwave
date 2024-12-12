import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mwave/constants/colors.dart';
import 'package:mwave/view/couces_screen.dart';
import 'package:mwave/view/profile_screen.dart';

import '../controllers/auth_controller.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final String customBackgroundImage = 'assets/images/WhatsApp Image 2024-10-17 at 2.25.11 PM.jpeg'; // Ensure this exists

  final List<Map<String, dynamic>> dashboardItems = [
    {
      'title': 'Courses',
      'icon': Icons.school,
      'color': Colors.blue,
      'route': () => CoursesScreen(),
    },
    {
      'title': 'Profile',
      'icon': Icons.person,
      'color': Colors.purple,
      'route': () => ProfileScreen(), // Replace with actual Profile screen
    },
    {
      'title': 'Settings',
      'icon': Icons.settings,
      'color': Colors.orange,
      'route': () {}, // Replace with actual Settings screen
    },
    {
      'title': 'Notifications',
      'icon': Icons.notifications,
      'color': Colors.red,
      'route': () {}, // Replace with actual Notifications screen
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the scaffold key
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Define action
        },
        backgroundColor: kblue,
        child: Icon(Icons.add, color: Colors.white),
      ),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(customBackgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay for the content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
              child: GetBuilder<AuthController>(
                builder: (_) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Custom AppBar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dashboard',
                            style: GoogleFonts.lato(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.menu, color: Colors.white, size: 28.sp),
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      // Dashboard Grid
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.w,
                            mainAxisSpacing: 16.h,
                            childAspectRatio: 1,
                          ),
                          itemCount: dashboardItems.length,
                          itemBuilder: (context, index) {
                            final item = dashboardItems[index];
                            return _buildDashboardCard(
                              title: item['title'],
                              icon: item['icon'],
                              color: item['color'],
                              onTap: () {
                                final route = item['route'] as Widget Function();
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => route()),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Navigation Drawer
  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: kblue,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40.sp, color: kblue),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Welcome!',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard, color: Colors.white),
              title: Text(
                'Dashboard',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.sp),
              ),
              onTap: () {
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.payment, color: Colors.white),
              title: Text(
                'Payments',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.sp),
              ),
              onTap: () {
                // Navigate to Payments screen
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text(
                'Logout',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.sp),
              ),
              onTap: () {
                // Handle logout
              },
            ),
          ],
        ),
      ),
    );
  }

  // Refactored Dashboard Card Widget
  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -10,
              child: Icon(
                icon,
                size: 100.sp,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 48.sp, color: Colors.white),
                  SizedBox(height: 12.h),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
