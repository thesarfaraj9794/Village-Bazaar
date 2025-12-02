import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:village_bazzar/controllers/get-user-data-controller.dart';
import 'package:village_bazzar/controllers/sign-in-controller.dart';
import 'package:village_bazzar/screens/admin-panel/admin-main-screen.dart';
import 'package:village_bazzar/screens/auth-ui/forget-password-screen.dart';
import 'package:village_bazzar/screens/auth-ui/sign-up-screen.dart';
import 'package:village_bazzar/screens/user-panel/main-screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen>
    with SingleTickerProviderStateMixin {
  final RxBool _isPasswordVisible = false.obs;
  final SignInController signInController = Get.put(SignInController());
  final getUserDataController =
      Get.put(GetUserDataController(), permanent: true);

  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  late AnimationController _logoController;
  late Animation<Offset> _logoAnimation;

  @override
  void initState() {
    super.initState();

    // Floating animation setup
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _logoAnimation = Tween<Offset>(
      begin: const Offset(0, -0.02), // halka upar
      end: const Offset(0, 0.02),    // halka neeche
    ).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 153, 172, 197),
          appBar: AppBar(
            backgroundColor:   Color.fromARGB(255, 153, 172, 197),
            
            centerTitle: true,
            title: const Text("Sign in",
                style: TextStyle(color: Colors.black)),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: Get.height - kToolbarHeight - 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ========================= FLOATING PNG LOGO ===============================
                  
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double screenWidth = constraints.maxWidth;
                        double screenHeight = Get.height;

                        return Center(
                          child: SizedBox(
                            height: screenHeight * (screenWidth > 600 ? 0.32 : 0.45),
                            width: screenWidth * (screenWidth > 600 ? 0.40 : 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                //color: const Color.fromARGB(255, 11, 16, 61)
                              ),
                              child: SlideTransition(
                                position: _logoAnimation,
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width: 380,
                                  height: 380,
                                  
                                  
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 20),

                  // ========================= EMAIL ===============================
                  TextFormField(
                    controller: userEmail,
                    cursorColor: const Color.fromARGB(255, 19, 33, 58),
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 20, 32, 48), width: 2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ========================= PASSWORD ===============================
                  Obx(
                    () => TextFormField(
                      controller: userPassword,
                      cursorColor: const Color.fromARGB(255, 14, 27, 44),
                      obscureText: !_isPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock, color: Colors.black),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromARGB(255, 50, 53, 56),
                          ),
                          onPressed: () =>
                              _isPasswordVisible.value = !_isPasswordVisible.value,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 18, 38, 65), width: 2),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ========================= FORGOT PASSWORD ===============================
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Get.to(() => ForgetPasswordScreen()),
                      child: const Text(
                        "Forget password ?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 32, 51, 77),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ========================= SIGN IN BUTTON ===============================
                  Container(
                    width: Get.width * 0.45,
                    height: Get.height / 18,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 29, 39, 53),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        String email = userEmail.text.trim();
                        String password = userPassword.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please enter all details",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor:
                                const Color.fromARGB(255, 192, 198, 206),
                            colorText: Colors.black,
                          );
                          return;
                        }

                        try {
                          UserCredential? userCredential =
                              await signInController.signInMethod(
                                  email, password);

                          if (userCredential == null ||
                              userCredential.user == null) {
                            Get.snackbar(
                                "Error",
                                "Invalid credentials. Please try again.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    const Color.fromARGB(255, 192, 198, 206),
                                colorText: Colors.black);
                            return;
                          }

                          if (!userCredential.user!.emailVerified) {
                            Get.snackbar(
                                "Error",
                                "Please verify your email before login.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    const Color.fromARGB(255, 192, 198, 206),
                                colorText: Colors.white);
                            return;
                          }

                          var userData = await getUserDataController
                              .getUserData(userCredential.user!.uid);

                          if (userData.isEmpty) {
                            Get.snackbar("Error", "User data not found.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    const Color.fromARGB(255, 192, 198, 206),
                                colorText: Colors.black);
                            return;
                          }

                          if (userData[0]['isAdmin'] == true) {
                            Get.snackbar("Success", "Admin login successful!",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    const Color.fromARGB(255, 192, 198, 206),
                                colorText: Colors.black);
                            Get.offAll(() => AdminMainScreen());
                          } else {
                            Get.snackbar("Success", "Login successful!",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    const Color.fromARGB(255, 192, 198, 206),
                                colorText: Colors.black);
                            Get.offAll(() => MainScreen());
                          }
                        } catch (e) {
                          Get.snackbar("Error", "Login failed: $e",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor:
                                  const Color.fromARGB(255, 192, 198, 206),
                              colorText: Colors.black);
                        }
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ========================= SIGN UP LINK ===============================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ",
                          style: TextStyle(color: Colors.white)),
                          SizedBox(width: 2,),
                      GestureDetector(
                        onTap: () => Get.to(() => SignupScreen()),
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            color: Color.fromARGB(255, 13, 49, 97),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      
    
  }
}
