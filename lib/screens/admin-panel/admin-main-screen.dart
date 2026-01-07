import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();

  TextEditingController imageUrlController = TextEditingController();
  List<String> imageUrls = [];

  bool isSale = false;
  bool isGram = false;

  // =====================================================================
  // READABLE DATE FORMAT (LIKE YOUR CATEGORIES COLLECTION)
  // =====================================================================
  String formatReadableDate(DateTime date) {
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    String month = months[date.month - 1];
    String hour = date.hour > 12 ? "${date.hour - 12}" : "${date.hour}";
    String ampm = date.hour >= 12 ? "PM" : "AM";

    return "$month,${date.day},${date.year}, at "
        "$hour:${date.minute.toString().padLeft(2, '0')}:${date.second}$ampm UTC+5";
  }

  // =====================================================================
  // GET CATEGORY ID FROM CATEGORY NAME (Document ID)
  // =====================================================================
  Future<String?> getCategoryIdByName(String name) async {
    final snap = await FirebaseFirestore.instance
        .collection("categories")
        .where("categoryName", isEqualTo: name)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) {
      print("CATEGORY NOT FOUND");
      return null;
    }

    return snap.docs.first.id; // ⭐ Document ID = categoryId
  }

  // =====================================================================
  // SAVE PRODUCT (with auto productId + categoryId + timestamps)
  // =====================================================================
  saveProduct() async {
    if (nameController.text.isEmpty ||
        categoryController.text.isEmpty ||
        fullPriceController.text.isEmpty ||
        imageUrls.isEmpty ||
        descriptionController.text.isEmpty) {
      print("VALIDATION FAILED");
      return;
    }

    try {
      // 1️⃣ CategoryId from Category Name
      String? catId =
          await getCategoryIdByName(categoryController.text.trim());

      if (catId == null) {
        print("CATEGORY ID NOT FOUND — CANNOT SAVE PRODUCT");
        return;
      }

      String now = formatReadableDate(DateTime.now());

      // 2️⃣ Create product
      DocumentReference ref =
          await FirebaseFirestore.instance.collection("products").add({
        "productName": nameController.text.trim(),
        "categoryName": categoryController.text.trim(),
        "categoryId": catId, // ⭐ Document ID stored here
        "fullPrice": fullPriceController.text.trim(),
        "salePrice": salePriceController.text.trim(),
        "productDescription": descriptionController.text.trim(),
        "deliveryTime": deliveryTimeController.text.trim(),
        "productImages": imageUrls,
        "isSale": isSale,
        "isGram": isGram,
        "createdAt": now,
        "updatedAt": now,
      });

      // 3️⃣ Add productId
      await ref.update({"productId": ref.id});

      print("PRODUCT ADDED WITH ID: ${ref.id}");

      // Clear fields
      setState(() {
        nameController.clear();
        categoryController.clear();
        fullPriceController.clear();
        salePriceController.clear();
        descriptionController.clear();
        deliveryTimeController.clear();
        imageUrls.clear();
        isSale = false;
        isGram = false;
      });

    } catch (e) {
      print("ERROR SAVING PRODUCT = $e");
    }
  }

  // =====================================================================
  // DELETE PRODUCT
  // =====================================================================
  Future deleteProduct(String id) async {
    try {
      await FirebaseFirestore.instance.collection("products").doc(id).delete();
      print("PRODUCT DELETED");
    } catch (e) {
      print("DELETE ERROR = $e");
    }
  }

  // =====================================================================
  // UI
  // =====================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Admin Panel", style: TextStyle(color: Colors.white)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ------------------- PRODUCT INPUT FORM --------------------

            Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE URL INPUT BLOCK
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Add Image URL", style: TextStyle(fontSize: 16)),

                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: imageUrlController,
                                decoration: InputDecoration(
                                  hintText: "Enter image URL...",
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.amber),
                              onPressed: () {
                                if (imageUrlController.text.trim().isNotEmpty) {
                                  setState(() {
                                    imageUrls.add(
                                        imageUrlController.text.trim());
                                  });
                                  imageUrlController.clear();
                                }
                              },
                            ),
                          ],
                        ),

                        if (imageUrls.isNotEmpty)
                          SizedBox(
                            height: 110,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: imageUrls.length,
                              itemBuilder: (_, i) => Padding(
                                padding: EdgeInsets.all(6),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    imageUrls[i],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  buildField("Product Name", nameController),
                  buildField("Category Name", categoryController),
                  buildField("Full Price", fullPriceController,
                      type: TextInputType.number),
                  buildField("Sale Price", salePriceController,
                      type: TextInputType.number),
                  buildField("Delivery Time", deliveryTimeController),
                  buildField("Product Description", descriptionController,
                      maxLines: 3),

                  SwitchListTile(
                    title: Text("Is On Sale?"),
                    value: isSale,
                    activeColor: Colors.amber,
                    onChanged: (v) => setState(() => isSale = v),
                  ),

                  SwitchListTile(
                    title: Text("Is Weight-Based Item?"),
                    value: isGram,
                    onChanged: (v) => setState(() => isGram = v),
                  ),

                  Center(
                    child: ElevatedButton(
                      onPressed: saveProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                      ),
                      child: Text("Add Product",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            Text("All Products",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            // ------------------- PRODUCT LIST --------------------

            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("products").snapshots(),
              builder: (_, snap) {
                if (!snap.hasData) return CircularProgressIndicator();

                var docs = snap.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    var p = docs[i].data();

                    return Card(
                      child: ListTile(
                        leading: (p["productImages"] != null &&
                                p["productImages"] is List &&
                                p["productImages"].isNotEmpty)
                            ? Image.network(
                                p["productImages"][0],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image_not_supported, size: 40),

                        title: Text(p["productName"]),
                        subtitle: Text("₹${p["fullPrice"]}"),

                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteProduct(docs[i].id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField(
      String label, TextEditingController controller,
      {TextInputType? type, int maxLines = 1}) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
