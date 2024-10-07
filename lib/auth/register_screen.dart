import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mwave/auth/login_screen.dart';
import 'package:mwave/constants/colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String _username = '';
  String _email = '';
  String _phone = '';
  String _address = '';
  String _place = '';

  bool _isLoading = false; // Add loading state

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        // Add user info to Firestore
        await _firestore.collection('users').add({
          'username': _username,
          'email': _email,
          'phone': _phone,
          'address': _address,
          'place': _place,
        });

        Get.offAll(LoginPage());

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User registered successfully!')),
        );
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Register',
          style: TextStyle(color: kwhite),
        ),
        backgroundColor:  kblue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator()) // Show loading indicator
              : ListView(
                  children: [
                    // Username field
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Username'),
                      onSaved: (value) {
                        _username = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        _email = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone number field
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                      onSaved: (value) {
                        _phone = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Address field
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Address'),
                      onSaved: (value) {
                        _address = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Place field
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Place'),
                      onSaved: (value) {
                        _place = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a place';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Register button
                    ElevatedButton(
                      onPressed: _registerUser,
                      child: const Text('Register',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
