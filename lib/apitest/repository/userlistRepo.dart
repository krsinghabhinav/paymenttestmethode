import 'package:paymenttestmethode/apitest/models/userlistModel.dart';
import 'package:paymenttestmethode/apitest/controller/service.dart/networkapiservice.dart';

class Userlistrepo {
  NetworkApiService _networkApiService = NetworkApiService();
  String url = "https://reqres.in/api/register";

  Future<List<SignupModel>?> getUsreListRepo(Object? requestBody) async {
    try {
      final response = await _networkApiService.postApiService(
          url: url, requestBody: requestBody);
      List<dynamic> data = response as List<dynamic>;
      return data.map((e) => SignupModel.fromJson(e)).toList();
    } catch (e) {
      print('Error $e');
    }
  }
}
