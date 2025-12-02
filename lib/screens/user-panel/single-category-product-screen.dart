import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:village_bazzar/models/product-model.dart';
import 'package:village_bazzar/screens/user-panel/product-details-screen.dart';

// Assuming AppConstant is available and defines appMainColor
// For this standalone file, I'll define a temporary main color
const Color _appMainColor = Color(0xFFE26127); // Example Orange color

class AllSingleCategoryProductsScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName; // Added to display in AppBar

  const AllSingleCategoryProductsScreen({
    super.key,
    required this.categoryId,
    this.categoryName = 'Products', // Default value
  });

  @override
  State<AllSingleCategoryProductsScreen> createState() =>
      _AllSingleCategoryProductsScreenState();
}

class _AllSingleCategoryProductsScreenState
    extends State<AllSingleCategoryProductsScreen> {
  /// Responsive cross axis count
  int getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width < 600) return 2; // Mobile
    if (width < 900) return 3; // Small Tablet
    return 4; // Large Tablet / Desktop
  }

  @override
  Widget build(BuildContext context) {
    // Defined a light background color for the screen
    final Color screenBackgroundColor = Colors.grey.shade100;

    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: screenBackgroundColor,
        elevation: 0,
        title: Text(
          widget.categoryName,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('categoryId', isEqualTo: widget.categoryId)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator(radius: 15));
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text("Error loading products. Please try again."));
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text("No products found in ${widget.categoryName}."));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: getCrossAxisCount(context),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.70, // Aspect ratio for card size
            ),
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs[index];

              ProductModel productModel = ProductModel(
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
              );

              return GestureDetector(
                onTap: () {
                  Get.to(() =>
                      ProductDetailsScreen(productModel: productModel));
                },
                child: ProductCard(productModel: productModel),
              );
            },
          );
        },
      ),
    );
  }
}

/// -------------------------------------
/// Refactored Product Card Widget
/// -------------------------------------

class ProductCard extends StatelessWidget {
  final ProductModel productModel;

  const ProductCard({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    // Determine if the product is on sale
    bool isOnSale = productModel.isSale == true &&
        productModel.salePrice != productModel.fullPrice;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias, // Ensures image respects border radius
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- 1. IMAGE SECTION ---
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: productModel.productImages[0],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                      child: Icon(Icons.image,
                          color: Colors.grey.shade300, size: 50)),
                  errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error, color: Colors.red)),
                ),

                // Sale Tag (Top Left)
                if (isOnSale)
                  Positioned(
                    top: 10,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'SALE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // --- 2. DETAILS SECTION ---
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product Name
                  Text(
                    productModel.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 26, 35, 43),
                    ),
                  ),

                  // Pricing Details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Price (Strikethrough if on sale)
                      if (isOnSale)
                        Text(
                          "₹${productModel.fullPrice}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        
                      // Current Price (Sale Price or Full Price)
                      Text(
                        "₹${isOnSale ? productModel.salePrice : productModel.fullPrice}${productModel.isGram ? '/gm' : ''}",
                        style: TextStyle(
                          color: isOnSale ? Colors.red.shade700 : Colors.green.shade700,
                          fontSize: isOnSale ? 16 : 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  
                  // Add to Cart Button (Placeholder)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _appMainColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: _appMainColor.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}