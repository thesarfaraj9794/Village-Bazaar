import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:village_bazzar/screens/auth-ui/splash-screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCw8tM40-lGAF5uFZkGt4JHg05MN_IdQ6Q",
    authDomain: "vill-bazaar.firebaseapp.com",
    projectId: "vill-bazaar",
    storageBucket: "vill-bazaar.firebasestorage.app",
    //storageBucket: "vill-bazaar.appspot.com", 
    messagingSenderId: "81470577520",
    appId: "1:81470577520:web:a2e56b44913adb0c350db5",
    measurementId: "G-CMWYW8SSSC"
    ),
  );

  // ✅ Notification Permission (Web)
  final permission = await html.Notification.requestPermission();
  if (permission == 'granted') {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    final token = await messaging.getToken(
      vapidKey:
          "BO21sMCKf7mbIwAD9mqfXFJ5IOOV1QQ-jVjt_NWm5Vm4EKucnY9N7V22DnrkOulf9Zt1geeTf0_7ciCa3E1Whpk",
    );

    print("FCM Token for this browser: $token");
  } else {
    print("Notification permission denied by user.");
  }

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      //enableLog: true,
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
