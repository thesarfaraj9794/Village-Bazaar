import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:village_bazzar/controllers/get-device-token-controller.dart';
import 'package:village_bazzar/models/user-model.dart';
import 'package:village_bazzar/screens/user-panel/main-screen.dart';

class GoogleSignInController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
     final GetDeviceTokenController getDeviceTokenController =
       Get.put(GetDeviceTokenController());
     

    try {
      EasyLoading.show(status: "Please wait...");

      // ✅ Flutter Web uses popup sign-in
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      final UserCredential userCredential =
          await _auth.signInWithPopup(googleProvider);
    

      final User? user = userCredential.user;

      if (user != null) {
        UserModel userModel = UserModel(
          uId: user.uid,
          username: user.displayName ?? '',
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
          userImg: user.photoURL ?? '',
          userDeviceToken: getDeviceTokenController.deviceToken.toString(),
          country: '',
          userAddress: '',
          street: '',
          isAdmin: false,
          isActive: true,
          createdOn: DateTime.now(),
          city: '',
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap(), SetOptions(merge: true));

        EasyLoading.dismiss();
        Get.offAll(() => MainScreen());
      } else {
       EasyLoading.dismiss();
        print("User is null after sign-in");
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Google Sign-In Error: $e");
    }
  }
}
