import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminReviewsScreen extends StatelessWidget {
  const AdminReviewsScreen({super.key});

  deleteReview(String id) {
    FirebaseFirestore.instance.collection("reviews").doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("All Reviews"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("reviews")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var reviews = snapshot.data!.docs;

          if (reviews.isEmpty) return Center(child: Text("No reviews yet"));

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, i) {
              var data = reviews[i].data();
              String id = reviews[i].id;

              return Card(
                margin: EdgeInsets.all(12),
                child: ListTile(
                  title: Text("${data['userName']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Rating: ⭐ ${data['rating']}"),
                      Text("${data['reviewText']}"),
                      Text("At: ${data['createdAt']}"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteReview(id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
