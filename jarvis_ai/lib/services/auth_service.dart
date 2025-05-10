import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jarvis_ai/models/user.dart';
import 'package:jarvis_ai/services/exceptions/api_exception.dart';
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
        headers: {
          'Content-Type': 'application/json',
          'X-Stack-Access-Type': 'client',
          'X-Stack-Publishable-Client-Key':
              'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
          'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
        },
      );
      print('$response');
      currentUser = UserModel.fromJson(response);
      accessToken = currentUser?.accessToken;
      tokenExpiryTime = DateTime.now().add(Duration(minutes: 5));
      print('Login successful! User ID: ${currentUser?.userId}');
      await _saveUserData();
      return true;
    } on ApiException catch (e) {
      // Don't wrap the exception again, just rethrow
      rethrow;
    } catch (e) {
      throw ApiException('An unexpected error occurred during signup', 0, {
        'rawError': e.toString(),
      });
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
        Duration(minutes: 5),
      );

      _startAutoRefresh();
    }
  }

  Future<UserModel?> getUser() async {
    String? userJson = await _secureStorage.read(key: 'user');
    if (userJson == null) {
      print('No access token found. User needs to log in.');
      return null;
    }
    UserModel user = UserModel.fromJson(jsonDecode(userJson));
    return user;
  }

  void _startAutoRefresh() {
    if (tokenExpiryTime != null) {
      final duration =
          tokenExpiryTime!.difference(DateTime.now()).inSeconds - 60;
      if (duration > 0) {
        Future.delayed(Duration(seconds: duration), refreshToken);
      } else {
        refreshToken();
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
        headers: {
          'Content-Type': 'application/json',
          'X-Stack-Access-Type': 'client',
          'X-Stack-Publishable-Client-Key':
              'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
          'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
        },
      );
      print('Signup response: $response');
      currentUser = UserModel.fromJson(response);
      accessToken = currentUser?.accessToken;
      tokenExpiryTime = DateTime.now().add(Duration(minutes: 5));
      await _saveUserData();
      return true;
    } on ApiException catch (e) {
      // Don't wrap the exception again, just rethrow
      rethrow;
    } catch (e) {
      throw ApiException('An unexpected error occurred during signup', 0, {
        'rawError': e.toString(),
      });
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> logout() async {
    isLoading = false;
    try {
      final user = await getUser();
      await _apiService.delete(
        '/api/v1/auth/sessions/current',
        body: {},
        headers: {
          'Content-Type': 'application/json',
          'X-Stack-Access-Type': 'client',
          'X-Stack-Publishable-Client-Key':
              'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
          'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
          if (user != null) 'X-Stack-Refresh-Token': '${user.refreshToken}',
          if (user != null) 'Authorization': 'Bearer ${user.accessToken}',
        },
      );
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
  Future<bool> refreshToken() async {
    if (currentUser == null || currentUser!.refreshToken.isEmpty) {
      print('No refresh token available');
      return false;
    }
    isLoading = true;
    try {
      final response = await _apiService.post(
        '/api/v1/auth/sessions/current/refresh',
        body: {},
        headers: {
          'X-Stack-Refresh-Token': currentUser!.refreshToken,
          'Content-Type': 'application/json',
          'X-Stack-Access-Type': 'client',
          'X-Stack-Publishable-Client-Key':
              'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
          'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
        },
      );
      print('Refresh Token response: $response');
      if (response.containsKey('access_token')) {
        currentUser = UserModel(
          userId: currentUser!.userId,
          accessToken: response['access_token'],
          refreshToken: currentUser!.refreshToken,
        );
        print('Token refreshed successfully!');
        await _saveUserData();
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
