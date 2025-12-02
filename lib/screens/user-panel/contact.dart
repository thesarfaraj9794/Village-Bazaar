import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  // ------------------- LAUNCHERS -------------------
  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> launchWhatsApp() async {
    String number = "919334810771";
    String message = "Hello! I would like to contact you.";
    String url = "https://wa.me/$number?text=${Uri.encodeComponent(message)}";
    openUrl(url);
  }

  Future<void> launchCall() async {
    final uri = Uri(scheme: "tel", path: "9334810771");
    await launchUrl(uri);
  }

  Future<void> launchMail() async {
    final uri = Uri(
      scheme: "mailto",
      path: "yourmail@gmail.com",
      query: "subject=Inquiry&body=Hello!",
    );
    await launchUrl(uri);
  }

  // ------------------- UI START -------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F6F9),

      // Floating WhatsApp Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: launchWhatsApp,
        child: Icon(Icons.chat_bubble, size: 28, color: Colors.white),
      ),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffF4F6F9),
        centerTitle: true,
        title: Text(
          "Contact Us",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ----------------- GLASS HEADER -----------------
            Container(
              margin: EdgeInsets.all(16),
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.withOpacity(0.7),
                    Colors.blue.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 12,
                      offset: Offset(0, 4),
                      color: Colors.black.withOpacity(0.15))
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: Icon(Icons.person,
                          size: 38, color: Colors.deepPurple),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "We'd love to hear from you",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // ----------------- CONTACT OPTIONS -----------------
            buildTitle("Connect With Us"),

            contactTile(
              title: "Call Now",
              subtitle: "+91 9334810771",
              icon: Icons.call,
              color: Colors.blueAccent,
              onTap: launchCall,
            ),

            // contactTile(
            //   title: "WhatsApp",
            //   subtitle: "Chat instantly",
            //   //icon: Icons.whatsapp,
            //   color: Colors.green,
            //   onTap: launchWhatsApp, icon: null,
            // ),

            contactTile(
              title: "Email Us",
              subtitle: "yourmail@gmail.com",
              icon: Icons.email,
              color: Colors.redAccent,
              onTap: launchMail,
            ),

            contactTile(
              title: "Instagram",
              subtitle: "@yourusername",
              icon: Icons.camera_alt,
              color: Colors.pink,
              onTap: () => openUrl("https://instagram.com/yourusername"),
            ),

            contactTile(
              title: "LinkedIn",
              subtitle: "View Profile",
              icon: Icons.business_center,
              color: Colors.blue,
              onTap: () => openUrl("https://linkedin.com/in/yourprofile"),
            ),

            SizedBox(height: 20),

            // ----------------- ADDRESS SECTION -----------------
            buildTitle("Reach Us"),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      offset: Offset(0, 4),
                      color: Colors.black.withOpacity(0.1))
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on,
                      color: Colors.deepPurple, size: 30),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      "Patna, Bihar, India",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ----------------- TITLE SECTION -----------------
  Widget buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  // ----------------- CONTACT TILE -----------------
  Widget contactTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                offset: Offset(0, 5),
                color: Colors.black.withOpacity(0.07))
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, size: 28, color: color),
            ),
            SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black)),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios,
                size: 18, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }
}
