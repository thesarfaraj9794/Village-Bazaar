// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import 'package:village_bazzar/controllers/get-customer-device-token-controller.dart';
import 'package:village_bazzar/models/cart-model.dart';
import 'package:village_bazzar/services/place-order-service.dart';
import 'package:village_bazzar/utils/app-constant.dart';
import '../../controllers/cart-price-controller.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());

  // TEXT CONTROLLERS
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  // ⬇️ FETCH USER DETAILS AUTOMATICALLY
  Future<void> fetchUserData() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    if (snapshot.exists) {
      var data = snapshot.data()!;
      nameController.text = data["username"] ?? "";
      phoneController.text = data["phone"] ?? "";
      addressController.text = data["userAddress"] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        elevation: 0,
        title: Text(
          "Checkout",
          style: TextStyle(
            color: AppConstant.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error loading cart"));

          if (!snapshot.hasData) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Your cart is empty!"));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];

              CartModel cartModel = CartModel(
                productId: productData['productId'],
                categoryId: productData['categoryId'],
                productName: productData['productName'],
                categoryName: productData['categoryName'],
                salePrice: productData['salePrice'],
                fullPrice: productData['fullPrice'],
                productImages: productData['productImages'],
                deliveryTime: productData['deliveryTime'],
                isSale: productData['isSale'],
                isGram: productData['isGram'],
                productDescription: productData['productDescription'],
                createdAt: productData['createdAt'],
                updatedAt: productData['updatedAt'],
                productQuantity: productData['productQuantity'],
                productTotalPrice:
                    double.parse(productData['productTotalPrice'].toString()),
              );

              productPriceController.fetchProductPrice();

              return SwipeActionCell(
                key: ObjectKey(cartModel.productId),
                trailingActions: [
                  SwipeAction(
                    title: "Remove",
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onTap: (handler) async {
                      await FirebaseFirestore.instance
                          .collection('cart')
                          .doc(user!.uid)
                          .collection('cartOrders')
                          .doc(productData.id)
                          .delete();
                    },
                  ),
                ],

                child: Container(
                  margin: EdgeInsets.only(bottom: 14),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          cartModel.productImages[0],
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartModel.productName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 6),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${cartModel.productQuantity} pcs",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  "₹${cartModel.productTotalPrice}",
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  "Total: ₹${productPriceController.totalPrice.value.toStringAsFixed(1)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => showCustomBottomSheet(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.appMainColor,
                  padding: EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  "Confirm Order",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppConstant.appTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================= BOTTOM SHEET =========================
  void showCustomBottomSheet() async {

    await fetchUserData();   // ⭐ AUTO-FILL FROM ACCOUNT SECTION

    Get.bottomSheet(
      Container(
        height: Get.height * 0.75,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Delivery Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 20),

              buildPremiumField(
                controller: nameController,
                label: "Full Name",
                icon: Icons.person,
              ),

              SizedBox(height: 14),

              buildPremiumField(
                controller: addressController,
                label: "Delivery Address",
                icon: Icons.location_on,
              ),

              SizedBox(height: 14),

              buildPremiumField(
                controller: phoneController,
                label: "Phone Number",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.appMainColor,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        phoneController.text.isNotEmpty &&
                        addressController.text.isNotEmpty) {

                      String customerToken = await getCustomerDeviceToken();

                      placeOrder(
                        context: context,
                        customerName: nameController.text.trim(),
                        customerPhone: phoneController.text.trim(),
                        customerAddress: addressController.text.trim(),
                        customerDeviceToken: customerToken,
                      );
                    } else {
                      Get.snackbar(
                        "Error",
                        "Please fill all details",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.shade400,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: Text(
                    "Place Order",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  // ======================= INPUT FIELD WIDGET =======================
  Widget buildPremiumField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppConstant.appMainColor),
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
