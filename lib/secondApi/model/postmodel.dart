class Postmodel {
  final int id;
  final String title;
  final String body;

  Postmodel({
    required this.id,
    required this.title,
    required this.body,
  });

  // Factory constructor to create a Postmodel object from JSON
  factory Postmodel.fromJson(Map<String, dynamic> json) {
    return Postmodel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  // Method to convert a Postmodel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }
}
