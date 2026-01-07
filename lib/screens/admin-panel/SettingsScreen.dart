import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f7f7),

      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),

      body: ListView(
        padding: EdgeInsets.all(20),
        children: [

          // ================= ADMIN PROFILE HEADING =================
          Text(
            "Admin Settings",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20),

          // ================= PROFILE SETTINGS =================
          settingsTile(
            icon: Icons.person,
            title: "Profile",
            subtitle: "Update admin details",
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => AdminProfilePage()),
              // );
            },
          ),

          settingsTile(
            icon: Icons.lock,
            title: "Change Password",
            subtitle: "Update your secure login password",
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => ChangePasswordPage()),
              // );
            },
          ),

          SizedBox(height: 30),

          Text(
            "App Management",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20),

          // ================== CATEGORY MANAGEMENT ==================
          settingsTile(
            icon: Icons.category,
            title: "Manage Categories",
            subtitle: "Add, edit or remove product categories",
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => ManageCategoryPage()),
              // );
            },
          ),

          // ================== BANNER MANAGEMENT ==================
          settingsTile(
            icon: Icons.image,
            title: "Manage Banners",
            subtitle: "Home banners for users",
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => ManageBannerPage()),
              // );
            },
          ),

          // ================== DELIVERY SETTINGS ==================
          settingsTile(
            icon: Icons.delivery_dining,
            title: "Delivery Charges",
            subtitle: "Set delivery charges",
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => DeliveryChargePage()),
              // );
            },
          ),

          SizedBox(height: 30),

          Text(
            "Other",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20),

          settingsTile(
            icon: Icons.logout,
            title: "Logout",
            subtitle: "Sign out from admin panel",
            color: Colors.red,
            onTap: () {
              // TODO logout code
            },
          ),
        ],
      ),
    );
  }

  // ================== REUSABLE SETTINGS TILE ==================
  Widget settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Function onTap,
    Color color = Colors.amber,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 1,
              offset: Offset(2, 4),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
