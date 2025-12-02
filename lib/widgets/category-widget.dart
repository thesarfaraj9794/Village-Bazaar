import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:village_bazzar/models/category-model.dart';
import 'package:village_bazzar/screens/user-panel/single-category-product-screen.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('categories').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading categories'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: Get.width / 2.5,
            child: const Center(child: CupertinoActivityIndicator()),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No categories available'));
        }

        List<CategoriesModel> categories = snapshot.data!.docs.map((doc) {
          return CategoriesModel(
            categoryId: doc['categoryId'],
            categoryImg: doc['categoryImg'],
            categoryName: doc['categoryName'],
            createdAt: doc['createdAt'],
            updatedAt: doc['updatedAt'],
          );
        }).toList();

        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isLargeScreen = constraints.maxWidth > 600.0;

            // --- बड़ी स्क्रीन के लिए कॉन्फ़िगरेशन (Horizontal ListView) ---
            if (isLargeScreen) {
              // 1. Container Height को छोटा करें और एक निश्चित मान दें
              // 150.0 से 180.0 एक सिंगल रो के लिए अक्सर पर्याप्त होता है
              const double largeScreenHeight = 160.0; 
              
              // 2. आइटम की चौड़ाई को फिक्स करें
              const double largeItemWidth = 100.0; 

              return Container(
                height: largeScreenHeight, // फिक्स्ड हाइट
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    CategoriesModel category = categories[index];
                    
                    // आइटम विजेट को फिक्स्ड चौड़ाई के साथ कॉल करें
                    return _CategoryItem(
                      category: category, 
                      // बड़ी स्क्रीन पर आइटम की चौड़ाई फिक्स रखें
                      itemWidth: largeItemWidth, 
                      // आइकन का साइज़ Container की height के हिसाब से सेट करें
                      iconSizeFactor: largeScreenHeight * 0.55, 
                    ); 
                  },
                ),
              );
            } 
            
            // --- छोटी स्क्रीन के लिए कॉन्फ़िगरेशन (2-row horizontal GridView) ---
            else {
              return Container(
                height: Get.width / 2.5 + 20, 
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 rows
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.15,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    CategoriesModel category = categories[index];
                    // छोटी स्क्रीन के लिए साइज़
                    return _CategoryItem(
                      category: category, 
                      itemWidth: Get.width / 7, 
                      iconSizeFactor: Get.width / 7,
                    );
                  },
                ),
              );
            }
          },
        );
      },
    );
  }
}


// **आइटम विजेट को अपडेट किया गया**
class _CategoryItem extends StatelessWidget {
  final CategoriesModel category;
  final double itemWidth;
  final double iconSizeFactor; // आइकन/कंटेनर साइज़ के लिए एक नया फैक्टर

  const _CategoryItem({
    required this.category,
    required this.itemWidth,
    required this.iconSizeFactor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => AllSingleCategoryProductsScreen(
          categoryId: category.categoryId,
        ),
      ),
      child: Container(
        // ListView.builder के अंदर चौड़ाई फिक्स करें
        width: itemWidth * 1.5, 
        child: Column(
          // Column को लंबवत रूप से फिट होने के लिए Stretched करें
          mainAxisAlignment: MainAxisAlignment.start,
          // **ओवरफ़्लो को रोकने के लिए आइटम को टॉप में अलाइन करें**
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            // Icon/Image container
            Container(
              // साइज़ itemWidth के बजाय iconSizeFactor पर निर्भर करेगा
              width: iconSizeFactor, 
              height: iconSizeFactor, 
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 246, 236), 
                borderRadius: BorderRadius.circular(15), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CachedNetworkImage(
                    imageUrl: category.categoryImg,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6), 
            // Category Name
            Text(
              category.categoryName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}