import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jarvis_ai/models/user.dart';
import 'package:mobx/mobx.dart';
import 'package:jarvis_ai/services/api_service.dart';
part 'auth_service.g.dart';

class AuthService = _AuthService with _$AuthService;

abstract class _AuthService with Store {
  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  _AuthService({required ApiService apiService}) : _apiService = apiService {
    _loadUserData();
  }

  @observable
  bool isLoading = false;

  @observable
  UserModel? currentUser;

  @observable
  String? accessToken;

  @observable
  DateTime? tokenExpiryTime;
  @action
  Future<bool> login({required String email, required String password}) async {
    isLoading = true;
    try {
      final response = await _apiService.post(
        '/api/v1/auth/password/sign-in',
        body: {'email': email, 'password': password},
      );
      print('$response');
      currentUser = UserModel.fromJson(response);
      accessToken = currentUser?.accessToken;
      tokenExpiryTime = DateTime.now().add(Duration(hours: 1));
      print('Login successful! User ID: ${currentUser?.userId}');
      await _saveUserData();
      return true;
    } catch (e) {
      print('Failed to login: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> _saveUserData() async {
    if (currentUser != null) {
      final userJson = jsonEncode(currentUser!.toJson());
      await _secureStorage.write(key: 'user', value: userJson);
    }
  }

  Future<void> _loadUserData() async {
    String? userJson = await _secureStorage.read(key: 'user');

    if (userJson != null) {
      currentUser = UserModel.fromJson(jsonDecode(userJson));
      accessToken = currentUser?.accessToken;
      tokenExpiryTime = DateTime.now().add(
        Duration(hours: 1),
      ); // Assuming token expiration

      _startAutoRefresh(); // Start auto-refresh if token exists
    }
  }

  void _startAutoRefresh() {
    if (tokenExpiryTime != null) {
      final duration =
          tokenExpiryTime!.difference(DateTime.now()).inSeconds - 60;
      if (duration > 0) {
        Future.delayed(Duration(seconds: duration), _refreshToken);
      } else {
        _refreshToken();
      }
    }
  }

  @action
  Future<bool> signup({required String email, required String password}) async {
    isLoading = true;
    try {
      final response = await _apiService.post(
        '/api/v1/auth/password/sign-up',
        body: {
          'email': email,
          'password': password,
          'verification_callback_url':
              'https://auth.dev.jarvis.cx/handler/email-verification?after_auth_return_to=%2Fauth%2Fsignin%3Fclient_id%3Djarvis_chat%26redirect%3Dhttps%253A%252F%252Fchat.dev.jarvis.cx%252Fauth%252Foauth%252Fsuccess',
        },
      );
      print('Signup response: $response');
      currentUser = UserModel.fromJson(response);
      return true;
    } catch (e) {
      print('Failed to signup: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> logout() async {
    isLoading = false;
    try {
      await _apiService.delete('/api/v1/auth/sessions/current', body: {});
      await _secureStorage.delete(key: 'user');
      currentUser = null;
      accessToken = null;
      tokenExpiryTime = null;

      print('Logout successful!');
    } catch (e) {
      print('Logout failed: $e');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> _refreshToken() async {
    if (currentUser == null || currentUser!.refreshToken.isEmpty) {
      print('No refresh token available');
      return false;
    }
    isLoading = true;
    try {
      final response = await _apiService.post(
        '/api/v1/auth/sessions/current/refresh',
        body: {},
        headers: {'X-Stack-Refresh-Token': currentUser!.refreshToken},
      );
      print('Refresh Token response: $response');
      if (response.containsKey('access_token')) {
        currentUser = UserModel(
          userId: currentUser!.userId,
          accessToken: response['access_token'],
          refreshToken: response['refresh_token'] ?? currentUser!.refreshToken,
        );
        print('Token refreshed successfully!');
        return true;
      } else {
        print('Failed to refresh token.');
        return false;
      }
    } catch (e) {
      print('Failed to refresh token: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }
}
