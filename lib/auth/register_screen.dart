import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mwave/auth/login_screen.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/onboardvideo/video_scree.dart';
import 'package:mwave/view/bottum_nav_bar.dart';

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

          Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  VideoSelectionScreen()),
                  );

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
      appBar: AppBar(automaticallyImplyLeading: false,
        title:  Text('Register',style: TextStyle(color: kwhite),),
        backgroundColor: const Color(0xFF6A00D7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator()) // Show loading indicator
              : ListView(
                  children: [
                    // Username field
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Username'),
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
                      decoration: const InputDecoration(labelText: 'Email'),
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
                      decoration: const InputDecoration(labelText: 'Phone Number'),
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
                      decoration: const InputDecoration(labelText: 'Address'),
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
                      decoration: const InputDecoration(labelText: 'Place'),
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
                      child: const Text('Register', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
