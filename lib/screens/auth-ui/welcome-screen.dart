// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

//import 'package:e_comm/screens/auth-ui/sign-in-screen.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
//import 'package:lottie/lottie.dart';

import 'package:village_bazzar/controllers/google-sign-in-controller.dart';
import 'package:village_bazzar/screens/auth-ui/sign-in-screen.dart';
//import '../../controllers/google-sign-in-controller.dart';
//import '../../utils/app-constant.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final GoogleSignInController _googleSignInController =
     Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 153, 172, 197),
        
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 153, 172, 197),
          title: Text(
            "Welcome to my App",
            style: TextStyle(color:Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    child: Image.asset(
                    'assets/images/logo.png',
                    width: 380,
                    height: 380,
                    fit: BoxFit.contain,
                  ),
                  
                                 
                    
                    //child: Lottie.asset('assets/images/logo.png'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Happy Shopping",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              Material(
  borderRadius: BorderRadius.circular(20),
  color: const Color.fromARGB(255, 29, 39, 53),
  child: InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: () {
      _googleSignInController.signInWithGoogle();
    },
    child: Container(
      width: Get.width / 1.2,
      height: Get.height / 12,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon(MaterialCommunityIcons.google, color: Colors.white, ),
          //Icon(Icons.email, color: Colors.white),
          SizedBox(width: 10),
          Text("Sign in with google",
              style: TextStyle(color: Colors.white)),
        ],
      ),
    ),
  ),
),

                SizedBox(
                  height: 10.0,
                ),
             SizedBox(height: 10.0),
Material(
  color: const Color.fromARGB(255, 29, 39, 53),
  borderRadius: BorderRadius.circular(20.0),
  child: InkWell(
    borderRadius: BorderRadius.circular(20.0),
    onTap: () {
      // This will push SigninScreen on top of current screen
      Get.to(() => SigninScreen());
    },
    child: Container(
      width: Get.width / 1.2,
      height: Get.height / 12,
      alignment: Alignment.center,
      child:  Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Icon(Icons.email, color: Colors.white),
          SizedBox(width: 10),

          Text(
            "Sign in with Email",
            style: TextStyle(
              color: Colors.white,
              
              
            ),
          ),
        ],
      ),
    ),
  ),
),

              ],
            ),
          ),
        ),
      ),
    );
  }
}