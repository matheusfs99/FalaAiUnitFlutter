import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/accounts/';
    } else if (Platform.isIOS) {
      return 'http://192.168.x.x:8000/api/accounts/'; // substituir pelo meu ip
    } else {
      return 'http://localhost:8000/api/accounts/';
    }
  }

  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      try {
        return json.decode(response.body); // Decodifica o JSON da resposta
      } catch (e) {
        print('Error decoding JSON: $e');
        return null;
      }
    } else {
      print('Login failed with status: ${response.statusCode}');
      return null;
    }
  }

  static Future<bool> register(
      String email, String firstName, String lastName, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      body: {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
      },
    );

    return response.statusCode == 201;
  }

  static Future<Map<String, dynamic>?> getUserData(
      String token, int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$userId/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      try {
        return json.decode(response.body);
      } catch (e) {
        print('Error decoding JSON: $e');
        return null;
      }
    } else {
      print('Failed to load user data with status: ${response.statusCode}');
      return null;
    }
  }
}
