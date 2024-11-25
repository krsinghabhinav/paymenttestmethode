import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/userController.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  UserController _userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
