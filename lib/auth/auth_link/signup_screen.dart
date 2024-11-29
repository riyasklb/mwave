import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:mwave/auth/auth_link/auth_service.dart';

import 'package:mwave/auth/auth_link/verifyhome.dart';
import 'package:mwave/auth/auth_link/widgets/button.dart';
import 'package:mwave/auth/auth_link/widgets/textfield.dart';




class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const Spacer(),
            const Text("Signup",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 50,
            ),
       
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Email",
              label: "Email",
              controller: _email,
            ),
            const SizedBox(height: 20),
           
            const SizedBox(height: 30),
            CustomButton(
              label: "Signup",
              onPressed: _signup,
            ),
            const SizedBox(height: 5),
          
            const Spacer()
          ],
        ),
      ),
    );
  }



  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Verifyhome()),
      );

  _signup() async {
    final user =
        await _auth.createUserWithEmailAndPassword(_email.text, '00000000');
    if (user != null) {
      log("User Created Succesfully");
      goToHome(context);
    }
  }
}
