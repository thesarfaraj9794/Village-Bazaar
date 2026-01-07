import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:village_bazzar/models/product-model.dart';
import 'package:village_bazzar/screens/user-panel/product-details-screen.dart';

class AllProductsWidget extends StatelessWidget {
  const AllProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Define UI constants
    final Color cardBackgroundColor = Colors.white;
    final Color primaryTextColor = Color.fromARGB(255, 26, 35, 43);

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('products')
          .where('isSale', isEqualTo: false) // Fetching non-sale products
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("❌ Error loading products."),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: Get.height / 7,
            child: Center(
              child: CupertinoActivityIndicator(radius: 15.0),
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "🔎 No general products found!",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          );
        }

        if (snapshot.data != null) {
    
          return LayoutBuilder(
            builder: (context, constraints) {
              
            
              final double screenWidth = constraints.maxWidth;
              int crossAxisCount;

              if (screenWidth < 600) {
                
                crossAxisCount = 2;
              } else if (screenWidth < 900) {
          
                crossAxisCount = 3; 
              } else {
                
                crossAxisCount = 4;
              }

              return GridView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(), 
                padding: EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount, // Dynamic Cross Axis Count
                  mainAxisSpacing: 16, 
                  crossAxisSpacing: 16, 
                  childAspectRatio: 0.75, // Aspect ratio for card size
                ),
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index];

                  // Map Firestore data to ProductModel
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
                    onTap: () => Get.to(
                      () => ProductDetailsScreen(productModel: productModel),
                    ),
                    child: Card(
                      elevation: 5, // Lifted look
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), 
                      ),
                      clipBehavior: Clip.antiAlias, 
                      color: cardBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // --- IMAGE SECTION ---
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: productModel.productImages[0],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(child: Icon(Icons.image, color: Colors.grey.shade300, size: 50)),
                              errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: Colors.red)),
                            ),
                          ),
                          
                          // --- DETAILS SECTION ---
                          Container(
                            padding: EdgeInsets.fromLTRB(8, 10, 8, 8), 
                            color: cardBackgroundColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Name
                                Text(
                                  productModel.productName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: primaryTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 6),

                                // Product Price and Icon
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Rs ${productModel.fullPrice}",
                                      style: TextStyle(
                                        color: Colors.green.shade700, 
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900, 
                                      ),
                                    ),
                                    // Subtle favorite icon
                                    Icon(
                                      Icons.favorite_border,
                                    
                                      color: const Color.fromARGB(255, 139, 134, 134),
                                      size: 20,
                                    ),
                                  ],
                                ),
                                
                                
                                 Text(
                                  productModel.categoryName,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
          // **RESPONSIVE LAYOUT ENDS**
        }

        return Container();
      },
    );
  }
}