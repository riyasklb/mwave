import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/constants/disclimer_texts_const.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  @override
  _TermsAndConditionsScreenState createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  final ScrollController _scrollController = ScrollController();
  String _currentTitle = 'Disclaimer';

  final GlobalKey _disclaimerKey = GlobalKey();
  final GlobalKey _usageKey = GlobalKey();
  final GlobalKey _privacyKey = GlobalKey();
  final GlobalKey _refundPolicyKey = GlobalKey();

  void _updateAppBarTitle() {
    final disclaimerBox =
        _disclaimerKey.currentContext?.findRenderObject() as RenderBox?;
    final usageBox =
        _usageKey.currentContext?.findRenderObject() as RenderBox?;
    final privacyBox =
        _privacyKey.currentContext?.findRenderObject() as RenderBox?;
    final refundPolicyBox =
        _refundPolicyKey.currentContext?.findRenderObject() as RenderBox?;

    if (disclaimerBox == null || usageBox == null || privacyBox == null || refundPolicyBox == null) {
      return;
    }

    final offset = _scrollController.offset;
    final disclaimerPosition = disclaimerBox.localToGlobal(Offset.zero).dy - 80.h;
    final usagePosition = usageBox.localToGlobal(Offset.zero).dy - 80.h;
    final privacyPosition = privacyBox.localToGlobal(Offset.zero).dy - 80.h;
    final refundPolicyPosition = refundPolicyBox.localToGlobal(Offset.zero).dy - 80.h;

    setState(() {
      if (offset >= refundPolicyPosition) {
        _currentTitle = "Refund Policy";
      } else if (offset >= privacyPosition) {
        _currentTitle = "Privacy Policy";
      } else if (offset >= usagePosition) {
        _currentTitle = "Terms and Conditions";
      } else if (offset >= disclaimerPosition) {
        _currentTitle = "Disclaimer";
      } else {
        _currentTitle = "Disclaimer";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateAppBarTitle);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        title: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: Text(
            _currentTitle,
            key: ValueKey<String>(_currentTitle),
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: Colors.grey[100],
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Disclaimer Section
                _buildSection("Disclaimer", _disclaimerKey, disclimersub),

                // Divider
                Divider(thickness: 1, color: Colors.grey[300], height: 30.h),

                // Terms and Conditions Section
                _buildSection(
                    "Terms and Conditions", _usageKey, Termsandconditionssub),

                // Divider
                Divider(thickness: 1, color: Colors.grey[300], height: 30.h),

                // Privacy Policy Section
                _buildSection("Privacy Policy", _privacyKey, PrivacyPolicysum),

                // Divider
                Divider(thickness: 1, color: Colors.grey[300], height: 30.h),

                // Refund Policy Section
                _buildSection("Refund Policy", _refundPolicyKey, RefundPolicySub),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to create sections with keys
  Widget _buildSection(String title, GlobalKey key, String content) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          content,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey[800],
            height: 1.6,
          ),
        ),
      ],
    );
  }
}