// ignore_for_file: file_names, must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings, unused_local_variable, avoid_print, prefer_const_declarations, deprecated_member_use, sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// Assuming these are external files, keeping the imports
import 'package:village_bazzar/controllers/rating-controller.dart'; 
import 'package:village_bazzar/models/product-model.dart';
import 'package:village_bazzar/models/review-model.dart';
import 'package:village_bazzar/utils/app-constant.dart';
import '../../models/cart-model.dart';
import 'cart-screen.dart';


class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDetailsScreen({super.key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // Controller for product rating calculation
    CalculateProductRatingController calculateProductRatingController = Get.put(
        CalculateProductRatingController(widget.productModel.productId));

    return Scaffold(
      // ----------------- APP BAR -----------------
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor, // Use a consistent main color
        elevation: 0,
        title: Text(
          "Product Details",
          style: TextStyle(
            color: AppConstant.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => CartScreen()),
            icon: Icon(Icons.shopping_cart, color: AppConstant.appTextColor),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            
            // ----------------- PRODUCT IMAGES CAROUSEL -----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CarouselSlider(
                items: widget.productModel.productImages
                    .map(
                      (imageUrls) => Container(
                        // Added padding to the container for shadow to be visible
                        margin: EdgeInsets.all(4.0), 
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: CachedNetworkImage(
                            imageUrl: imageUrls,
                            fit: BoxFit.cover, 
                            width: double.infinity,
                            placeholder: (context, url) => Center(
                              child: CupertinoActivityIndicator(color: AppConstant.appScendoryColor),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.broken_image, size: 50, color: Colors.grey[400]),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  aspectRatio: 1.5, // Improved aspect ratio for better display
                  viewportFraction: 1,
                  enlargeCenterPage: true,
                ),
              ),
            ),

            SizedBox(height: 16),

            // ----------------- PRODUCT DETAILS CARD -----------------
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name & Prices
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.productModel.productName,
                              style: TextStyle(
                                fontSize: 24,
                                color: AppConstant.appMainColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          // Price Display Logic
                          widget.productModel.isSale
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Rs: ${widget.productModel.salePrice}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                    Text(
                                      "Rs: ${widget.productModel.fullPrice}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red.shade400,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  "Rs: ${widget.productModel.fullPrice}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppConstant.appMainColor,
                                  ),
                                ),
                        ],
                      ),
                      
                      SizedBox(height: 8),

                      // Rating Bar
                      Row(
                        children: [
                          Obx(() => RatingBar.builder(
                                glow: false,
                                ignoreGestures: true,
                                initialRating: calculateProductRatingController.averageRating.value,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20,
                                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (value) {},
                              ),
                          ),
                          SizedBox(width: 8),
                          Obx(() => Text(
                                calculateProductRatingController.averageRating.value.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                          ),
                        ],
                      ),
                      
                      Divider(height: 24, thickness: 1),

                      // Category
                      Text(
                        "Category: " + widget.productModel.categoryName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      
                      SizedBox(height: 12),

                      // Product Description
                      Text(
                        "Product Description:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.appMainColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.productModel.productDescription,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),

                      SizedBox(height: 20),

                      // ----------------- ACTION BUTTONS -----------------
                      Row(
                        children: [
                          // WhatsApp Button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                sendMessageOnWhatsApp(
                                  productModel: widget.productModel,
                                );
                              },
                           //   icon: Icon(Icons.whatsapp, color: AppConstant.appTextColor),
                              label: Text(
                                "WhatsApp",
                                style: TextStyle(
                                  color: AppConstant.appTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 4,
                              ),
                            ),
                          ),
                          
                          SizedBox(width: 10.0),

                          // Add to Cart Button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                if (user != null) {
                                  await checkProductExistence(uId: user!.uid);
                                  Get.snackbar(
                                    "Success",
                                    "${widget.productModel.productName} added to cart!",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: AppConstant.appScendoryColor,
                                    colorText: AppConstant.appTextColor,
                                  );
                                } else {
                                  // Handle case where user is not logged in (e.g., show login prompt)
                                  Get.snackbar(
                                    "Login Required",
                                    "Please log in to add items to your cart.",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red.shade400,
                                    colorText: AppConstant.appTextColor,
                                  );
                                }
                              },
                              icon: Icon(Icons.add_shopping_cart, color: AppConstant.appTextColor),
                              label: Text(
                                "Add to Cart",
                                style: TextStyle(
                                  color: AppConstant.appTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstant.appScendoryColor,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // ----------------- REVIEWS SECTION -----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Customer Reviews",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.appMainColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),

            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('products')
                  .doc(widget.productModel.productId)
                  .collection('reviews')
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error loading reviews."),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: Get.height / 5,
                    child: Center(
                      child: CupertinoActivityIndicator(color: AppConstant.appScendoryColor),
                    ),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: Text(
                        "No reviews yet. Be the first to review!",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  );
                }

                // UNCOMMENTED and STYLED the reviews list
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(), // Important to disable inner scrolling
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      // Assuming ReviewModel fields match Firestore document fields
                      ReviewModel reviewModel = ReviewModel(
                        customerName: data['customerName'],
                        customerPhone: data['customerPhone'],
                        customerDeviceToken: data['customerDeviceToken'],
                        customerId: data['customerId'],
                        feedback: data['feedback'],
                        rating: data['rating'], // Note: Firestore rating is likely a String or num, will display as is
                        createdAt: data['createdAt'],
                      );
                      
                      // Use a List Card for better look
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppConstant.appScendoryColor.withOpacity(0.1),
                            child: Text(
                              reviewModel.customerName.isNotEmpty 
                                ? reviewModel.customerName[0].toUpperCase() 
                                : '?',
                              style: TextStyle(color: AppConstant.appMainColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            reviewModel.customerName,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            reviewModel.feedback,
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              SizedBox(width: 4),
                              Text(
                                reviewModel.rating.toString(), // Display rating value
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 30), // Extra space at the bottom
          ],
        ),
      ),
    );
  }

  // ----------------- WHATSAPP FUNCTION -----------------
  static Future<void> sendMessageOnWhatsApp({
    required ProductModel productModel,
  }) async {
    final number = "+919334810771";
    final message =
        "Hello Sarfaraj \n i want to know about this product \n ${productModel.productName} \n ${productModel.productId}";

    final url = 'https://wa.me/$number?text=${Uri.encodeComponent(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // In a real app, you would use Get.snackbar here, not throw
      print('Could not launch $url'); 
      Get.snackbar(
        "Error",
        "Could not launch WhatsApp link.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: AppConstant.appTextColor,
      );
    }
  }

  // ----------------- ADD TO CART LOGIC -----------------
  Future<void> checkProductExistence({
    required String uId,
    int quantityIncrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    double price = double.parse(
      widget.productModel.isSale
          ? widget.productModel.salePrice
          : widget.productModel.fullPrice,
    );

    /// -------------------------------------------
    /// 1) PRODUCT ALREADY EXISTS (UPDATE)
    /// -------------------------------------------
    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];

      // Note: Assuming 'isGram' logic is correct: 500g increments if true, 1 unit if false.
      int updatedQuantity = widget.productModel.isGram
          ? currentQuantity + 500
          : currentQuantity + 1;

      // Calculate total price based on the logic: price is per unit/gram, so multiply by ratio
      double totalPrice = widget.productModel.isGram
          ? price * (updatedQuantity / 500)
          : price * updatedQuantity;


      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice,
      });

      print("product quantity updated in cart");
    }

    /// -------------------------------------------
    /// 2) PRODUCT NOT IN CART (ADD NEW)
    /// -------------------------------------------
    else {
      // Ensure the main cart document for the user exists
      await FirebaseFirestore.instance.collection('cart').doc(uId).set({
        'uId': uId,
        'createdAt': DateTime.now(),
      }, SetOptions(merge: true));

      int quantity = widget.productModel.isGram ? 500 : 1;

      double totalPrice = widget.productModel.isGram
          ? price * (quantity / 500) 
          : price * quantity;

      CartModel cartModel = CartModel(
        productId: widget.productModel.productId,
        categoryId: widget.productModel.categoryId,
        productName: widget.productModel.productName,
        categoryName: widget.productModel.categoryName,
        salePrice: widget.productModel.salePrice,
        fullPrice: widget.productModel.fullPrice,
        productImages: widget.productModel.productImages,
        deliveryTime: widget.productModel.deliveryTime,
        isSale: widget.productModel.isSale,
        isGram: widget.productModel.isGram,
        productDescription: widget.productModel.productDescription,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuantity: quantity,
        productTotalPrice: totalPrice,
      );

      await documentReference.set(cartModel.toMap());

      print("product added to cart");
    }
  }
}