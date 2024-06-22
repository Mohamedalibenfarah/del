import 'dart:convert';
import 'package:deloitte/models/api_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.114:8000';

  Future<List<ApiModel>> getApi() async {
    List<ApiModel> personList = [];
    var path = Uri.parse('$baseUrl/api');
    var response = await http.get(path);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map<String, dynamic> item in data) {
        personList.add(ApiModel.fromJson(item));
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
