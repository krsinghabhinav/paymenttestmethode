import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paymenttestmethode/paymenttest.dart';
import 'package:paymenttestmethode/phonepepayment.dart';
import 'package:paymenttestmethode/sendondpayment.dart';
import 'package:paymenttestmethode/upi.dart';

import 'apitest/apiscreen/listtypeapi.dart';
import 'apitest/apiscreen/object_screen.dart';
import 'apitest/apiscreen/signupScreen.dart';
import 'secondApi/screen/GetApiscreenapi.dart';
import 'secondApi/screen/deleteScreen.dart';
import 'secondApi/screen/postApiScreen.dart';
import 'secondApi/screen/putApiScreen.dart';
import 'secondApi/screen/putwithoutmodelScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Deletescreen(),
    );
  }
}
