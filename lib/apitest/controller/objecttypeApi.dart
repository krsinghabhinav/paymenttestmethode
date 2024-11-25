import 'package:get/get.dart';
import 'package:paymenttestmethode/apitest/models/objectTypeModel.dart';
import 'package:paymenttestmethode/apitest/repository/objecttypes.dart';

class ObjecttypeapiController extends GetxController {
  final ObjecttypesRepo _objecttypesRepo = ObjecttypesRepo();

  // Observable variable to store the data
  final Rx<ObjectTypeModel?> objecttype = Rx<ObjectTypeModel?>(null);

  Future<ObjectTypeModel?> getObjectControllerApi() async {
    try {
      final response = await _objecttypesRepo.getObjectTypes();
      if (response != null) {
        objecttype.value = response;
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getObjectControllerApi();
  }
}
