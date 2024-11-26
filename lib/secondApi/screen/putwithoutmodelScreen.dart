import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Putwithoutmodelscreen extends StatefulWidget {
  const Putwithoutmodelscreen({super.key});

  @override
  State<Putwithoutmodelscreen> createState() => _PutwithoutmodelscreenState();
}

class _PutwithoutmodelscreenState extends State<Putwithoutmodelscreen> {
  // Variable to store the updated post data
  Map<String, dynamic>? updatedPost;

  // Function to send the PUT request and update the post
  Future<void> updatePost() async {
    try {
      Map<String, dynamic> bodyData = {
        "title": "this is put title",
        "body": 'this is put body',
        "userId": 2,
      };

      Response response = await http.put(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("response === $data");
        setState(() {
          updatedPost = data; // Store the updated post data to show in UI
        });
      } else {
        print("Failed to update post. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    updatePost(); // Call the update function when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    updatePost, // Trigger the update when button is pressed
                child: const Text("Update Post"),
              ),
              const SizedBox(height: 20),
              // Check if there is updated post data and show it
              updatedPost != null
                  ? ListTile(
                      title: Text("Title: ${updatedPost?['title']}"),
                      subtitle: Text("Body: ${updatedPost?['body']}"),
                      trailing: Text("User ID: ${updatedPost?['userId']}"),
                    )
                  : const Center(child: Text("No data updated yet.")),
            ],
          ),
        ),
      ),
    );
  }
}
