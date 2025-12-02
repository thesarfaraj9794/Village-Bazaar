import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import 'package:village_bazzar/models/order-model.dart';
import 'package:village_bazzar/screens/user-panel/add-reciew-screen.dart';
import 'package:village_bazzar/utils/app-constant.dart';

import '../../controllers/cart-price-controller.dart';

class AllOrderScreen extends StatefulWidget {
  const AllOrderScreen({super.key});

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController = Get.put(
    ProductPriceController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('All order'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(user!.uid)
            .collection('confirmOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
              child: Center(child: CupertinoActivityIndicator()),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No products found!"));
          }

          if (snapshot.data != null) {
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                   final data = productData.data() as Map<String, dynamic>;

// isGram ko default value de do
data['isGram'] = data['isGram'] ?? false;
                  OrderModel orderModel = OrderModel(
                    productId: productData['productId'],
                    categoryId: productData['categoryId'],
                    productName: productData['productName'],
                    categoryName: productData['categoryName'],
                    salePrice: productData['salePrice'],
                    fullPrice: productData['fullPrice'],
                    productImages: productData['productImages'],
                    deliveryTime: productData['deliveryTime'],
                    isSale: productData['isSale'],
                    //isGram: productData['isGram'],
                    productDescription: productData['productDescription'],
                    createdAt: productData['createdAt'],
                    updatedAt: productData['updatedAt'],
                    productQuantity: productData['productQuantity'],
                    productTotalPrice: double.parse(
                      productData['productTotalPrice'].toString(),
                    ),
                    customerId: productData['customerId'],
                    status: productData['status'],
                    customerName: productData['customerName'],
                    customerPhone: productData['customerPhone'],
                    customerAddress: productData['customerAddress'],
                    customerDeviceToken: productData['customerDeviceToken'],
                   isGram: data['isGram'],

                  );

                  //calculate price
                  productPriceController.fetchProductPrice();
                  return Card(
                    elevation: 5,
                    color: AppConstant.appTextColor,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppConstant.appMainColor,
                        backgroundImage: NetworkImage(
                          orderModel.productImages[0],
                        ),
                      ),
                      title: Text(orderModel.productName),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(orderModel.productTotalPrice.toString()),
                          SizedBox(width: 10.0,),
                          orderModel.status != true
                              ? Text("pending..",style: TextStyle(color: Colors.green),)
                              : Text("Delivered",style: TextStyle(color: Colors.red),),
                        ],
                      ),
                      trailing: orderModel.status ==true?
                      ElevatedButton(onPressed: ()=>Get.to(()=>AddReviewScreen(orderModel:orderModel,)),

                       child: Text("Review"),
                      )
                      :SizedBox.shrink(),
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
