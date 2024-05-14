import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  static Future<List<String>> fetchNotifications() async {
    final response = await http.get(Uri.parse('https://yourapi.com/notifications'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((notification) => notification['message'].toString()).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }
}