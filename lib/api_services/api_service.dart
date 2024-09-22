import 'dart:convert';
import 'package:deloitte/models/model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.100.16:8000';

  Future<List<Model>> getApi() async {
    List<Model> personList = [];
    var path = Uri.parse('$baseUrl/api');
    var response = await http.get(path);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map<String, dynamic> item in data) {
        personList.add(Model.fromJson(item));
      }
    }

    return personList;
  }

  /// Connecté avec ton compte
  Future<Map<String, dynamic>> login(
      String email, String regNo, String password) async {
    try {
      var path = Uri.parse('$baseUrl/authentification/api/login');
      var response = await http.post(path,
          body: {'email': email, 'regNo': regNo, 'password': password});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Save the login data
        await _saveLoginData(data);

        return data;
      } else {
        throw Exception(
            'Failed to log in: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      var path = Uri.parse('$baseUrl/authentification/api/logout');
      var response = await http.post(path);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to log out: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      rethrow;
    }
  }

  Future<void> _saveLoginData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('accessToken', data['access_token'] as String? ?? '');
    await prefs.setString(
        'refreshToken', data['refresh_token'] as String? ?? '');
    await prefs.setString('email', data['email'] as String? ?? '');
    await prefs.setString('regNo', data['regNo'] as String? ?? '');
    await prefs.setString('userName', data['name'] as String? ?? '');
    await prefs.setInt('userId', data['user_id'] as int? ?? 0);

    await prefs.setBool('isLoggedIn', true);
  }

  /// Creation du compte
  Future<Map<String, dynamic>> create(
    String email,
    String regNo,
    String password,
    String userName,
    String mobile,
    String name,
  ) async {
    try {
      var path = Uri.parse('$baseUrl/authentification/api/create');
      var body = {
        'email': email,
        'regNo': regNo,
        'password': password,
        'userName': userName,
        'mobile': mobile,
        'name': name,
      };
      var response = await http.post(
        path,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        var errorResponse = jsonDecode(response.body);
        String errorMessage = 'Failed to create:\n';
        errorResponse.forEach((key, value) {
          errorMessage += '$key: $value\n';
        });
        throw Exception(errorMessage.trim());
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      rethrow;
    }
  }
}
