import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Paymenttest extends StatefulWidget {
  const Paymenttest({super.key});

  @override
  State<Paymenttest> createState() => _PaymenttestState();
}

class _PaymenttestState extends State<Paymenttest> {
  TextEditingController amountController = TextEditingController();
  late Razorpay razorpay = Razorpay();
  void openChecked(amount) {
    amount = amount * 100;
    var options = {
      'key': 'rzp_test_oEcS0cHDgGmhh4',
      'amount': amount,
      'name': 'papaya coders',
      'description': 'It working for devolopment',
      'prefill': {
        'contact': '8840591006',
        'email': 'abhinavkkrsingh@gmail.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      print("have some error $e");
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    print("payment succesful" + response.paymentId!);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    print("payment failed" + response.message!);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    try {
      razorpay.clear();
    } catch (e) {
      print("dispose error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Test'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: amountController,
            decoration: InputDecoration(
              hintText: 'Enter amount',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                print('Please enter amount $value');
                return 'Please enter amount';
              } else {
                return null;
              }
            },
          ),
          ElevatedButton(
              onPressed: () {
                if (amountController.text.toString().isNotEmpty) {
                  setState(() {
                    var amount = double.parse(amountController.text.toString());
                    openChecked(amount);
                  });
                }
              },
              child: Text("Payment"))
        ],
      ),
    );
  }
}
