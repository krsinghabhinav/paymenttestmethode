import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:paymenttestmethode/secondApi/model/postmodel.dart';

class Postapiscreen extends StatefulWidget {
  const Postapiscreen({super.key});

  @override
  State<Postapiscreen> createState() => _PostapiscreenState();
}

class _PostapiscreenState extends State<Postapiscreen> {
  Future<Postmodel?> postApiFetch() async {
    const String url = "https://jsonplaceholder.typicode.com/posts";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          "title": "This is my title",
          "body": "This is my new body",
          "userId": "1",
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Response Data: $data");
        return Postmodel.fromJson(data);
      } else {
        print("Error: ${response.statusCode}");
        return null; // Return null if the status code is not 201
      }
    } catch (e) {
      print("Exception: $e");
      return null; // Return null in case of an exception
    }
  }

  // API fetch function for POST request
  // Future<dynamic> postApiFetch() async {
  //   String url = "https://jsonplaceholder.typicode.com/posts";
  //   Response response = await http.post(
  //     Uri.parse(url),
  //     body: {"title": "this is title", "body": "this is body", "userId": "1"},
  //   );
  //   if (response.statusCode == 201) {
  //     final data = jsonDecode(
  //         response.body); // The response is a single post, not a list
  //     print(data);
  //     return data;
  //   } else {
  //     print(response.statusCode);
  //     return {}; // Return an empty map in case of an error
  //   }
  // }

  @override
  void initState() {
    super.initState();
    postApiFetch(); // Call the API once and store the future
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post API Example')),
      body: FutureBuilder(
        future: postApiFetch(), // Call the POST API function
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No Data Found"));
          }

          // If data is available

          return ListTile(
              title: Text(snapshot.data!.title),
              subtitle: Text(snapshot.data!.body));

          // return ListView(
          //   children: [
          //     ListTile(
          //       title: Text('Title: ${post['title']}'),
          //       subtitle: Text('Body: ${post['body']}'),
          //     ),
          //   ],
          // );
        },
      ),
    );
  }
}
