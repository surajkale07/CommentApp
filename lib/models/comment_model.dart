class CommentModel {
  final String name;
  final String email;

  final String body;

  CommentModel({required this.name, required this.email, required this.body});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }
}
