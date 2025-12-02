import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../user-panel/single-category-product-screen.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3f3f3),

      appBar: AppBar(
        backgroundColor: Color(0xfff3f3f3),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "All Categories",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(),

        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          
          if (snapshot.hasError) {
            return Center(child: Text("Error loading categories"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No categories found"));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              int crossCount;

              if (width < 600) {
                crossCount = 3;     // Meesho grid
              } else if (width < 900) {
                crossCount = 4;
              } else {
                crossCount = 5;
              }

              return GridView.builder(
                itemCount: snapshot.data!.docs.length,
                padding: EdgeInsets.all(12),
                physics: BouncingScrollPhysics(),

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),

                itemBuilder: (context, index) {
                  final category = snapshot.data!.docs[index];

                  return GestureDetector(
                    onTap: () => Get.to(
                      () => AllSingleCategoryProductsScreen(
                        categoryId: category['categoryId'],
                      ),
                    ),

                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [

                          /// IMAGE TOP (70%)
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: category['categoryImg'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  placeholder: (c, u) => Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                  errorWidget: (c, u, e) =>
                                      Icon(Icons.error, color: Colors.red),
                                ),
                              ),
                            ),
                          ),

                          /// CATEGORY NAME (BOTTOM)
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  category['categoryName'],
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
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
        },
      ),
    );
  }
}
