// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:village_bazzar/models/product-model.dart';
import 'package:village_bazzar/screens/user-panel/product-details-screen.dart';


class FlashSaleWidget extends StatelessWidget {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('products')
          .where('isSale', isEqualTo: true)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"), // बेहतर एरर मैसेज
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: Get.height / 4, // थोड़ी कम हाइट ताकि लोडिंग दिखे
            child: Center(
              child: CupertinoActivityIndicator(color: Colors.blueGrey), // अट्रैक्टिव लोडर कलर
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No flash sale products available at the moment!"),
          );
        }

        // यदि डेटा है, तो यह ब्लॉक चलेगा
        return Container(
          height: Get.height / 2.9, // इमेज के साइज़ के अनुसार एडजस्ट करें
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
              ProductModel productModel = ProductModel(
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
              );

              return GestureDetector(
                onTap: () => Get.to(
                  () => ProductDetailsScreen(productModel: productModel),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0), // पैडिंग बढ़ाई गई
                  child: Container(
                    width: Get.width / 2.8, // कार्ड की चौड़ाई थोड़ी बढ़ाई गई
                    decoration: BoxDecoration(
                      color: Colors.white, // कार्ड का बैकग्राउंड सफ़ेद
                      borderRadius: BorderRadius.circular(15), // गोल कोने
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3), // हल्का, लेकिन स्पष्ट शैडो
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 4), // शैडो को नीचे की तरफ खिसकाया गया
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15), // कंटेनर के कोनों को भी गोल करें
                      child: Stack(
                        children: [
                          /// IMAGE (ऊपर का हिस्सा)
                          CachedNetworkImage(
                            imageUrl: productModel.productImages[0],
                            width: double.infinity,
                            height: Get.height / 4.5, // इमेज की ऊँचाई एडजस्ट की गई
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),

                          /// SALE BADGE (ऊपर-बाएँ कोने पर)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.redAccent, // सेल के लिए आकर्षक लाल रंग
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'SALE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),

                          /// TEXT + PRICE overlay (नीचे का हिस्सा)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6), // पैडिंग बढ़ाई गई
                              color: Colors.blueGrey.shade700, // डार्क बैकग्राउंड कलर
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start, // टेक्स्ट को बाईं ओर अलाइन करें
                                children: [
                                  Text(
                                    productModel.productName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1, // एक लाइन में नाम
                                    style: TextStyle(
                                      color: Colors.white, // सफ़ेद टेक्स्ट
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14, // फॉन्ट साइज़ बढ़ाया
                                    ),
                                  ),
                                  SizedBox(height: 4), // स्पेसिंग बढ़ाई
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // कीमत और पुरानी कीमत के बीच स्पेस
                                    children: [
                                      Text(
                                        "Rs ${productModel.salePrice}",
                                        style: TextStyle(
                                          color: Colors.amber, // हाइलाइटेड सेल प्राइस
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        "Rs ${productModel.fullPrice}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70, // पुरानी कीमत के लिए हल्का सफ़ेद रंग
                                          fontWeight: FontWeight.w500,
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}