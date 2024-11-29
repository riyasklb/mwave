import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:mwave/auth/auth_link/signup_screen.dart';
import 'package:mwave/auth/input_adreass_screen.dart';
import 'package:mwave/constants/colors.dart';
import 'package:mwave/controllers/auth_controller.dart';
import 'package:mwave/view/bottumbar1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final AuthController authController = Get.put(AuthController());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isLoading =false;

  @override
  Widget build(BuildContext context) {
  

    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return GetBuilder<AuthController>(builder: (_) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(custombagroundimage),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Stack(
          children: [
            _buildAppBar(),
            _buildForm(context),
          ],
        ),
      );
    });
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 40.h,
      left: 0,
      right: 0,
      child: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Log in',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
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
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLottieAnimation(),kheight10,kheight10,kheight40,
              InkWell(onTap: (){Get.to(SignupScreen());},
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign in with Link   ',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: kblue,
                      ),
                    ),
                Icon(Icons.arrow_forward,color: kblue,)  ],
                ),
              ),
             // SizedBox(height: 60.h),
              SizedBox(height: 16.h),kheight40,
              _buildGoogleLoginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLottieAnimation() {
    return SizedBox(
    //  height: 200.h,
      child: Lottie.asset(lottielogingif),
    );
  }

  Widget buildLoginOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        const SizedBox(width: 10), 
        GestureDetector(
          onTap: () {
          
            print("Google Login tapped");
          },
          child: Text(
            'Google Login',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleLoginButton(BuildContext context) {
    return  isLoading==true? CircularProgressIndicator(): SignInButton(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        Buttons.google, onPressed: () async {
      try {
        setState(() {
           isLoading=true;
        });
       
        
        final googleUser = await _googleSignIn.signIn();
    
        if (googleUser == null) {
          print('Google Sign-In aborted');
          return; // User canceled the sign-in
        }
    
        // Get the Google authentication details
        final googleAuth = await googleUser.authentication;
    
        // Create Firebase credential with Google token
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
    
      
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
    
       
        User? firebaseUser = userCredential.user;
    
        if (firebaseUser != null) {
          print(
              'Firebase User: ${firebaseUser.displayName}, UID: ${firebaseUser.uid}');
    
         
          QuerySnapshot userQuery = await _firestore
              .collection('users')
              .where('email', isEqualTo: firebaseUser.email)
              .get();
          print('=========================${firebaseUser.email}');
          print('=========================${userQuery.docs}');
          if (userQuery.docs.isNotEmpty) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isRegistered', true);
          
            Get.offAll(() => BottumNavBar());
          
          } else {
            
            Get.to(() => AddressAndPhoneCollectionScreen(
                  email: firebaseUser.email!,
                  photo: firebaseUser.photoURL,
                  username: firebaseUser.displayName,
                ));
          }
        }setState(() {
             isLoading=false;
        });
      
     
      } catch (e) {
        setState(() {
             isLoading=false;
        });
        print('Error during Google Sign-In: $e');
      }
    });
  }
}
