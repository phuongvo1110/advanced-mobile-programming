import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jarvis_ai/models/member.dart';
import 'package:jarvis_ai/models/user.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
part 'jarvis_service.g.dart';

class JarvisService = _JarvisService with _$JarvisService;

abstract class _JarvisService with Store {
  final String baseUrl = 'https://api.dev.jarvis.cx';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  @observable
  bool isLoading = false;
  @observable
  Member? member;
  @action
  Future<Member?> getCurrentUser() async {
    isLoading = true;
    try {
      String? userJson = await _secureStorage.read(key: 'user');
      if (userJson == null) {
        print('No access token found. User needs to log in.');
        return null;
      }
      UserModel user = UserModel.fromJson(jsonDecode(userJson));
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'X-Stack-Access-Type': 'client',
          'X-Stack-Publishable-Client-Key':
              'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
          'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
          'Authorization': 'Bearer ${user.accessToken}',
        },
      );
      print('${response.body}');
      final data = jsonDecode(response.body);
      print('Data: $data');
      member = Member(
        id: data['id'],
        email: data['email'],
        username: data['username'],
        roles: List<String>.from(data['roles'] ?? []),
        geo: data['geo'],
      );
      print('User fetched successfully: ${member?.username}');
      return member;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    } finally {
      isLoading = false;
    }
  }
}
