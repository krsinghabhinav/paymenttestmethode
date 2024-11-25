import 'package:get/get.dart';
import 'package:paymenttestmethode/apitest/models/listtypemodel.dart';
import 'package:paymenttestmethode/apitest/controller/service.dart/networkapiservice.dart';

class ListtypeRepo {
  final NetworkApiService _networkApiService = NetworkApiService();

  Future<List<ListTypeModel>?> getListtype() async {
    String url = "https://jsonplaceholder.typicode.com/users";
    try {
      final response = await _networkApiService.getApiService(url: url);

      // Map the response to a list of ListTypeModel
      List<dynamic> data = response as List<dynamic>;
      return data.map((item) => ListTypeModel.fromJson(item)).toList();
    } catch (e) {
      // Log and show an error message
      Get.snackbar('Error', 'Something went wrong: $e');
      print("Error: $e");
      // return []; // Return an empty list on error
    }
  }
}
