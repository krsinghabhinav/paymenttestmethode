import 'dart:convert';

import 'package:get/get.dart';
import 'package:paymenttestmethode/secondApi/model/objdogsModels.dart';
import 'package:http/http.dart' as http;

class DogsApiController extends GetxController {
  // Rx variable to observe the DogsModel instance
  final dogData = Rxn<DogsModel>();

  // Method to fetch dog data from the API
  Future<void> fetchDogData() async {
    const String url = "https://dog.ceo/api/breeds/image/random";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        dogData.value = DogsModel.fromJson(data);
        print('Dog data fetched successfully: ${dogData.value}');
      } else {
        print('Failed to fetch dog data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchDogData(); // Fetch the dog data when the controller initializes
  }
}
