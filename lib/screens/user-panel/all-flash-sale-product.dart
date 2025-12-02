// ignore_for_file: file_names, prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/product-model.dart';
import '../user-panel/product-details-screen.dart';

class AllFlashSaleProductScreen extends StatefulWidget {
  const AllFlashSaleProductScreen({super.key});

  @override
  State<AllFlashSaleProductScreen> createState() =>
      _AllFlashSaleProductScreenState();
}

class _AllFlashSaleProductScreenState extends State<AllFlashSaleProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 153, 172, 197),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 153, 172, 197),
        title: Text("All Flash Sale Products"),
        centerTitle: true,
      ),

      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: true)
            .get(),

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasError) {
            return Center(child: Text("Error fetching flash sale products"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No Flash Sale Products Found!"));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
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
                padding: EdgeInsets.all(12),
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),

                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index];

                  ProductModel model = ProductModel(
                    productId: data['productId'],
                    categoryId: data['categoryId'],
                    productName: data['productName'],
                    categoryName: data['categoryName'],
                    salePrice: data['salePrice'],
                    fullPrice: data['fullPrice'],
                    productImages: data['productImages'],
                    deliveryTime: data['deliveryTime'],
                    isSale: data['isSale'],
                    productDescription: data['productDescription'],
                    createdAt: data['createdAt'],
                    updatedAt: data['updatedAt'],
                    isGram: data['isGram'],
                  );

                  // Convert to int (avoid error)
                  int fullPrice = int.parse(model.fullPrice.toString());
                  int salePrice = int.parse(model.salePrice.toString());
                  int discount = (((fullPrice - salePrice) / fullPrice) * 100).toInt();

                  return GestureDetector(
                    onTap: () => Get.to(() => ProductDetailsScreen(productModel: model)),

                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [

                            /// IMAGE
                            Positioned.fill(
                              child: CachedNetworkImage(
                                imageUrl: model.productImages[0],
                                fit: BoxFit.cover,
                              ),
                            ),

                            /// SALE BADGE (LEFT TOP)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "-$discount%",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),

                            /// FLASH SALE TAG (RIGHT TOP)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.orange, Colors.red],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.local_fire_department,
                                        size: 14, color: Colors.white),
                                    SizedBox(width: 3),
                                    Text(
                                      "FLASH",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            /// BOTTOM OVERLAY DETAILS
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                color: const Color.fromARGB(255, 21, 21, 34).withOpacity(0.85),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    Text(
                                      model.productName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),

                                    SizedBox(height: 4),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Rs $salePrice",
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Rs $fullPrice",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
          );
        },
      ),
    );
  }
}
