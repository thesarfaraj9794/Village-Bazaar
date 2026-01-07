import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  final String userId;
  final String orderId;
  final Map<String, dynamic> orderData;

  OrderDetailScreen({
    super.key,
    required this.userId,
    required this.orderId,
    required this.orderData,
  });

  markDelivered() async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(userId)
        .collection("confirmOrders")
        .doc(orderId)
        .update({
      "status": true,
      "updatedAt": DateTime.now().toString(),
    });
  }

  markPending() async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(userId)
        .collection("confirmOrders")
        .doc(orderId)
        .update({
      "status": false,
      "updatedAt": DateTime.now().toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final img = orderData["productImages"][0];

    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        backgroundColor: Colors.amber,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Image.network(img, height: 200, width: double.infinity, fit: BoxFit.cover),

            SizedBox(height: 20),

            Text("Product Name: ${orderData['productName']}", style: styleBold()),
            //Text("Description: ${orderData['productDescription']}"),
            Text("Quantity: ${orderData['productQuantity']}"),
            Text("Total Price: ₹${orderData['productTotalPrice']}"),

            Divider(),
            Text("Customer Info", style: styleBold()),
            Text("Name: ${orderData['customerName']}"),
            Text("Phone: ${orderData['customerPhone']}"),
            Text("Address: ${orderData['customerAddress']}"),

            Divider(),
            Text("Order Status:", style: styleBold()),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: orderData["status"] == true ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                orderData["status"] == true ? "Delivered" : "Pending",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () { markDelivered(); Navigator.pop(context); },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text("Mark Delivered", style: TextStyle(color: Colors.white)),
                ),

                ElevatedButton(
                  onPressed: () { markPending(); Navigator.pop(context); },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Mark Pending", style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextStyle styleBold() => TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
}
