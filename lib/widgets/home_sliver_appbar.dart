import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:village_bazzar/controllers/product_search_controller.dart';

class HomeSliverAppBar extends StatelessWidget {
  const HomeSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductSearchController searchController =
        Get.find<ProductSearchController>();
        

    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: true, // Drawer visible
      backgroundColor: Colors.white,

      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          // Collapsed detect
          bool isCollapsed = constraints.biggest.height <= kToolbarHeight + MediaQuery.of(context).padding.top;

          return Container(
            color: isCollapsed ? const Color.fromARGB(255, 250, 247, 53) : const Color.fromARGB(255, 248, 104, 68),
            child: Stack(
              children: [
                /// 🔹 Drawer + App Name (Collapsed state)
                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Drawer icon auto handled by AppBar
                      SizedBox(width: 56), // placeholder for drawer spacing
                      /// App Name right
                      Padding(
                        padding: const EdgeInsets.only(top: 16,right: 16),
                        child: Text(
                          "Village Bazzar",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🔹 Search + Categories (Expanded state)
                if (!isCollapsed)
                  Positioned(
                    left: 15,
                    right: 15,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🔍 SEARCH BAR
                        Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              searchController.searchProduct(value);
                            },
                            decoration: const InputDecoration(
                              hintText: "Search products...",
                              border: InputBorder.none,
                              icon: Icon(Icons.search),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        /// 🔲 CATEGORY ROW
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              categoryBox("All"),
                              categoryBox("Grocery"),
                              categoryBox("Fashion"),
                              categoryBox("Gift"),
                              categoryBox("Electronics"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 🔲 CATEGORY BOX
Widget categoryBox(String title) {
  return Container(
    margin: const EdgeInsets.only(right: 10),
    width: 90,
    height: 40,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 4),
      ],
    ),
    child: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w500),
    ),
  );
}
