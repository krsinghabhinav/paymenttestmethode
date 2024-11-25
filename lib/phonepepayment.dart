import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:http/http.dart' as http;

class PhonepePayment extends StatefulWidget {
  const PhonepePayment({super.key});

  @override
  State<PhonepePayment> createState() => _PhonepePaymentState();
}

class _PhonepePaymentState extends State<PhonepePayment> {
  // Declare variables
  String environment = "SANDBOX";
  String appId = "";
  String merchantId = "PGTESTPAYUAT86";
  String transactionId = DateTime.now().microsecondsSinceEpoch.toString();
  bool enableLogging = true;
  String checkSum = "";
  String saltKey = '96434309-7796-489d-8924-ab56988a6076';
  String saltIndex = "1";
  // String callBackUrl =
  //     "https://webhook.site/401d6548-fbbc-4196-be33-fc074700e146";
  String callBackUrl =
      "https://webhook.site/401d6548-fbbc-4196-be33-fc074700e146";
  String body = "";
  Object? result;
  String endPoint = "/pg/v1/pay";
  @override
  void initState() {
    super.initState();
    phonepeInit();
    body = getChecksum().toString();
  }

  void phonepeInit() {
    // Add initialization logic here
    debugPrint("PhonePe initialized with environment: $environment");
    PhonePePaymentSdk.init(
      environment,
      appId,
      merchantId,
      enableLogging,
    )
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  getChecksum() {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": transactionId,
      "merchantUserId": "90223250",
      "amount": 1000,
      "mobileNumber": "8840591006",
      "callbackUrl": callBackUrl,
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));

    checkSum =
        '${sha256.convert(utf8.encode(base64Body + endPoint + saltKey)).toString()}###$saltIndex';

    return base64Body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("PhonePe Payment"),
        ),
        body: Column(
          children: [
            Center(
              child: Text("PhonePe Payment Integration"),
            ),
            ElevatedButton(
              onPressed: () {
                startPgTransaction();
              },
              child: Text("phonepe"),
            ),
            Text("reslut \n$result")
          ],
        ));
  }

  void startPgTransaction() {
    PhonePePaymentSdk.startTransaction(body, callBackUrl, checkSum, "")
        .then((response) => {
              setState(() async {
                if (response != null) {
                  String status = response['status'].toString();
                  String error = response['error'].toString();

                  if (status == 'SUCCESS') {
                    print("Flow Completed - Status: Success!");

                    await checkStatus();
                    return;
                  } else {
                    print("Flow Completed - Status: $status and Error: $error");
                    return;
                  }
                } else {
                  print("Flow Incomplete");
                  return;
                }
              })
            })
        .catchError((error) {
      // handleError(error)
      return <dynamic>{};
    });
  }

  void handleError(error) {
    setState(() {
      result = {'error': error};
    });
  }

  checkStatus() async {
    try {
      String url =
          "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/$merchantId/$transactionId";
      String concatString = "/pg/v1/status/$merchantId/$transactionId$saltKey";

      var bytes = utf8.encode(concatString);
      var digest = sha256.convert(bytes).toString();

      String xVerify = "$digest###$saltIndex";

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'x-verify': xVerify,
        "X-MERCHANT-ID": merchantId,
      };

      await http.get(Uri.parse(url), headers: headers).then((response) {
        var res = jsonDecode(response.body);
        print("Abhinavsingh====$res");
        try {
          if (res["success"] &&
              res["code"] == "PAYMENT_SUCCESS" &&
              res["data"]['state'] == "COMPLETED") {
            Fluttertoast.showToast(msg: res["message"]);
          } else {
            Fluttertoast.showToast(msg: 'Somthing went wrong');
          }
        } on Exception catch (e) {
          print('Exception occurred: $e');
          Fluttertoast.showToast(msg: 'Exception occurred: $e');
        }
      });
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: 'Exception occurred: $e');
    }
  }
}
