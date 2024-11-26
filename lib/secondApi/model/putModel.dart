class PutModel {
  final String title;
  final String body;
  final String userId;
  final int id;

  PutModel({
    required this.title,
    required this.body,
    required this.userId,
    required this.id,
  });

  // Factory constructor for creating a PutModel from JSON
  factory PutModel.fromJson(Map<String, dynamic> json) {
    return PutModel(
      title: json['title'] as String,
      body: json['body'] as String,
      userId: json['userId'] as String,
      id: json['id'] as int,
    );
  }

  // Method for converting PutModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'userId': userId,
      'id': id,
    };
  }
}
