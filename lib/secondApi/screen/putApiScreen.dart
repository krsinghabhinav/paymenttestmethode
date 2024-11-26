import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:paymenttestmethode/secondApi/model/putModel.dart';

class PutApiScreen extends StatefulWidget {
  const PutApiScreen({super.key});

  @override
  State<PutApiScreen> createState() => _PutApiScreenState();
}

class _PutApiScreenState extends State<PutApiScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController idController = TextEditingController();

  PutModel? updatedPost;

  Future<PutModel?> putApiFetch({required int id}) async {
    String url = "https://jsonplaceholder.typicode.com/posts/$id";

    try {
      Map<String, dynamic> bodyData = {
        "title": titleController.text,
        "body": bodyController.text,
        "userId": userIdController.text,
      };

      Response response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        final data = PutModel.fromJson(responseData);
        print("Response: $responseData");

        // Update the state with the new data
        setState(() {
          updatedPost = data;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Post updated successfully!")),
        );
      } else {
        print("Failed to update the post. Status code: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update the post.")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
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
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: "ID"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(labelText: "Body"),
              ),
              TextField(
                controller: userIdController,
                decoration: const InputDecoration(labelText: "User ID"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Get the ID from the controller
                  int id = int.tryParse(idController.text) ?? 0;

                  // Validate the ID
                  if (id > 0) {
                    await putApiFetch(id: id);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid ID")),
                    );
                  }
                },
                child: const Text("Update Post"),
              ),
              const SizedBox(height: 20),
              updatedPost != null
                  ? ListTile(
                      title: Text("Title: ${updatedPost!.title}"),
                      subtitle: Text("Body: ${updatedPost!.body}"),
                      trailing: Text("User ID: ${updatedPost!.userId}"),
                    )
                  : const Center(child: Text("No data updated yet.")),
            ],
          ),
        ),
      ),
    );
  }
}
