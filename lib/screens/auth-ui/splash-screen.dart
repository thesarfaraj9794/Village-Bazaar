

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:get/get.dart';
//import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';

import 'package:village_bazzar/controllers/get-user-data-controller.dart';
import 'package:village_bazzar/screens/admin-panel/admin-main-screen.dart';
import 'package:village_bazzar/screens/admin-panel/admin_dashboard.dart';
import 'package:village_bazzar/screens/auth-ui/welcome-screen.dart';
import 'package:village_bazzar/screens/user-panel/main-screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  User? user=FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // 3 सेकंड बाद MainScreen पर जाना
    Timer( Duration(seconds: 3), () {
      loggdin(context);
    });
  }
  Future<void> loggdin(BuildContext context)async{
    if(user!=null){
      final GetUserDataController getUserDataController =Get.put(GetUserDataController());

      var userData =await  getUserDataController.getUserData(user!.uid);
      if(userData[0]['isAdmin']==true){
        Get.offAll(()=>AdminDashboard());

      }else{
        Get.offAll(()=>MainScreen());

      }

    }else{
      Get.offAll(()=>WelcomeScreen());

    }
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 153, 172, 197),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 153, 172, 197),
        
      ),

      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Center(
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
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              width: Get.width,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    "Sarfi Bazaar",
                    style: TextStyle(
                      fontSize: 20.0,
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    
                  ),
                  SizedBox(height: 5,),
                  Text("Smart Shopping for Smart Women",style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.bold,),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
