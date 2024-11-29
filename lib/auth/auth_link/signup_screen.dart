import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/auth/auth_link/auth_service.dart';
import 'package:mwave/auth/auth_link/verifyhome.dart';
import 'package:mwave/constants/colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();

  final _email = TextEditingController();
  bool _isLoading = false; // Loader state

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:Colors.transparent,
      body: Container(
         width: double.infinity,
        height: double.infinity,
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [kblue, Color.fromARGB(255, 247, 244, 247)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            children: [
              const Spacer(),
              Text(
                "Signup",
                style: GoogleFonts.poppins(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w600,color: kwhite
                ),
              ),
              SizedBox(height: 50.h),
              TextField(
                controller: _email,
                decoration: InputDecoration(
                 // labelText: "Email",
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                  hintText: "Enter your email",
                  hintStyle: GoogleFonts.poppins(fontSize: 14.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: const Color.fromARGB(255, 255, 255, 255), width: 2.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 15.w,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              _isLoading
                  ? CircularProgressIndicator.adaptive() // Loader
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          "Signup",
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 10.h),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void goToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Verifyhome()),
    );
  }

  Future<void> _signup() async {
    setState(() {
      _isLoading = true; // Show loader
    });
    try {
      final user = await _auth.createUserWithEmailAndPassword(
        _email.text,
        '0000000',
      );

      if (user != null) {
        log("User Created Successfully");
        goToHome(context);
      }
    } catch (e) {
      log("Signup Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loader
      });
    }
  }
}
