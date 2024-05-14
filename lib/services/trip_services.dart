import 'dart:convert';
import 'package:http/http.dart' as http;

class TripServices {
  static const String baseUrl = 'http://localhost:3000';

  static Future<Map<String, dynamic>> createTrip(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }
}