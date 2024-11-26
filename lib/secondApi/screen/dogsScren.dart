import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paymenttestmethode/secondApi/controllers/dogsApiController.dart';

class Dogsscren extends StatefulWidget {
  const Dogsscren({super.key});

  @override
  State<Dogsscren> createState() => _DogsscrenState();
}

class _DogsscrenState extends State<Dogsscren> {
  final dogsController = Get.put(DogsApiController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Obx(
                () {
                  if (dogsController.dogData.value == null) {
                    return CircularProgressIndicator();
                  }
                  return Container(
                    height: 500,
                    width: 500,
                    child: Center(
                        child: dogsController.dogData.value!.message != null
                            ? Image.network(
                                dogsController.dogData.value!.message
                                    .toString(),
                                fit: BoxFit.cover,
                              )
                            : Container()),
                  );
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  dogsController.fetchDogData();
                  if (dogsController.dogData.value!.status == "success") {
                    Get.snackbar("Success", "Image Loaded Successfully");
                  } else {
                    Get.snackbar("Error", "Failed to Load Image");
                  }
                },
                child: Text("change images"))
          ],
        ),
      ),
    );
  }
}
