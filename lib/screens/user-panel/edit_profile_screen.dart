import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  TextEditingController village = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController stateCtrl = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    if (data.exists) {
      fullName.text = data['username'] ?? "";
      phone.text = data['phone'] ?? "";
      city.text = data['city'] ?? "";
      village.text = data['village'] ?? "";
      stateCtrl.text = data['state'] ?? "";
      pincode.text = data['pincode'] ?? "";
    }
  }

  saveProfile() async {
    String address =
        "${village.text}, ${city.text}, ${stateCtrl.text} - ${pincode.text}";

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .set({
      "username": fullName.text.trim(),
      "phone": phone.text.trim(),
      "village": village.text.trim(),
      "city": city.text.trim(),
      "state": stateCtrl.text.trim(),
      "pincode": pincode.text.trim(),
      "userAddress": address,
    }, SetOptions(merge: true));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F7FA),

      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        title:
            Text("Edit Profile", style: TextStyle(color: Colors.white)),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          field("Full Name", fullName),
          field("Phone Number", phone),
          field("Village", village),
          field("City", city),
          field("State", stateCtrl),
          field("Pincode", pincode),

          SizedBox(height: 20),

          ElevatedButton(
              onPressed: saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text("Save", style: TextStyle(color: Colors.white)))
        ]),
      ),
    );
  }

  Widget field(String label, TextEditingController c) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14)),
            filled: true,
            fillColor: Colors.white),
      ),
    );
  }
}
