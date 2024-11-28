import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/view/bottumbar1.dart';

class DisclaimerPage extends StatefulWidget {
  const DisclaimerPage({Key? key}) : super(key: key);

  @override
  State<DisclaimerPage> createState() => _DisclaimerPageState();
}

class _DisclaimerPageState extends State<DisclaimerPage> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kwhite,
        elevation: 0,
        title: Text(
          'Disclaimer',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.sp, vertical: 16.0.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Disclaimer',
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'The information provided by this application is for general informational purposes only. All information on the application is provided in good faith; however, we make no representation or warranty of any kind, express or implied, regarding the accuracy, adequacy, validity, reliability, availability, or completeness of any information on the application.',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'External Links Disclaimer',
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'The application may contain (or you may be sent through the application) links to other websites or content belonging to or originating from third parties or links to websites and features. Such external links are not investigated, monitored, or checked for accuracy, adequacy, validity, reliability, availability, or completeness by us.',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Limitation of Liability',
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Under no circumstance shall we have any liability to you for any loss or damage of any kind incurred as a result of the use of the application or reliance on any information provided on the application. Your use of the application and your reliance on any information on the application is solely at your own risk.',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                    activeColor: const Color(0xFF6A11CB),
                  ),
                  Expanded(
                    child: Text(
                      'I have read and agree to the terms and conditions.',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Center(
                child: ElevatedButton(
                  onPressed: isChecked
                      ? () {
                        Get.offAll(BottumNavBar()); // Replace with desired action
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isChecked
                        ? const Color(0xFF6A11CB)
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                  ),
                  child: Text(
                    'Agree',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
