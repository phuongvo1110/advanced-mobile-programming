import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis_ai/models/user.dart';
import 'package:jarvis_ai/pages/login_page.dart';
import 'package:jarvis_ai/routes.dart';
import 'dart:convert';
import 'package:jarvis_ai/services/exceptions/api_exception.dart';
import 'package:jarvis_ai/services/auth_service.dart';

class ApiService {
  final String baseUrl;
  final VoidCallback onUnauthorized;
  AuthService? authService; // Nullable to handle initial null case, mutable for late assignment
  ApiService({
    required this.baseUrl,
    required this.onUnauthorized,
    this.authService,
  });
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Wrapper function to handle API calls with token refresh retry
  Future<dynamic> _makeApiCall(
    Future<http.Response> Function() apiCall,
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await apiCall();
      return _handleResponse(response, endpoint);
    } catch (e) {
      if (e is ApiException && e.statusCode == 401 && authService != null) {
        // Attempt to refresh token
        if (authService == null) {
          throw ApiException('AuthService is not initialized', 0, {});
        }
        final success = await authService!.refreshToken();
        if (success) {
          // Retry the original API call with the new token
          final response = await apiCall();
          return _handleResponse(response, endpoint);
        } else {
          _secureStorage.delete(key: 'user');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onUnauthorized();
          });
          throw ApiException('Session expired after refresh attempt', 401, {});
        }
      }
      if (e is ApiException) {
        rethrow; // Don't wrap ApiException again
      }
      throw ApiException(e.toString(), 0, {'rawError': e.toString()});
    }
  }

  Future<dynamic> post(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      print('$baseUrl$endpoint');
      return await _makeApiCall(
        () => http.post(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Content-Type': 'application/json',
            ...?headers,
            if (authService?.currentUser?.accessToken != null)
              'Authorization': 'Bearer ${authService!.currentUser!.accessToken}',
          },
          body: json.encode(body),
        ),
        endpoint,
        headers: headers,
        body: body,
      );
    } catch (e) {
      rethrow;
    }
  }

  Stream stream(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async* {
    try {
      final client = http.Client();
      final request = http.Request('POST', Uri.parse('$baseUrl$endpoint'))
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Accept': 'text/event-stream',
          ...?headers,
          if (authService?.currentUser?.accessToken != null)
            'Authorization': 'Bearer ${authService!.currentUser!.accessToken}',
        })
        ..body = json.encode(body);
      final response = await client.send(request);

      if (response.statusCode == 401 && authService != null) {
        if (authService == null) {
          throw ApiException('AuthService is not initialized', 0, {});
        }
        final success = await authService!.refreshToken();
        if (success) {
          // Retry the stream request
          request.headers['Authorization'] =
              'Bearer ${authService!.currentUser!.accessToken}';
          final retryResponse = await client.send(request);
          if (retryResponse.statusCode == 401) {
            _secureStorage.delete(key: 'user');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onUnauthorized();
            });
            throw ApiException('Session expired after refresh attempt', 401, {});
          } else if (retryResponse.statusCode < 200 ||
              retryResponse.statusCode >= 300) {
            throw ApiException(
              'Request failed with status ${retryResponse.statusCode}',
              retryResponse.statusCode,
              {},
            );
          }
          await for (var line in retryResponse.stream
              .transform(utf8.decoder)
              .transform(const LineSplitter())) {
            yield line;
          }
        } else {
          _secureStorage.delete(key: 'user');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onUnauthorized();
          });
          throw ApiException('Session expired after refresh attempt', 401, {});
        }
      } else if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          'Request failed with status ${response.statusCode}',
          response.statusCode,
          {},
        );
      }

      await for (var line in response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        yield line;
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(e.toString(), 0, {'rawError': e.toString()});
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      String? userJson = await _secureStorage.read(key: 'user');
      if (userJson == null) {
        print('No access token found. User needs to log in.');
        return null;
      }
      UserModel user = UserModel.fromJson(jsonDecode(userJson));
      return await _makeApiCall(
        () => http.delete(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Content-Type': 'application/json',
            ...?headers,
            'Authorization': 'Bearer ${user.accessToken}',
          },
          body: json.encode(body),
        ),
        endpoint,
        headers: headers,
        body: body,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      return await _makeApiCall(
        () => http.get(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            ...?headers,
            if (authService?.currentUser?.accessToken != null)
              'Authorization': 'Bearer ${authService!.currentUser!.accessToken}',
          },
        ),
        endpoint,
        headers: headers,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      return await _makeApiCall(
        () => http.put(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Content-Type': 'application/json',
            ...?headers,
            if (authService?.currentUser?.accessToken != null)
              'Authorization': 'Bearer ${authService!.currentUser!.accessToken}',
          },
          body: json.encode(body),
        ),
        endpoint,
        headers: headers,
        body: body,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> patch(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      return await _makeApiCall(
        () => http.patch(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Content-Type': 'application/json',
            ...?headers,
            if (authService?.currentUser?.accessToken != null)
              'Authorization': 'Bearer ${authService!.currentUser!.accessToken}',
          },
          body: json.encode(body),
        ),
        endpoint,
        headers: headers,
        body: body,
      );
    } catch (e) {
      rethrow;
    }
  }

  dynamic _handleResponse(http.Response response, String endpoint) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      if (endpoint.endsWith('/ask')) {
        try {
          return json.decode(response.body);
        } catch (e) {
          print('Plain text response detected: ${response.body}');
          return response.body;
        }
      }
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      // Let _makeApiCall handle the retry logic
      throw ApiException('Session expired', 401, {});
    } else {
      if (response.body.isEmpty) {
        throw ApiException(
          'Request failed with status ${response.statusCode}',
          response.statusCode,
          {},
        );
      }

      final responseData = json.decode(response.body);
      final errorData = responseData is Map ? responseData : {};
      final errorMessage =
          errorData['error']?.toString() ??
          errorData['message']?.toString() ??
          'Request failed with status ${response.statusCode}';

      throw ApiException(errorMessage, response.statusCode, errorData);
    }
  }
}