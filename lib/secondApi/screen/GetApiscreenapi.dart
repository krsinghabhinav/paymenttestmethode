import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:paymenttestmethode/secondApi/model/photosModel.dart';

class Getapiscreenapi extends StatefulWidget {
  const Getapiscreenapi({super.key});

  @override
  State<Getapiscreenapi> createState() => _GetapiscreenapiState();
}

class _GetapiscreenapiState extends State<Getapiscreenapi> {
  Future<List<photosModel>?> getApiFetch() async {
    String url = "https://jsonplaceholder.typicode.com/photos";
    try {
      Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => photosModel.fromJson(e)).toList();
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  // Future<void> getApiFetch() async {
  //   String url = "https://jsonplaceholder.typicode.com/photos";
  //   Response respose = await http.get(Uri.parse(url));
  //   if (respose.statusCode == 200) {
  //     List<dynamic> data = jsonDecode(respose.body);
  //     print(data);
  //   } else {
  //     print("Error occur and response is ${respose.statusCode} ");
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApiFetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getApiFetch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No Data Found"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var photo = snapshot.data![index];
              return ListTile(
                leading: Container(
                  height: 100,
                  width: 100,
                  child: Image.network(photo.url.toString()),
                ),
                title: Text(photo.title.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
