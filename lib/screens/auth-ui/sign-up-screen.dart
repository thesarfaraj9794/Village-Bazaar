import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:village_bazzar/controllers/sign-up-controller.dart';
import 'package:village_bazzar/screens/auth-ui/sign-in-screen.dart';
import 'package:village_bazzar/utils/app-constant.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SignupScreen> {
  
  final RxBool _isPasswordVisible = false.obs;
  final SignUpController signUpController=Get.put(SignUpController());
  TextEditingController username =TextEditingController();
  TextEditingController userEmail =TextEditingController();
  TextEditingController userPhone =TextEditingController();
  TextEditingController userCity =TextEditingController();
  TextEditingController userPassword =TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          

          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 153, 172, 197),
            centerTitle: true,
            title: const Text(
              "Sign in",
              style: TextStyle(color: Colors.white), 
            ),
            iconTheme: const IconThemeData(color: Colors.white), 
          ),
          
          body: SingleChildScrollView(
        
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: SizedBox(
        
              width: Get.width, 
              child: Column(
                
                crossAxisAlignment: CrossAxisAlignment.center,
                
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                
                  isKeyboardVisible
                      ? Padding(
                    
                          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Text(
                            "Welcome Back!",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: AppConstant.appScendoryColor,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            
                          Container(
                            alignment: Alignment.center,
                            child: Text("Welcome to my app",style: TextStyle(fontSize: 13.0),)),
                          ],
                        ),

                
                  const SizedBox(height: 25.0),

            
                  TextFormField(
                    controller: username,
                    cursorColor: AppConstant.appScendoryColor,
                    
                    decoration: InputDecoration(
                      hintText: " Enter your Name",
                      prefixIcon: Icon(Icons.person, color: AppConstant.appScendoryColor),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: AppConstant.appScendoryColor, width: 2.0),
                      ),
                    ),
                  ),


                  SizedBox(height: 20.0,),

                   TextFormField(
                    controller: userEmail,
                    cursorColor: AppConstant.appScendoryColor,
                    
                    decoration: InputDecoration(
                      hintText: "Enter your Email",
                      prefixIcon: Icon(Icons.email, color: AppConstant.appScendoryColor),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: AppConstant.appScendoryColor, width: 2.0),
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                   TextFormField(
                    controller: userPhone,
                    cursorColor: AppConstant.appScendoryColor,
                  
                    decoration: InputDecoration(
                      hintText: "Enter your Number",
                      prefixIcon: Icon(Icons.call, color: AppConstant.appScendoryColor),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: AppConstant.appScendoryColor, width: 2.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                   TextFormField(
                    controller:userCity ,
                    cursorColor: AppConstant.appScendoryColor,
                
                    decoration: InputDecoration(
                      hintText: " Enter your City",
                      prefixIcon: Icon(Icons.location_city, color: AppConstant.appScendoryColor),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: AppConstant.appScendoryColor, width: 2.0),
                      ),
                    ),
                  ),




              
                  const SizedBox(height: 15.0),

                
                  Obx(
                    () => TextFormField(
                      controller: userPassword,
                      cursorColor: AppConstant.appScendoryColor,
                      obscureText: !_isPasswordVisible.value,
                      //obscureText: signUpController.isPasswordVisible.value,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: "Enter your Password",
                        prefixIcon: Icon(Icons.lock, color: AppConstant.appScendoryColor),
                      
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                            color: AppConstant.appScendoryColor,
                          ),
                          onPressed: () {
                            _isPasswordVisible.value = !_isPasswordVisible.value;
                          },
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: AppConstant.appScendoryColor, width: 2.0),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10.0),

            
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                    
                      },
                      child: Text(
                        "Forget password",
                        style: TextStyle(
                          color: AppConstant.appScendoryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  
                  const SizedBox(height: 25.0),

            
                  Material(
                    child: Container(
                    
                      width: Get.width * 0.45,
              
                      height: Get.height / 18, 
                      decoration: BoxDecoration(
                        color: AppConstant.appScendoryColor,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstant.appScendoryColor.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: ()async {
                          String name=username.text.trim();
                          String Email=userEmail.text.trim();
                          String City=userCity.text.trim();
                          String password=userPassword.text.trim();
                          String phone =userPhone.text.trim();
                          String userDeviceToken='';

                          if(name.isEmpty|| Email.isEmpty||City.isEmpty||password.isEmpty||phone.isEmpty){
                            Get.snackbar("error", "please enter all details",
                             snackPosition: SnackPosition.BOTTOM,
                             backgroundColor: const Color.fromARGB(255, 153, 172, 197),
                             colorText: Colors.black,
                            
                            );
                          }else{
                            UserCredential? userCredential =await  signUpController.signUpMethod(
                              name, 
                              Email, 
                              phone, 
                              City,
                              password,
                              userDeviceToken
                              );

                              if(userCredential!=null){
                                Get.snackbar("Verification email sent.", "please check your email",
                             snackPosition: SnackPosition.BOTTOM,
                             backgroundColor: const Color.fromARGB(255, 153, 172, 197),
                             colorText: Colors.black
                            
                            );
                            FirebaseAuth.instance.signOut();
                            Get.offAll(()=>SigninScreen());


                              }
                          }



                         // _googleSignInController.signInWithGoogle();

                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  
                  const SizedBox(height: 15.0),

                
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          
                        },
                        child: GestureDetector(
                           onTap: () => Get.to( ()=> SigninScreen() ),
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              color: AppConstant.appScendoryColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
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
      },
    );
  }
}
