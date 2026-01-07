import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:village_bazzar/utils/app-constant.dart';

class AddProductScreen extends StatefulWidget {
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();

  bool isSale = false;
  bool isGram = false;

  List<File> images = [];
  final picker = ImagePicker();

  Future pickImages() async {
    final pickedImages = await picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        images = pickedImages.map((e) => File(e.path)).toList();
      });
    }
  }

  Future<List<String>> uploadImages() async {
    List<String> urls = [];

    for (var img in images) {
      String name = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child("productImages").child(name);

      await ref.putFile(img);
      String url = await ref.getDownloadURL();
      urls.add(url);
    }

    return urls;
  }

  saveProduct() async {
    if (nameController.text.isEmpty ||
        categoryController.text.isEmpty ||
        fullPriceController.text.isEmpty ||
        images.isEmpty ||
        descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    List<String> uploadedImages = await uploadImages();

    await FirebaseFirestore.instance.collection("products").add({
      "productName": nameController.text.trim(),
      "categoryName": categoryController.text.trim(),
      "fullPrice": fullPriceController.text.trim(),
      "salePrice": salePriceController.text.trim(),
      "productDescription": descriptionController.text.trim(),
      "deliveryTime": deliveryTimeController.text.trim(),
      "productImages": uploadedImages,
      "isSale": isSale,
      "isGram": isGram,
      "createdAt": DateTime.now(),
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Product Added Successfully")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        elevation: 0,
        title: Text("Add Product", style: TextStyle(color: Colors.white)),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            /// IMAGE PICKER BOX
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: images.isEmpty
                  ? InkWell(
                      onTap: pickImages,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate,
                                size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Tap to add product images",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            images[i],
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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
            buildField("Product Description", descriptionController, maxLines: 3),

            SizedBox(height: 10),

            /// switches
            SwitchListTile(
              title: Text("Is On Sale?"),
              activeColor: AppConstant.appMainColor,
              value: isSale,
              onChanged: (val) => setState(() => isSale = val),
            ),

            SwitchListTile(
              title: Text("Is Weight-Based Item? (Gram/kg)"),
              activeColor: AppConstant.appMainColor,
              value: isGram,
              onChanged: (val) => setState(() => isGram = val),
            ),

            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.appMainColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  "Add Product",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildField(
    String label,
    TextEditingController c, {
    TextInputType? type,
    int maxLines = 1,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
        keyboardType: type,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
