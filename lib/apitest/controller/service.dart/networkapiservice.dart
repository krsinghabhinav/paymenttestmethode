import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class NetworkApiService {
  // Function to get headers based on authorization requirement
  Map<String, String> header(bool isRequestAuthorization) {
    if (isRequestAuthorization) {
      return {
        'Authorization': 'Bearer YOUR_API_KEY',
        'Content-Type': 'application/json',
      };
    } else {
      return {
        'Content-Type': 'application/json',
      };
    }
  }

  // Function to perform GET API request
  Future<dynamic> getApiService({
    required String url,
    bool isRequestAuthorization = false, // Optional param for headers
  }) async {
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      }).timeout(Duration(seconds: 60)); // Handle timeout
      print("Get API URL: $url");
      print("API Response Body: ${response.body}");

      // Handle response
      return returnResponse(response);
    } catch (e) {
      print("Error: $e");
      return {'error': e.toString()}; // Return error as JSON-like structure
    }
  }

  Future<dynamic> postApiService({
    required String url,
    Object? requestBody,
    bool isRequestAuthorization = false,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: requestBody != null ? jsonEncode(requestBody) : null,
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 60));
      print("Get API URL: $url");
      print("API Response Body: ${response.body}");
      print("API Response Body: ${requestBody}");
      return returnResponse(response);
    } catch (e) {
      print("Error: $e");
      return {'error': e.toString()};
    }
  }

  // Function to handle API responses
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responsejson = jsonDecode(response.body);
        return responsejson;
      case 201:
        var responseJson = jsonDecode(response.body);
        return responseJson;

      case 400:
        Fluttertoast.showToast(msg: "API error status Code 400");
        throw Exception("Bad Request: ${response.body}");
      case 401:
      case 403:
        Fluttertoast.showToast(msg: "Unauthorized: ${response.body}");
        throw Exception("Unauthorized: ${response.body}");
      case 404:
        Fluttertoast.showToast(msg: "Unauthorized: ${response.body}");
        throw Exception("Not Found: ${response.body}");
      case 500:
        Fluttertoast.showToast(
            msg:
                "Error occure while communication with server with statusCode 500");
        throw Exception(
            "Error occure while communication with server with statusCode 500");
      default:
        Fluttertoast.showToast(
            msg: "Server Error: ${response.statusCode}, ${response.body}");
        throw Exception(
            "Server Error: ${response.statusCode}, ${response.body}");
    }
  }
}
