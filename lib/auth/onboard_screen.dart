import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mwave/auth/login_screen.dart';
import 'package:mwave/constants/colors.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildOnboardPage(
            image: 'assets/images/WhatsApp Image 2024-10-03 at 2.50.54 PM(1).jpeg',
            title: 'Welcome to Money Wave',
            description: 'Your personal finance manager',
            isLastPage: false,
          ),
          _buildOnboardPage(
            image: 'assets/images/rb_7121.png',
            title: 'Track Your Expenses',
            description: 'Get real-time insights on your spending',
            isLastPage: false,
          ),
          _buildOnboardPage(
            image: 'assets/images/rb_7121.png',
            title: 'Ready to Begin?',
            description: 'Swipe left or tap to log in!',
            isLastPage: true,
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardPage({
    required String image,
    required String title,
    required String description,
    required bool isLastPage,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kblue,Colors.blueAccent ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w), // Responsive padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
              CircleAvatar(
                radius: 140.r, // Responsive size
                backgroundImage: AssetImage(image),
              ),
              SizedBox(height: 40.h),

              // Title
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),

              // Description
              Text(
                description,
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 18.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),

              // Navigation Logic
              if (isLastPage)
                // Login Button on the Last Page
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Log in',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF6A00D7),
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                )
              else
                // Arrow Icon for Next Page
                GestureDetector(
                  onTap: () {
                    // Move to the next page when arrow is tapped
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    size: 40.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
