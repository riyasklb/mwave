import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mwave/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwave/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(custombagroundimage),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Stack(
        children: [
          _buildAppBar(),
          _buildForm(context),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 40, // Adjust as needed
      left: 0,
      right: 0,
      child: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Log in',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80), // Space for the AppBar
            _buildPhoneNumberInput(),
            const SizedBox(height: 24),
            _buildLoginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberInput() {
    return Column(
      children: [
        Text(
          'Enter your phone number',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: kwhite,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: phoneController,
          decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
            hintText: 'Please enter your phone number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kblue, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 5),
                  Text('+91', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length < 10) {
              return 'Enter a valid phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: authController.isLoading.value
              ? null
              : () => authController.loginWithPhoneNumber(phoneController.text, context),
          style: ElevatedButton.styleFrom(
            backgroundColor: kblue,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            textStyle: const TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: authController.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Login with OTP'),
        ),
      ),
    );
  }
}
