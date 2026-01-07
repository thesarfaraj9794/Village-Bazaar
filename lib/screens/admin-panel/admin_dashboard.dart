import 'package:flutter/material.dart';
import 'package:village_bazzar/screens/admin-panel/SettingsScreen.dart';
import 'package:village_bazzar/screens/admin-panel/admin-main-screen.dart';
import 'admin_orders_screen.dart';
import 'admin_reviews_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f7f7),

      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.amber,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: LayoutBuilder(
          builder: (context, constraints) {

            // 👉 SCREEN WIDTH CHECK
            int columns = constraints.maxWidth < 600 ? 2 : 4;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),

                Text(
                  "Welcome Admin 👋",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  "Manage your store activities quickly",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),

                SizedBox(height: 25),

                // ================== RESPONSIVE GRID ==================
                Expanded(
                  child: GridView.count(
                    crossAxisCount: columns, // 👈 AUTO COLUMN COUNT
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1,
                    children: [

                      dashboardCard(
                        title: "Add Product",
                        icon: Icons.add_box,
                        color: Colors.amber,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AdminMainScreen()),
                          );
                        },
                      ),

                      dashboardCard(
                        title: "View Orders",
                        icon: Icons.shopping_bag,
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AdminOrdersScreen()),
                          );
                        },
                      ),

                      dashboardCard(
                        title: "Reviews",
                        icon: Icons.reviews,
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AdminReviewsScreen()),
                          );
                        },
                      ),

                      dashboardCard(
                        title: "Settings",
                        icon: Icons.settings,
                        color: Colors.deepPurple,
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>AdminSettingsScreen()),
                        

                          );
                        },
                      ),

                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ---------------- CARD WIDGET ----------------
  Widget dashboardCard({
    required String title,
    required IconData icon,
    required Color color,
    required Function onTap,
  }) {
    return InkWell(
      onTap: () => onTap(),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 35),
            ),
            SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
