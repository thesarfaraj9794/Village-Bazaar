import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import 'package:village_bazzar/controllers/get-customer-device-token-controller.dart';
import 'package:village_bazzar/models/cart-model.dart';
import 'package:village_bazzar/services/payment_service.dart';
import 'package:village_bazzar/services/place-order-service.dart';
import 'package:village_bazzar/utils/app-constant.dart';

import '../../controllers/cart-price-controller.dart';


class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreen();
}

class _CheckOutScreen extends State<CheckOutScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());

      TextEditingController nameController = TextEditingController();
      TextEditingController phoneController = TextEditingController();
      TextEditingController addressController = TextEditingController();
      //TextEditingController nameController = TextEditingController();
      String? customerToken;
       String? name;
        String? phone;
         String? address;

         
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('Check out Screen'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No products found!"),
            );
          }

          if (snapshot.data != null) {
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  CartModel cartModel = CartModel(
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
                    productQuantity: productData['productQuantity'],
                    productTotalPrice: double.parse(
                        productData['productTotalPrice'].toString()),
                  /// isGramProduct: productData['isGramProduct']
                  );

                  //calculate price
                  productPriceController.fetchProductPrice();
                  return SwipeActionCell(
                    key: ObjectKey(cartModel.productId),
                    trailingActions: [
                      SwipeAction(
                        title: "Delete",
                        forceAlignmentToBoundary: true,
                        performsFirstActionWithFullSwipe: true,
                        onTap: (CompletionHandler handler) async {
                          print('deleted');
                          await FirebaseFirestore.instance
    .collection('cart')
    .doc(user!.uid)
    .collection('cartOrders')
    .doc(productData.id) // ✅ not productId
    .delete();

                          // await FirebaseFirestore.instance
                          //     .collection('cart')
                          //     .doc(user!.uid)
                          //     .collection('cartOrders')
                          //     .doc(cartModel.productId)
                          //     .delete();
                        },
                      )
                    ],
                    child: Card(
                      elevation: 5,
                      color: AppConstant.appTextColor,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppConstant.appMainColor,
                          backgroundImage:
                              NetworkImage(cartModel.productImages[0]),
                        ),
                        title: Text(cartModel.productName),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(cartModel.productTotalPrice.toString()),
                           
                            
                            SizedBox(
                              width: Get.width / 20.0,
                            ),
                          
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                " Total ${productPriceController.totalPrice.value.toStringAsFixed(1)} : PKR",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                child: Container(
                  width: Get.width / 2.0,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                    color: AppConstant.appScendoryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: Text(
                      "Conform order ",
                      style: TextStyle(color: AppConstant.appTextColor),
                    ),
                    onPressed: () {
                      showCustomBottomSheet();
                     // Get.to(() => CheckOutScreen());
                    // Get.to(()=> PaymentPage());
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showCustomBottomSheet(){
  Get.bottomSheet(
    Container(
      height: Get.height*0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),

        )
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
              child: Container(
                height: 55.0,
                child: TextFormField(
                  controller: nameController,
                   textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Name",
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
              
                    ),
                    hintStyle: TextStyle(
                      
                    )
                  ),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
              child: Container(
                height: 55.0,
                child: TextFormField(
                  controller: addressController,
                  
                   textInputAction: TextInputAction.next,
                  
                  decoration: InputDecoration(
                    labelText: "Address",
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
              
                    ),
                    hintStyle: TextStyle(
                      
                    )
                  ),
                ),
              ),
            ),
            
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
              child: Container(
                height: 55.0,
                child: TextFormField(
                  controller: phoneController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
              
                    ),
                    hintStyle: TextStyle(
                      
                    )
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.appMainColor,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10)
              ),
              onPressed: ()async{
                //Get.to(()=>PaymentPage());

                
              

              

                 if(nameController.text!='' && phoneController.text!='' && addressController.text!=''){

                  String name = nameController.text.trim();
                  String phone = phoneController.text.trim();
                  String address=addressController.text.trim();

                  String customerToken =await getCustomerDeviceToken();
                  

                  //place order service
                  placeOrder(context: context,
                   customerName: name,
                   customerPhone: phone,
                   customerAddress: address,
                   customerDeviceToken: customerToken
                   );
                   

                }else{
                  print("order successfull");
                }


              },
               child: Text("Place order",style: TextStyle(color: Colors.white),))
          ],
        ),
      ),

    ),
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: true,
    elevation: 5

  );

}
}
