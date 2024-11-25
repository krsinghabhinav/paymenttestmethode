class SignupModel {
  String? email;
  String? password;
  String? token; // Ensure token is of the correct type, e.g., String.

  SignupModel({this.email, this.password, this.token});

  SignupModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    token = json['token']; // Parse the token from the JSON response.
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['token'] = this.token; // Include the token in the JSON serialization.
    return data;
  }
}
