import 'package:get/get.dart';
import 'package:paymenttestmethode/apitest/models/userlistModel.dart';
import 'package:paymenttestmethode/apitest/repository/userlistRepo.dart';

class UserController extends GetxController {
  final Userlistrepo _userlistrepo = Userlistrepo();
  final RxList<SignupModel> userList = RxList<SignupModel>();

  Future<List<SignupModel>?> fetchSignupData(
      {required String email, required String password}) async {
    // Prepare request body
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };

    try {
      // Call repository to fetch data
      final response = await _userlistrepo.getUsreListRepo(requestBody);

      // Update userList if response is not null
      if (response != null) {
        userList.assignAll(response); // Efficiently update the RxList
        return response; // Return the response
      } else {
        return null;
      }
    } catch (e) {
      // Log the error or handle it appropriately
      Get.snackbar(
        "Error",
        "Failed to fetch user data. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return null; // Return null in case of an error
    }
  }

  @override
  void onInit() {
    super.onInit();

    // Example default call for testing or initial load (replace with real data)
    fetchSignupData(email: "test@example.com", password: "password123");
  }
}
