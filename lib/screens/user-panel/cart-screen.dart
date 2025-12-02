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
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('Cart Screen'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No products found!"),
            );
          }

          if (snapshot.data != null) {
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  final data = productData.data() as Map<String, dynamic>;

// isGram ko default value de do
data['isGram'] = data['isGram'] ?? false;


                 // final data = productData.data() as Map<String, dynamic>;

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
                    //isGram: productData['isGram'],
                    productDescription: productData['productDescription'],
                    createdAt: productData['createdAt'],
                    updatedAt: productData['updatedAt'],
                    productQuantity: productData['productQuantity'],
                    productTotalPrice: double.parse(
                        productData['productTotalPrice'].toString()),
                    //isGramProduct: (data['isGramProduct'] ?? false) as bool,
                   isGram: data['isGram'],




                    
                    
                  );

                  //calculate price
                  productPriceController.fetchProductPrice();
                  return SwipeActionCell(
                    key: ObjectKey(cartModel.productId),
                    trailingActions: [
                      SwipeAction(
                        title: "Delete",
                        forceAlignmentToBoundary: true,
                        performsFirstActionWithFullSwipe: true,
                        onTap: (CompletionHandler handler) async {
                          print('deleted');
                          await FirebaseFirestore.instance
    .collection('cart')
    .doc(user!.uid)
    .collection('cartOrders')
    .doc(productData.id) // ✅ not productId
    .delete();

                          // await FirebaseFirestore.instance
                          //     .collection('cart')
                          //     .doc(user!.uid)
                          //     .collection('cartOrders')
                          //     .doc(cartModel.productId)
                          //     .delete();
                        },
                      )
                    ],
                    child: Card(
                      elevation: 5,
                      color: AppConstant.appTextColor,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppConstant.appMainColor,
                          backgroundImage:
                              NetworkImage(cartModel.productImages[0]),
                        ),
                        title: Text(cartModel.productName),
                      subtitle: Row(
  children: [
    /// LEFT : PRICE
    Text(
      "₹ ${cartModel.productTotalPrice.toString()}",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),

    Spacer(),

    /// RIGHT SIDE : -   quantity   +
    Row(
      children: [
        // MINUS BUTTON
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
    ? price * (newQty ~/ 500)
    : price * newQty,

              });
            }
          },
          child: CircleAvatar(
            radius: 14,
            backgroundColor: AppConstant.appMainColor,
            child: Text("-", style: TextStyle(fontSize: 18)),
          ),
        ),

        SizedBox(width: 10),

        /// ⭐ QUANTITY SHOW (Gram OR Normal)
        Text(
          cartModel.isGram
              ? formatWeight(cartModel.productQuantity) // 📌 500g → 1kg → 1.5kg
              : cartModel.productQuantity.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(width: 10),

        // PLUS BUTTON
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
    ? price * (newQty ~/ 500)
    : price * newQty,

            });
          },
          child: CircleAvatar(
            radius: 14,
            backgroundColor: AppConstant.appMainColor,
            child: Text("+", style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    ),
  ],
),



//                         subtitle: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(cartModel.productTotalPrice.toString()),
//                             SizedBox(
//                               width: Get.width / 20.0,
//                             ),
//                            GestureDetector(
                            
//   onTap: () async {

//     if (cartModel.productQuantity > 1) {
//       double price = cartModel.isSale == true
//           ? double.parse(cartModel.salePrice)
//           : double.parse(cartModel.fullPrice);

//       await FirebaseFirestore.instance
//           .collection('cart')
//           .doc(user!.uid)
//           .collection('cartOrders')
//           .doc(productData.id)
//           .update({
//         'productQuantity': cartModel.productQuantity - 1,
//         'productTotalPrice': price * (cartModel.productQuantity - 1),
//       });
//     }
//   },
//   child: CircleAvatar(
//     radius: 14.0,
//     backgroundColor: AppConstant.appMainColor,
//     child: Text('-'),
//   ),
// ),
// SizedBox(width: Get.width / 20.0),
// GestureDetector(
 
//   onTap: () async {
//     double price = cartModel.isSale == true
//         ? double.parse(cartModel.salePrice)
//         : double.parse(cartModel.fullPrice);

//     await FirebaseFirestore.instance
//         .collection('cart')
//         .doc(user!.uid)
//         .collection('cartOrders')
//         .doc(productData.id)
//         .update({
//       'productQuantity': cartModel.productQuantity + 1,
//       'productTotalPrice': price * (cartModel.productQuantity + 1),
//     });
//   },
//   child: CircleAvatar(
//     radius: 14.0,
//     backgroundColor: AppConstant.appMainColor,
//     child: Text('+'),
//   ),
// ),

//                           ],
//                         ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                " Total ${productPriceController.totalPrice.value.toStringAsFixed(1)} : PKR",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                child: Container(
                  width: Get.width / 2.0,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                    color: AppConstant.appScendoryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: Text(
                      "Checkout",
                      style: TextStyle(color: AppConstant.appTextColor),
                    ),
                    onPressed: () {
                      Get.to(() => CheckOutScreen());
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
String formatWeight(int grams) {
  if (grams < 1000) {
    return "${grams} g";
  } else {
    double kg = grams / 1000;

    // Agar pura 1kg ho (jese 1000g, 2000g)
    if (kg % 1 == 0) {
      return "${kg.toInt()} kg";
    }

    // Agar decimal ho (jese 1500g = 1.5kg)
    return "${kg.toStringAsFixed(1)} kg";
  }
}

// String formatWeight(int grams) {
//   if (grams < 1000) {
//     return "${grams}g";
//   } else {
//     double kg = grams / 1000;
//     return kg % 1 == 0 ? "${kg.toInt()}kg" : "${kg}kg";
//   }
// }
