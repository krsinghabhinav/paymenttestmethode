import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Deletescreen extends StatefulWidget {
  const Deletescreen({super.key});

  @override
  State<Deletescreen> createState() => _DeletescreenState();
}

class _DeletescreenState extends State<Deletescreen> {
  TextEditingController deleteIdController = TextEditingController();

  // Variable to store the status of the delete operation
  String statusMessage = "";

  Future<void> deleteApi(int id) async {
    setState(() {
      statusMessage = "Deleting post with ID: $id..."; // Show loading message
    });
    try {
      Response response = await http.delete(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("respnse===$data");
        setState(() {
          statusMessage = "Post with ID: $id deleted successfully!";
        });
      } else {
        setState(() {
          statusMessage =
              "Failed to delete post with ID: $id. Status Code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = "Error deleting post with ID: $id. Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: deleteIdController,
                decoration:
                    const InputDecoration(labelText: "Enter ID to Delete"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final id = int.tryParse(deleteIdController.text);
                  if (id != null) {
                    deleteApi(id);
                  } else {
                    setState(() {
                      statusMessage = "Please enter a valid ID.";
                    });
                  }
                },
                child: const Text("Delete Post"),
              ),
              const SizedBox(height: 20),
              // Display the status message
              Text(
                statusMessage,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
