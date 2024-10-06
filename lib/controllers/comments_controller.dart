import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/comment_model.dart';

class CommentsController {
  Future<List<CommentModel>> fetchComments() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => CommentModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }
}
