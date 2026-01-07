import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:village_bazzar/screens/admin-panel/order_details.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  // ===================== DELETE ORDER =====================
  Future<void> deleteOrder(String userId, String orderId) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(userId)
        .collection("confirmOrders")
        .doc(orderId)
        .delete();
  }

  // ===================== DELETE CONFIRMATION =====================
  void confirmDelete(BuildContext context, String userId, String orderId) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Delete Order"),
          content: Text("Are you sure you want to delete this order?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(ctx),
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await deleteOrder(userId, orderId);
                Navigator.pop(ctx);  
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Orders"),
        backgroundColor: Colors.amber,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              String userId = users[index].id;

              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("orders")
                    .doc(userId)
                    .collection("confirmOrders")
                    .snapshots(),

                builder: (context, snap2) {
                  if (!snap2.hasData) return SizedBox();

                  var orders = snap2.data!.docs;

                  return Column(
                    children: orders.map((order) {
                      var data = order.data();
                      String orderId = order.id;

                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(
                            data["customerName"] ?? "",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          subtitle: Text(
                            "Total Price: ₹${data["productTotalPrice"] ?? 0}",
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  confirmDelete(context, userId, orderId);
                                },
                              ),
                              Icon(Icons.arrow_forward_ios),
                            ],
                          ),

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderDetailScreen(
                                  userId: userId,
                                  orderId: orderId,
                                  orderData: data,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
