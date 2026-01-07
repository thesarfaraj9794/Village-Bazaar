// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import 'package:village_bazzar/models/cart-model.dart';
import 'package:village_bazzar/screens/user-panel/checkout-screen.dart';
import 'package:village_bazzar/utils/app-constant.dart';
import '../../controllers/cart-price-controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        elevation: 0,
        title: Text(
          'My Cart',
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
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          
          if (snapshot.hasError) {
            return Center(child: Text("Error loading cart"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "Your cart is empty!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
              final data = productData.data() as Map<String, dynamic>;

              data['isGram'] = data['isGram'] ?? false;

              CartModel cartModel = CartModel(
                productId: data['productId'],
                categoryId: data['categoryId'],
                productName: data['productName'],
                categoryName: data['categoryName'],
                salePrice: data['salePrice'],
                fullPrice: data['fullPrice'],
                productImages: data['productImages'],
                deliveryTime: data['deliveryTime'],
                isSale: data['isSale'],
                isGram: data['isGram'],
                productDescription: data['productDescription'],
                createdAt: data['createdAt'],
                updatedAt: data['updatedAt'],
                productQuantity: data['productQuantity'],
                productTotalPrice:
                    double.parse(data['productTotalPrice'].toString()),
              );

              productPriceController.fetchProductPrice();

              return SwipeActionCell(
                key: ObjectKey(cartModel.productId),
                trailingActions: [
                  SwipeAction(
                    title: "Delete",
                    // icon: Icons.delete,
                    // foregroundColor: Colors.white,
                    color: Colors.red,
                    forceAlignmentToBoundary: true,
                    performsFirstActionWithFullSwipe: true,
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

                /// ======================= PRODUCT CARD (NEW UI) =======================
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        /// LEFT SIDE IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            cartModel.productImages[0],
                            height: 75,
                            width: 75,
                            fit: BoxFit.cover,
                          ),
                        ),

                        SizedBox(width: 12),

                        /// MIDDLE DETAILS
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              /// PRODUCT NAME
                              Text(
                                cartModel.productName,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              SizedBox(height: 4),

                              /// CATEGORY + PRICE
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Chip(
                                    label: Text(
                                      cartModel.categoryName,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppConstant.appMainColor,
                                      ),
                                    ),
                                    backgroundColor:
                                        AppConstant.appMainColor.withOpacity(0.1),
                                    padding: EdgeInsets.zero,
                                  ),

                                  Text(
                                    "₹${cartModel.productTotalPrice.toStringAsFixed(1)}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 2),

                              /// ================= QUANTITY STEPPER ==================
                              Container(
                                margin: EdgeInsets.only(top: 4),
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    /// MINUS BUTTON
                                    GestureDetector(
                                      onTap: () async {
                                        int minQty = cartModel.isGram ? 500 : 1;

                                        if (cartModel.productQuantity > minQty) {
                                          double price = cartModel.isSale
                                              ? double.parse(cartModel.salePrice)
                                              : double.parse(cartModel.fullPrice);

                                          int newQty = cartModel.isGram
                                              ? cartModel.productQuantity - 500
                                              : cartModel.productQuantity - 1;

                                          await FirebaseFirestore.instance
                                              .collection('cart')
                                              .doc(user!.uid)
                                              .collection('cartOrders')
                                              .doc(productData.id)
                                              .update({
                                            'productQuantity': newQty,
                                            'productTotalPrice': cartModel.isGram
                                                ? price * (newQty / 500)
                                                : price * newQty,
                                          });
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundColor: Colors.red.shade50,
                                        child: Icon(Icons.remove,
                                            color: Colors.red, size: 18),
                                      ),
                                    ),

                                    SizedBox(width: 12),

                                    /// QUANTITY TEXT
                                    Text(
                                      cartModel.isGram
                                          ? formatWeight(cartModel.productQuantity)
                                          : cartModel.productQuantity.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(width: 12),

                                    /// PLUS BUTTON
                                    GestureDetector(
                                      onTap: () async {
                                        double price = cartModel.isSale
                                            ? double.parse(cartModel.salePrice)
                                            : double.parse(cartModel.fullPrice);

                                        int newQty = cartModel.isGram
                                            ? cartModel.productQuantity + 500
                                            : cartModel.productQuantity + 1;

                                        await FirebaseFirestore.instance
                                            .collection('cart')
                                            .doc(user!.uid)
                                            .collection('cartOrders')
                                            .doc(productData.id)
                                            .update({
                                          'productQuantity': newQty,
                                          'productTotalPrice': cartModel.isGram
                                              ? price * (newQty / 500)
                                              : price * newQty,
                                        });
                                      },
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundColor: Colors.green.shade50,
                                        child: Icon(Icons.add,
                                            color: Colors.green, size: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      /// ===================== BOTTOM CHECKOUT BAR =======================
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
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
                onPressed: () {
                  Get.to(() => CheckOutScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.appMainColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  "Checkout",
                  style: TextStyle(
                    color: AppConstant.appTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// FORMAT WEIGHT (500 → 500g | 1500 → 1.5kg)
String formatWeight(int grams) {
  if (grams < 1000) {
    return "${grams} g";
  } else {
    double kg = grams / 1000;

    return (kg % 1 == 0) ? "${kg.toInt()} kg" : "${kg.toStringAsFixed(1)} kg";
  }
}

