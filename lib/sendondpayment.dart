import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'paymneController.dart';

class Sendondpayment extends StatefulWidget {
  const Sendondpayment({super.key});

  @override
  State<Sendondpayment> createState() => _SendondpaymentState();
}

class _SendondpaymentState extends State<Sendondpayment> {
  PaymentController paymentController = Get.put(PaymentController());
  final _formKey = GlobalKey<FormState>(); // Key for form validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey, // Assign the key to the form
          child: Column(
            children: [
              TextFormField(
                controller: paymentController.amountController,
                keyboardType: TextInputType.number, // Restrict to numeric input
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  border:
                      OutlineInputBorder(), // Adds a border around the field
                  labelText: 'Amount', // Provides a label
                  prefixText: '₹ ', // Adds a currency prefix
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    Get.snackbar("Payment ", 'amount must be not empty',
                        backgroundColor: Colors.red, colorText: Colors.white);
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Enter a valid amount greater than zero';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Valid form input, proceed to payment
                    double amount =
                        double.parse(paymentController.amountController.text);
                    paymentController.openCheckout(amount);
                  } else {
                    // Invalid input, show snackbar
                    Get.snackbar(
                      "Payment Error",
                      "Please enter a valid amount",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: Text("Payment"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
