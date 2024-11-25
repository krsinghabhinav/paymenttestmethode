import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentController extends GetxController {
  // Controller for amount input
  TextEditingController amountController = TextEditingController();

  // Razorpay instance
  late Razorpay razorpay;

  // Function to initiate Razorpay payment
  void openCheckout(double amount) {
    if (amount <= 0) {
      print("Amount must be greater than zero");
      Get.snackbar(
        "Error",
        "Amount must be greater than zero",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    int paymentAmount = (amount * 100).toInt(); // Convert amount to paise
    var options = {
      'key': 'rzp_test_oEcS0cHDgGmhh4', // Replace with your Razorpay API key
      'amount': paymentAmount, // Amount in paise
      'name': 'Papaya Coders',
      'description': 'Provide service for development',
      'prefill': {
        'contact': '8840591006',
        'email': 'abhinavkkrsingh@gmail.com',
      },
      'method': {
        // Add specific payment methods
        'upi': true, // Enable UPI payments
        'card': false, // Disable card payments
        'wallet': false, // Disable wallets
      },
      'external': {
        'wallets': ['paytm'], // Enable Paytm wallet
      },
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print("Error opening Razorpay: $e");
      Get.snackbar(
        "Error",
        "Error opening payment: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Payment success callback
  void handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment successful: ${response.paymentId}");
    Get.snackbar(
      "Payment Success",
      "Payment ID: ${response.paymentId}",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Payment error callback
  void handlePaymentError(PaymentFailureResponse response) {
    print("Payment failed: ${response.code} | ${response.message}");
    Get.snackbar(
      "Payment Failed",
      "Error: ${response.message}",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  // External wallet callback
  void handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet Selected: ${response.walletName}");
    Get.snackbar(
      "External Wallet",
      "Wallet: ${response.walletName}",
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize Razorpay instance
    razorpay = Razorpay();

    // Set Razorpay event listeners
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void onClose() {
    super.onClose();
    try {
      // Clear Razorpay listeners
      razorpay.clear();
    } catch (e) {
      print("Error disposing Razorpay: $e");
    }
  }
}
