import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:js' as js;
import 'dart:io' show Platform;

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Razorpay? _razorpay;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _razorpay = Razorpay();
      _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) _razorpay?.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Success: ${response.paymentId}");
    // backend validation & order confirmation
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  void openCheckout({required int amount}) {
    if (kIsWeb) {
      // Web payment using JS
      js.context.callMethod('eval', ["""
        var options = {
          "key": "rzp_test_1DPmmOlF5G5ag",
          "amount": ${amount * 100}, // in paise
          "currency": "INR",
          "name": "Your Company vill Bazaar",
          "description": "Test Payment",
          "handler": function(response){
            console.log("Payment ID: " + response.razorpay_payment_id);
            alert("Payment Successful! ID: " + response.razorpay_payment_id);
          },
          "prefill": {
            "name": "Test User",
            "email": "test@example.com",
            "contact": "9999999999"
          },
          "theme": {
            "color": "#F37254"
          }
        };
        var rzp1 = new Razorpay(options);
        rzp1.open();
      """]);
    } else {
      // Mobile payment using Razorpay SDK
      var options = {
        'key': 'YOUR_RAZORPAY_KEY',
        'amount': amount * 100, // in paise
        'name': 'Your Company vill bazaar',
        'description': 'Test Payment',
        'prefill': {
          'contact': '9999999999',
          'email': 'test@example.com'
        }
      };
      _razorpay!.open(options);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => openCheckout(amount: 100), // ₹100
          child: Text("Pay Now"),
        ),
      ),
    );
  }
}
