import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:village_bazzar/models/product-model.dart';
import 'package:village_bazzar/screens/user-panel/product-details-screen.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color cardBackgroundColor = Colors.white;
    final Color primaryTextColor = const Color.fromARGB(255, 26, 35, 43);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 153, 172, 197),
      appBar: AppBar(
        title: const Text("All Product"),
        backgroundColor: const Color.fromARGB(255, 153, 172, 197),
        centerTitle: true,
      ),

      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: false)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("❌ Error loading products."));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: Get.height / 7,
              child: const Center(child: CupertinoActivityIndicator()),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "🔎 No general products found!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
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
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
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
                      onTap: () => Get.to(
                        () => ProductDetailsScreen(productModel: productModel),
                      ),

                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        clipBehavior: Clip.antiAlias,
                        color: cardBackgroundColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: CachedNetworkImage(
                                imageUrl: productModel.productImages[0],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: Icon(Icons.image,
                                      color: Colors.grey.shade300, size: 50),
                                ),
                                errorWidget: (context, url, error) => const Center(
                                  child: Icon(Icons.error, color: Colors.red),
                                ),
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                              color: cardBackgroundColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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

                                  const SizedBox(height: 6),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Rs ${productModel.fullPrice}",
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),

                                      const Icon(
                                        Icons.favorite_border,
                                        color: Color.fromARGB(255, 139, 134, 134),
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
          }

          return Container();
        },
      ),
    );
  }
}
