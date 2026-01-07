import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:village_bazzar/models/product-model.dart';

class ProductSearchController extends GetxController {
  var allProducts = <ProductModel>[].obs;
  var flashSaleProducts = <ProductModel>[].obs;
  var filteredProducts = <ProductModel>[].obs;
  var searchQuery = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      /// 🔹 ALL PRODUCTS
      final allSnap = await FirebaseFirestore.instance
          .collection('products')
          .where('isSale', isEqualTo: false)
          .get();

      allProducts.value = allSnap.docs
    .map<ProductModel>(
      (doc) => ProductModel.fromFirebase(
        doc as QueryDocumentSnapshot<Map<String, dynamic>>,
      ),
    )
    .toList();

      /// 🔹 FLASH SALE PRODUCTS
      final flashSnap = await FirebaseFirestore.instance
          .collection('products')
          .where('isSale', isEqualTo: true)
          .get();

     flashSaleProducts.value = flashSnap.docs
    .map<ProductModel>(
      (doc) => ProductModel.fromFirebase(
        doc as QueryDocumentSnapshot<Map<String, dynamic>>,
      ),
    )
    .toList();


      /// 🔹 COMBINED LIST
      filteredProducts.value = [
        ...allProducts,
        ...flashSaleProducts,
      ];

      /// ✅ VERY IMPORTANT
      if (searchQuery.value.isNotEmpty) {
        searchProduct(searchQuery.value);
      }
    } catch (e) {
      print("❌ Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔍 SEARCH (REUSE ALL + FLASH)
  void searchProduct(String query) {
    searchQuery.value = query;

    final all = [...allProducts, ...flashSaleProducts];

    if (query.trim().isEmpty) {
      filteredProducts.value = all;
    } else {
      filteredProducts.value = all
          .where((p) =>
              p.productName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
