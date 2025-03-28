import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis_ai/models/user.dart';
import 'dart:convert';

import 'package:jarvis_ai/services/exceptions/api_exception.dart';

class ApiService {
  final String baseUrl;
  ApiService({required this.baseUrl});
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  Future<dynamic> post(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      print('$baseUrl$endpoint');
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'X-Stack-Access-Type': 'client',
          'X-Stack-Publishable-Client-Key':
              'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
          'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
          ...?headers,
        },
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(e.toString(), 0);
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      print('$baseUrl$endpoint');
      String? userJson = await _secureStorage.read(key: 'user');
      if (userJson == null) {
        print('No access token found. User needs to log in.');
        return null;
      }
      UserModel user = UserModel.fromJson(jsonDecode(userJson));
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'X-Stack-Access-Type': 'client',
          'X-Stack-Publishable-Client-Key':
              'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
          'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
          if (user != null) 'X-Stack-Refresh-Token': '${user.refreshToken}',
          if (user != null) 'Authorization': 'Bearer ${user.accessToken}',
          ...?headers,
        },
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(e.toString(), 0);
    }
  }

  dynamic _handleResponse(http.Response response) {
    final responseData = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseData;
    } else {
      throw ApiException(
        responseData['message'] ?? 'Something went wrong',
        response.statusCode,
      );
    }
  }
}
