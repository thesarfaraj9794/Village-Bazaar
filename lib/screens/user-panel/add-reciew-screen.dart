import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:village_bazzar/models/order-model.dart';
import 'package:village_bazzar/models/review-model.dart';
import 'package:village_bazzar/utils/app-constant.dart';

class AddReviewScreen extends StatefulWidget {
 final OrderModel orderModel;
  const AddReviewScreen({super.key, required this. orderModel});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  TextEditingController feedbackController = TextEditingController();
  double productRating = 0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Review"),
        centerTitle: true,
        backgroundColor: AppConstant.appMainColor,
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Add your Rating  and Review"),
            SizedBox(height: 20.0,),
            RatingBar.builder(
   initialRating: 0,
   minRating: 1,
   direction: Axis.horizontal,
   allowHalfRating: true,
   itemCount: 5,
   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
   itemBuilder: (context, _) => Icon(
     Icons.star,
     color: Colors.amber,
   ),
   
   onRatingUpdate: (rating) {
     
     productRating = rating;
     print(productRating);
     setState(() {
       
     });
   },
),
SizedBox(height: 20.0,),
Text("FeedBack"),
SizedBox(height: 20.0,),
TextField(
  controller: feedbackController,
  decoration: InputDecoration(label: Text("Share your Feedback")),
),
SizedBox(height: 20.0,),
ElevatedButton(onPressed: ()async{
  EasyLoading.show(status: "please wait");
  String feedback = feedbackController.text.trim();//isse white space nahi aayega 
  User?user = FirebaseAuth.instance.currentUser;
 // print(feedback);
 //print(productRating);
              ReviewModel reviewModel = ReviewModel(
                    customerName: widget.orderModel.customerName,
                    customerPhone: widget.orderModel.customerPhone,
                    customerDeviceToken: widget.orderModel.customerDeviceToken,
                    customerId: widget.orderModel.customerId,
                    feedback: feedback,
                    rating: productRating.toString(),
                    createdAt: DateTime.now(),
                  );

       await   FirebaseFirestore.instance
          .collection('products')
          .doc(widget.orderModel.productId)
          .collection('reviews')
          .doc(user!.uid)
          .set(reviewModel.toMap());

EasyLoading.dismiss();





}, child: Text("Done"))
            
          ],
        ),
      ),
    );
  }
}