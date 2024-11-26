import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img; // Import image package
import 'package:http/http.dart' as http;
import 'package:paymenttestmethode/bgremoval/constenst/base_api_url.dart';

class Bghomecontroller extends GetxController {
  final Rx<Uint8List?> chooseImageData = Rx<Uint8List?>(null);

  RxBool isloading = false.obs;

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    try {
      XFile? selectedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (selectedImage != null) {
        Uint8List imageBytes = await selectedImage.readAsBytes();
        chooseImageData.value = imageBytes; // Update observable with image data
      } else {
        Get.snackbar("Image Picker", "No image selected");
      }
    } catch (e) {
      Get.snackbar("Error", "Error picking image: $e");
    }
  }

  Uint8List resizeImage(Uint8List imageBytes) {
    // Decode the image
    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) {
      throw Exception("Failed to decode image");
    }

    // Check if resizing is needed (50 megapixels = 5000 x 10000 pixels max)
    int maxPixels = 5000 * 10000;
    if (originalImage.width * originalImage.height > maxPixels) {
      // Calculate new dimensions maintaining aspect ratio
      double aspectRatio = originalImage.width / originalImage.height;
      int newWidth = (5000 * aspectRatio).round();
      int newHeight = (newWidth / aspectRatio).round();

      // Resize the image
      img.Image resizedImage =
          img.copyResize(originalImage, width: newWidth, height: newHeight);

      // Return resized image as Uint8List
      return Uint8List.fromList(img.encodeJpg(resizedImage));
    }

    // No resizing needed
    return imageBytes;
  }

  Future<void> removebg() async {
    if (chooseImageData.value == null) {
      Get.snackbar("Error", "No image selected to process");
      return;
    }

    try {
      isloading.value = true;
      // Resize the image before sending it to the API
      Uint8List resizedImage = resizeImage(chooseImageData.value!);

      // Convert resized image bytes to Base64 string
      String base64Image = base64Encode(resizedImage);

      // API URL and Key
      String url = BaseApiUrl.bghomeurl; // Replace with your API URL
      String apiKey = BaseApiUrl.apiKey; // Replace with your API Key

      // Make the POST request
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': apiKey,
        },
        body: jsonEncode({'image_file_b64': base64Image}),
      );

      // Handle the response
      if (response.statusCode == 200) {
        chooseImageData.value =
            response.bodyBytes; // Update with processed image
        Get.snackbar("Success", "Background removed successfully!");
        isloading.value = false;
      } else {
        isloading.value = false;

        Get.snackbar("Error",
            "Failed to remove background: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      isloading.value = false;
      Get.snackbar("Error", "An error occurred: $e");
    }
  }
}








// class Bghomecontroller extends GetxController {
//   final Rx<Uint8List?> chooseImageData = Rx<Uint8List?>(null);

//   Future<void> pickImage() async {
//     final imagePicker = ImagePicker();
//     try {
//       XFile? selectedImage =
//           await imagePicker.pickImage(source: ImageSource.gallery);

//       if (selectedImage != null) {
//         Uint8List imageBytes = await selectedImage.readAsBytes();
//         chooseImageData.value = imageBytes; // Update observable with image data
//       } else {
//         Get.snackbar("Image Picker", "No image selected");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Error picking image: $e");
//     }
//   }

//   Future<void> removebg() async {
//     if (chooseImageData.value == null) {
//       Get.snackbar("Error", "No image selected to process");
//       return;
//     }

//     try {
//       // Convert image bytes to Base64 string
//       String base64Image = base64Encode(chooseImageData.value!);

//       // API URL and Key
//       String url = BaseApiUrl.bghomeurl; // Replace with your API URL
//       String apiKey = BaseApiUrl.apiKey; // Replace with your API Key

//       // Make the POST request
//       var response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'X-API-Key': apiKey,
//         },
//         body: jsonEncode({'image_file_b64': base64Image}),
//       );

//       // Handle the response
//       if (response.statusCode == 200) {
//         chooseImageData.value = response.bodyBytes; // Update with processed image
//         Get.snackbar("Success", "Background removed successfully!");
//       } else {
//         Get.snackbar("Error",
//             "Failed to remove background: ${response.statusCode} ${response.body}");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "An error occurred: $e");
//     }
//   }
// }
// 