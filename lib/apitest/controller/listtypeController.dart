import 'package:get/get.dart';
import 'package:paymenttestmethode/apitest/models/listtypemodel.dart';
import 'package:paymenttestmethode/apitest/repository/listtypeRepo.dart';

class Listtypecontroller extends GetxController {
  final ListtypeRepo _listtypeRepo = ListtypeRepo();

  final RxList<ListTypeModel> listtype = RxList<ListTypeModel>();

  Future<void> getListtypeController() async {
    try {
      final response = await _listtypeRepo.getListtype();
      if (response != null) {
        listtype.value = response;
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    getListtypeController();
  }
}
