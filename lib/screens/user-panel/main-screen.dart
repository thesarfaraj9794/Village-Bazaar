import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:village_bazzar/controllers/product_search_controller.dart';
import 'package:village_bazzar/screens/user-panel/account_screen.dart';
import 'package:village_bazzar/screens/user-panel/all-categories-screen.dart';
import 'package:village_bazzar/screens/user-panel/all-flash-sale-product.dart';
import 'package:village_bazzar/screens/user-panel/all-products-screen.dart';
import 'package:village_bazzar/screens/user-panel/cart-screen.dart';
import 'package:village_bazzar/services/offer_services.dart';
import 'package:village_bazzar/widgets/all-products-widget.dart';
import 'package:village_bazzar/widgets/banner-widget.dart';
import 'package:village_bazzar/widgets/category-widget.dart';
import 'package:village_bazzar/widgets/flash-sale-widget.dart';
import 'package:village_bazzar/widgets/heading-widget.dart';
import 'package:village_bazzar/widgets/custom-drawer-widget.dart';
import 'package:village_bazzar/widgets/home_sliver_appbar.dart';
import 'package:village_bazzar/screens/user-panel/product-details-screen.dart';
import 'package:village_bazzar/models/product-model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> bottomScreens = [
    const HomeContent(),
    AllProductsScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _selectedIndex == 0 ? DrawerWidget() : null,
      body: bottomScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onTabTapped,
        selectedItemColor: const Color.fromARGB(255, 103, 159, 233),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Products"),
          BottomNavigationBarItem(icon: Icon(Icons.card_travel), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}

/// 🔥 HOME CONTENT
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    /// ✅ INIT SEARCH CONTROLLER
    final ProductSearchController searchController =
        Get.put(ProductSearchController());

    return CustomScrollView(
      slivers: [
        /// 🔥 SLIVER APPBAR
        const HomeSliverAppBar(),

        /// 🔥 BODY
        SliverToBoxAdapter(
          child: Column(
            children: [
            

              /// 🔍 SEARCH RESULT
             Obx(() {
  if (searchController.searchQuery.trim().isEmpty) {
    return const SizedBox();
  }

  if (searchController.filteredProducts.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text("No product found 😔"),
    );
  }

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(12),
    itemCount: searchController.filteredProducts.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.75,
    ),
    itemBuilder: (context, index) {
      final ProductModel product =
          searchController.filteredProducts[index];

      return GestureDetector(
        onTap: () => Get.to(
          () => ProductDetailsScreen(productModel: product),
        ),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.network(
                  product.productImages[0],
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  product.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}),

              /// 🔥 NORMAL HOME CONTENT
              BannerWidget(),
              const SizedBox(height: 10),

              HeadingWidget(
                headingTitle: "Categories 🛒",
                headingSubtitle: "According to your choice",
                onTap: () => Get.to(() => AllCategoriesScreen()),
                buttonText: "See All",
              ),
              CategoriesWidget(),

              HeadingWidget(
                headingTitle: "Flash Sale",
                headingSubtitle: "Unbeatable Discounts 🎉",
                onTap: () => Get.to(() => AllFlashSaleProductScreen()),
                buttonText: "See All",
              ),
              FlashSaleWidget(),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Loyalty Card Offer",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 240, 107, 54),
                      ),
                    ),
                  ],
                ),
              ),

              OfflineLoyaltyOfferWidget(),

              HeadingWidget(
                headingTitle: "All Products",
                headingSubtitle: "Clothes for Every Occasion",
                onTap: () => Get.to(() => AllProductsScreen()),
                buttonText: "See All",
              ),
              AllProductsWidget(),
            ],
          ),
        ),
      ],
    );
  }
}
