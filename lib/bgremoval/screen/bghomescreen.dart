import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paymenttestmethode/bgremoval/controller/bghomeController.dart';

class Bghomescreen extends StatefulWidget {
  const Bghomescreen({super.key});

  @override
  State<Bghomescreen> createState() => _BghomescreenState();
}

class _BghomescreenState extends State<Bghomescreen> {
  final bgController = Get.put(Bghomecontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Background Remover'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: Get.height / 2,
              width: Get.width,
              child: Obx(() {
                // Display the current image (original or processed)
                final Uint8List? imageData = bgController.chooseImageData.value;

                // Check if image data is available
                if (imageData != null) {
                  return Stack(
                    children: [
                      // Display the image with a blur effect if it's loading
                      Image.memory(
                        imageData,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      // If loading, add a blur effect on top of the image
                      if (bgController.isloading.value)
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.6, // Semi-transparent overlay
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                  sigmaX: 5.0, sigmaY: 5.0), // Apply blur
                              child: Container(
                                  color: Colors
                                      .white), // White overlay with opacity
                            ),
                          ),
                        ),
                      // Show Circular Progress Indicator
                      if (bgController.isloading.value)
                        Center(
                          child: CircularProgressIndicator(
                            color: Colors
                                .blue, // Blue color for the circular progress
                            strokeWidth:
                                4.0, // Adjust the thickness of the circular progress
                          ),
                        ),
                    ],
                  );
                } else {
                  // If no image is selected or processed
                  return const Center(
                    child: Text(
                      "No image selected or processed yet",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  );
                }
              }),

              // child: Obx(() {
              //   // Display the current image (original or processed)
              //   final Uint8List? imageData = bgController.chooseImageData.value;

              //   // Check if image data is available
              //   if (imageData != null) {
              //     return bgController.isloading.value
              //         ? Center(
              //             child: CircularProgressIndicator(
              //               color: Colors
              //                   .blue, // Blue color for the circular progress
              //               strokeWidth:
              //                   4.0, // Adjust the thickness of the circular progress
              //             ),
              //           )
              //         : Image.memory(
              //             imageData,
              //             fit: BoxFit.cover,
              //           );
              //   } else {
              //     // If no image is selected or processed
              //     return const Center(
              //       child: Text(
              //         "No image selected or processed yet",
              //         style:
              //             TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              //       ),
              //     );
              //   }
              // }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await bgController.pickImage();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 12), // Button padding
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  elevation: 5, // Shadow effect
                ),
                child: const Text("Pick Image"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await bgController.removebg();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Background color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 12), // Button padding
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  elevation: 5, // Shadow effect
                ),
                child: const Text("Remove Background"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
