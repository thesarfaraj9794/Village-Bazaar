import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:village_bazzar/screens/admin-panel/admin_add_products.dart';

import 'package:village_bazzar/screens/auth-ui/welcome-screen.dart';
import 'package:village_bazzar/screens/user-panel/all-orders-screen.dart';
import 'package:village_bazzar/screens/user-panel/all-products-screen.dart';
import 'package:village_bazzar/screens/user-panel/contact.dart';
import 'package:village_bazzar/screens/user-panel/main-screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  User?username= FirebaseAuth.instance.currentUser;
   late Future<DocumentSnapshot> _userFuture;

  @override
  void initState() {
    super.initState();
    
    _userFuture = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsetsGeometry.only(

      top: Get.height/25),
      child: Drawer(
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0)
          )
        ),
        child: Wrap(
          runSpacing: 10,
          children: [
            Padding(
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
  child: FutureBuilder<DocumentSnapshot>(
    future: _userFuture,
    builder: (context, snapshot) {
      if (!snapshot.hasData || snapshot.hasError) {
        return ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          title: Text("User", style: TextStyle(color: Colors.white)),
          subtitle: Text("Version 1.0.1",
              style: TextStyle(color: Colors.white70)),
          leading: CircleAvatar(
            radius: 22.0,
            backgroundColor: Colors.white,
            child: Text("U"),
          ),
        );
      }

      if (!snapshot.data!.exists) {
        return ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          title: Text("User", style: TextStyle(color: Colors.white)),
          subtitle: Text("Version 1.0.1",
              style: TextStyle(color: Colors.white70)),
          leading: CircleAvatar(
            radius: 22.0,
            backgroundColor: Colors.white,
            child: Text("U"),
          ),
        );
      }

      Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;
      String name = data['username'] ?? "User";

      return ListTile(
        titleAlignment: ListTileTitleAlignment.center,
        title: Text(name, style: TextStyle(color: Colors.white)),
        subtitle: Text("Version 1.0.1",
            style: TextStyle(color: Colors.white70)),
        leading: CircleAvatar(
          radius: 22.0,
          backgroundColor: Colors.white,
          child: Text(name[0].toUpperCase()),
        ),
      );
    },
  ),
),

        

            Divider(
              indent: 10.0,
              endIndent: 10.0,
              thickness: 1.5,
              color: Colors.grey,
            ),
             Padding(padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text("Home",style: TextStyle(color: Colors.white)),
              
              leading: Icon(Icons.home,color: Colors.white),
              trailing: Icon(Icons.arrow_forward,color: Colors.white),
              onTap: () {
                Get.back();
                Get.to(()=>MainScreen());
              },
            ),
            
            ),
             Padding(padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text("Product",style: TextStyle(color: Colors.white),),
              
              leading: Icon(Icons.production_quantity_limits,color: Colors.white,),
              trailing: Icon(Icons.arrow_forward,color: Colors.white),
                  onTap: () {
                Get.back();
                Get.to(()=>AllProductsScreen());
              },

            ),
            
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text("Orders"),
              
              leading: Icon(Icons.shopping_bag),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Get.back();
                Get.to(()=>AllOrderScreen());
              },
            ),
            
            ),
          
           
            Padding(padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text("Contact",style: TextStyle(color: Colors.white)),
              
              leading: Icon(Icons.help,color: Colors.white),
              trailing: Icon(Icons.arrow_forward,color: Colors.white),
                onTap: () {
                Get.back();
                Get.to(()=>ContactScreen());
              },
            ),
            
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: ListTile(
              onTap: ()async {
                // GoogleSignIn googleSignIn = GoogleSignIn();
                 FirebaseAuth _auth=FirebaseAuth.instance;
              await _auth.signOut();
              await FirebaseAuth.instance.signOut();
              
              Get.offAll(()=>WelcomeScreen());
              },
              titleAlignment: ListTileTitleAlignment.center,
              title: Text("Logout",style: TextStyle(color: Colors.white)),
              
              leading: Icon(Icons.logout,color: Colors.white),
              trailing: Icon(Icons.arrow_forward,color: Colors.white),
            ),
            
            ),

          ],
        ),
      
      ),
    
    );
  }
}