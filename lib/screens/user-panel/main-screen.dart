import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:village_bazzar/screens/user-panel/all-categories-screen.dart';
import 'package:village_bazzar/screens/user-panel/all-flash-sale-product.dart';
import 'package:village_bazzar/screens/user-panel/all-products-screen.dart';
import 'package:village_bazzar/screens/user-panel/cart-screen.dart';
import 'package:village_bazzar/screens/user-panel/contact.dart';
import 'package:village_bazzar/services/offer_services.dart';
import 'package:village_bazzar/utils/app-constant.dart';
import 'package:village_bazzar/widgets/all-products-widget.dart';
import 'package:village_bazzar/widgets/banner-widget.dart';
import 'package:village_bazzar/widgets/category-widget.dart';
import 'package:village_bazzar/widgets/custom-drawer-widget.dart';
import 'package:village_bazzar/widgets/flash-sale-widget.dart';
import 'package:village_bazzar/widgets/heading-widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> bottomScreens = [
    MainContent(), 
    AllProductsScreen(),
    //CartScreen(),
    ContactScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔥 AppBar only on Home Screen
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: const Color.fromARGB(255, 153, 172, 197),
              title: Text(AppConstant.appMainName),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () => Get.to(() => CartScreen()),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.shopping_cart),
                  ),
                ),
              ],
            )
          : null,

      // 🔥 Drawer only on Home Screen
      drawer: _selectedIndex == 0 ? DrawerWidget() : null,

      // 🔥 Body
      body: bottomScreens[_selectedIndex],

      // 🔥 Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page),
            label: "Contact",
          ),
         
        ],
      ),
    );
  }
}

// 🔥 YOUR OLD BODY CODE HERE (Home Screen Content)


class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: Get.height / 90.0),

          BannerWidget(),
          SizedBox(height: 8.0),

          HeadingWidget(
            headingTitle: "Categories 🛒",
            headingSubtitle: "According to your choise",
            onTap: () => Get.to(() => AllCategoriesScreen()),
            buttonText: "See All",
          ),

          SizedBox(height: 5),
          CategoriesWidget(),

          HeadingWidget(
            headingTitle: "Flash Sale",
            headingSubtitle: "Unbeatable Discounts🎉🎉",
            onTap: () => Get.to(() => AllFlashSaleProductScreen()),
            buttonText: "See All",
          ),

          FlashSaleWidget(),
          SizedBox(height: 10),

          Container(
            padding: EdgeInsets.only(left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Loyalty Card Offer",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 240, 107, 54),
                  ),
                ),
              ],
            ),
          ),

          OfflineLoyaltyOfferWidget(),

          HeadingWidget(
            headingTitle: "All Products",
            headingSubtitle: "Clothes for Every Occasion🛒",
            onTap: () => Get.to(() => AllProductsScreen()),
            buttonText: "See All",
          ),

          AllProductsWidget(),
        ],
      ),
    );
  }
}
