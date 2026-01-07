import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_profile_screen.dart'; // Ensure this file exists
import '../auth-ui/welcome-screen.dart'; // Ensure this file exists

class AccountScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  // Private helper widget for info cards (defined outside build for cleanliness)
  Widget _infoCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100, width: 1),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5))
          ]),
      child: Row(children: [
        Icon(icon, size: 24, color: color),
        SizedBox(width: 15),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                SizedBox(height: 3),
                Text(value,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800)),
              ]),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check for user existence immediately to handle null safely
    if (user == null) {
      // Should not happen if routed correctly, but good practice
      return Center(child: Text("User not logged in."));
    }

    return Scaffold(
      backgroundColor: Color(0xFFF7F9FB), // Light background for contrast
      
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 203, 209, 211),
        elevation: 0,
        title: Text("My Account",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditProfileScreen()),
              );
            },
            icon: Icon(Icons.edit_outlined, color: Colors.green.shade700),
            tooltip: "Edit Profile",
          ),
          SizedBox(width: 8),
        ],
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          // --- LOADING STATE ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.green.shade700));
          }

          // --- ERROR STATE ---
          if (snapshot.hasError) {
            return Center(child: Text("Error fetching data."));
          }
          
          // --- DATA STATE ---
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("User data not found."));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;

          // Data retrieval with improved defaults
          String name = data['username'] ?? "Guest User";
          String email = data['email'] ?? user!.email ?? "Email not available";
          String phone = data['phone'] ?? "N/A";
          String city = data['city'] ?? "N/A";
          String address = data['userAddress'] ?? "Address not set";
          
          String initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
          
          // Get the primary color from the initial file
          final primaryColor = const Color.fromARGB(255, 127, 173, 190);


          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // 1. PREMIUM PROFILE HEADER
                Container(
                  padding: EdgeInsets.all(25),
                  margin: EdgeInsets.only(bottom: 25),
                  decoration: BoxDecoration(
                    color: primaryColor, // Use the primary color
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10))
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white,
                        child: Text(initial,
                            style: TextStyle(
                                fontSize: 30,
                                color: primaryColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 18),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              SizedBox(height: 4),
                              Text(email,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70)),
                            ]),
                      )
                    ],
                  ),
                ),

                // 2. INFORMATION CARDS
                Text("Contact Information", 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                SizedBox(height: 10),

                _infoCard("Mobile Number", phone, Icons.phone_android, primaryColor),
                _infoCard("Email Address", email, Icons.email_outlined, primaryColor),
                
                SizedBox(height: 20),

                Text("Location Details", 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                SizedBox(height: 10),

                _infoCard("City/Area", city, Icons.location_city_outlined, primaryColor),
                _infoCard("Full Address", address, Icons.location_on_outlined, primaryColor),
                

                SizedBox(height: 30),

                // 3. LOGOUT BUTTON
                ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    padding:
                        EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: Icon(Icons.logout, color: Colors.white, size: 24),
                  label: Text("Logout Securely",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}