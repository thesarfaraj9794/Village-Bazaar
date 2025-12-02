import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetUserDataController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Object?>>> getUserData(String uId) async {
    try {
      // Execute the query properly with .get()
      final QuerySnapshot userData = await _firestore
          .collection('users')
          .where('uId', isEqualTo: uId)  // <-- Use 'uId' exactly as in Firestore
    .get();

      print("Fetched User Data: ${userData.docs}");
      return userData.docs;
    } catch (e) {
      print("Error fetching user data: $e");
      return [];
    }
  }
}
