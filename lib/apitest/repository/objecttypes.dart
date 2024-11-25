import 'package:paymenttestmethode/apitest/models/objectTypeModel.dart';
import 'package:paymenttestmethode/apitest/controller/service.dart/networkapiservice.dart';

class ObjecttypesRepo {
  NetworkApiService _networkApiService = NetworkApiService();

  Future<ObjectTypeModel?> getObjectTypes() async {
    try {
      String url = "https://reqres.in/api/register";
      final response = await _networkApiService.getApiService(url: url);
      if (response != null) {
        return ObjectTypeModel.fromJson(response);
      } else {
        print("Response is null");
        return null;
      }
    } catch (e) {
      print('Error in objectTypeApi $e');
      return null;
    }
  }
}
