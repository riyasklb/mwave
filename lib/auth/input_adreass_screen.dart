import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mwave/auth/onboard_screen.dart';
import 'package:mwave/view/bottumbar1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressAndPhoneCollectionScreen extends StatelessWidget {
  final String? photo;
  final String email;
  final String? username;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AddressAndPhoneCollectionScreen({
    this.photo,
    required this.email,
    required this.username,
  });

 
  Future<void> _submitData(BuildContext context) async {
    final address = _addressController.text.trim();
    final phone = _phoneController.text.trim();
    final place = _placeController.text.trim();

    if (address.isEmpty || phone.isEmpty || place.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not authenticated. Please log in.')),
        );
        Get.to(OnboardScreen());
        return;
      }

      String uid = user.uid;
      await _firestore.collection('users').doc(email).set({
        'uid': uid,
        'email':email,
        'username': username ?? 'Anonymous',
        'photo': photo ?? '',
        'address': address,
        'phone': phone,
        'place': place,
        'referralUsed': false,
        'referralId': _generateReferralCode(email),
      });

      // Store registration status in SharedPreferences
      await _storeRegistrationStatus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Details submitted successfully!')),
      );

      _addressController.clear();
      _phoneController.clear();
      _placeController.clear();
      Get.to(BottumNavBar());

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit details: $e')),
      );
    }
  }

  Future<void> _storeRegistrationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRegistered', true); // Store registration status
    await prefs.setString('email', email); // Store email or other user info
    print('Registration status saved in SharedPreferences.');
  }

  Future<void> _logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear shared preferences on logout

      await _googleSignIn.signOut();
      await _auth.signOut();
 await prefs.setBool('isRegistered', false); 
      Get.to(OnboardScreen());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to logout: $e')),
      );
    }
  }

  String _generateReferralCode(String email) {
    return email.hashCode.toString().substring(0, 6);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Your Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (photo != null && photo!.isNotEmpty)
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(photo!),
                )
              else
                CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
              SizedBox(height: 16),
              Text(
                username ?? 'Anonymous',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                email,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _placeController,
                decoration: InputDecoration(labelText: 'Place'),
              ),
              SizedBox(height: 16),
              Text(
                'Your Referral Code: ${_generateReferralCode(email)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _submitData(context),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
