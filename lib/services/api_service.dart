import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fala_ai_unit/models/meeting_model.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api'; // web e ios
  // static const String baseUrl = 'http://10.0.2.2:8000/api'; // android

  static String? _token;

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _token = token;
  }

  static Future<String?> getToken() async {
    if (_token != null) return _token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/user/login/'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      try {
        final loginData = json.decode(response.body);
        String token = loginData['token'];
        await saveToken(token);
        return loginData;
      } catch (e) {
        print('Error decoding JSON: $e');
        return null;
      }
    } else {
      print('Login failed with status: ${response.statusCode}');
      return null;
    }
  }

  static Future<void> logout() async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/user/logout/'),
      headers: {'Authorization': 'Token $token'},
    );
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      _token = null;
    } else {
      print('Logout failed with status: ${response.statusCode}');
    }
  }

  static Future<bool> register(
      String email, String firstName, String lastName, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/user/'),
      body: {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
      },
    );

    return response.statusCode == 201;
  }

  static Future<Map<String, dynamic>?> getUserData(int userId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/accounts/user/$userId/'),
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

  static Future<Map<String, dynamic>?> updateUserProfile(
      int userId, String email, String firstName, String lastName) async {
    final token = await getToken();
    final response = await http.patch(
      Uri.parse('$baseUrl/accounts/user/$userId/'),
      headers: {'Authorization': 'Token $token'},
      body: {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
      },
    );

    if (response.statusCode == 200) {
      try {
        return json.decode(response.body);
      } catch (e) {
        print('Error decoding JSON: $e');
        return null;
      }
    } else {
      print('Failed to update user with status: ${response.statusCode}');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> searchUserByEmail(String email) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/accounts/user/search_by_email/?email=$email'),
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

  static Future<List<Meeting>?> meetings() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/meetings/meeting/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Meeting.fromJson(item)).toList();
      } catch (e) {
        print('Error decoding JSON: $e');
        return null;
      }
    } else {
      print('Failed to load meetings with status: ${response.statusCode}');
      return null;
    }
  }

  static Future<bool> scheduleMeeting(int guestId, String description,
      DateTime startTime, DateTime endTime) async {
    final token = await getToken();

    final formattedStartTime =
        DateFormat("dd/MM/yyyy HH:mm:ss").format(startTime);
    final formattedEndTime = DateFormat("dd/MM/yyyy HH:mm:ss").format(endTime);

    final response =
        await http.post(Uri.parse('$baseUrl/meetings/meeting/'), headers: {
      'Authorization': 'Token $token'
    }, body: {
      'guest': guestId.toString(),
      'description': description,
      'start_time': formattedStartTime.toString(),
      'end_time': formattedEndTime.toString()
    });

    return response.statusCode == 201;
  }
}
