import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:paymenttestmethode/bgremoval/constenst/base_api_url.dart';

class BackgroundRemovalController extends GetxController {
  final selectedImageBytes = Rx<Uint8List?>(null); // Holds selected image data
  RxBool isloading = false.obs; // Loading indicator

  /// Pick an image from the gallery
  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    try {
      final selectedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (selectedImage != null) {
        // Read image as bytes
        selectedImageBytes.value = await selectedImage.readAsBytes();
      } else {
        Get.snackbar("No Image Selected", "Please select an image to proceed.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }

  /// Resize the image if it exceeds the 50-megapixel limit
  Uint8List resizeImage(Uint8List imageBytes) {
    final originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) throw Exception("Invalid image format");

    const int maxPixels = 5000 * 10000; // 50 megapixels
    if (originalImage.width * originalImage.height > maxPixels) {
      // Calculate new dimensions maintaining aspect ratio
      final aspectRatio = originalImage.width / originalImage.height;
      final newWidth = 5000;
      final newHeight = (newWidth / aspectRatio).round();

      // Resize the image
      final resizedImage =
          img.copyResize(originalImage, width: newWidth, height: newHeight);

      // Encode resized image to bytes
      return Uint8List.fromList(img.encodeJpg(resizedImage));
    }
    return imageBytes; // Return original if resizing not needed
  }

  /// Remove the background of the selected image
  Future<void> removeBackground() async {
    if (selectedImageBytes.value == null) {
      Get.snackbar("Error", "Please select an image first.");
      return;
    }

    isloading.value = true;
    try {
      // Resize the image
      final resizedImage = resizeImage(selectedImageBytes.value!);

      // Convert image to Base64 string
      final base64Image = base64Encode(resizedImage);

      // API Details
      const apiUrl = BaseApiUrl.bghomeurl; // Replace with actual API URL
      const apiKey = BaseApiUrl.apiKey; // Replace with actual API Key

      // Make API request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': apiKey,
        },
        body: jsonEncode({'image_file_b64': base64Image}),
      );

      if (response.statusCode == 200) {
        // Update with processed image
        selectedImageBytes.value = response.bodyBytes;
        Get.snackbar("Success", "Background removed successfully!");
      } else {
        Get.snackbar(
          "Error",
          "Failed to remove background: ${response.statusCode} ${response.reasonPhrase}",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isloading.value = false;
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