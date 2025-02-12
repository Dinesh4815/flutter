import 'dart:convert';
import 'package:apiusingaccesstoken/models/api_model.dart';
import 'package:http/http.dart' as http;

class ApiResponce {
  Future<List<Datum>> fetchPosts(int page, int limit, {String searchQuery = ""}) async {
    final String url = 'https://dev-api.peepul.farm/v1.0/farms/$page/$limit?search_string=$searchQuery';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImZhcm1lcjEyM0BnbWFpbC5jb20iLCJpZCI6IjY1NTcyY2I1ZGJlYzYxNzBhZmY2ODhiNCIsInBhc3N3b3JkIjoiJDJiJDEwJDY4MVB1VXNZM2pkV21RZVNZRld0NnUwQ2RzZW8yTWFrUld1WGtHUDFUR0ZibjFUOXlobjdHIiwidXNlcl90eXBlIjoiZmFybWVyIiwiaWF0IjoxNzM5MTY1ODM2LCJleHAiOjE3NDcwNTU4MzZ9.hDWys7BwzOnwy2waO24_9RwTUaMamGTU33DXGmv7lHI",
        "Content-Type": "application/json",
      },
    );

    print("Response Code: ${response.statusCode}");
    print("Full Response: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData is Map<String, dynamic> && jsonData.containsKey("data")) {
        final post = Post.fromJson(jsonData);
        return post.data ?? [];
      } else {
        throw Exception("Invalid JSON format");
      }
    } else {
      throw Exception('API Error ${response.statusCode}: ${response.body}');
    }
  }
}
