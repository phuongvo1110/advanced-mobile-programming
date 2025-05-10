import 'package:flutter/material.dart';
import 'package:jarvis_ai/pages/login_page.dart';
import 'package:jarvis_ai/services/jarvis_service.dart';
import 'package:jarvis_ai/services/kb_service.dart';
import 'package:mobx/mobx.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
part 'api_store.g.dart';

class ApiStore = _ApiStore with _$ApiStore;

abstract class _ApiStore with Store {
  late final ApiService apiService;
  late final AuthService authService;
  late final JarvisService jarvisService;
  late final KBService kbService;
  late GlobalKey<NavigatorState> _navigatorKey;
  ApiStore get asApiStore => this as ApiStore;

  @action
  void initServices(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
    apiService = ApiService(
      baseUrl: 'https://auth-api.dev.jarvis.cx',
      onUnauthorized: _handleUnauthorized,
      authService: null, // Will be set later
    );
    authService = AuthService(apiService: apiService);
    apiService.authService = authService;
    jarvisService = JarvisService(
      apiService: ApiService(
        baseUrl: 'https://api.dev.jarvis.cx',
        onUnauthorized: _handleUnauthorized,
        authService: authService
      ),
    );
    kbService = KBService(
      apiService: ApiService(
        baseUrl: 'https://knowledge-api.dev.jarvis.cx',
        onUnauthorized: _handleUnauthorized,
        authService: authService
      ),
    );
  }

  Future<void> _handleUnauthorized() async {
    try {
      print('Handling unauthorized access');
      // await const FlutterSecureStorage().delete(key: 'user');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_navigatorKey.currentState == null) {
          print('Navigator state is null - cannot navigate');
          return;
        }

        print('Navigating to login page');
        _navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => LoginPage(apiStore: this as ApiStore),
          ),
          (route) => false,
        );
      });
    } catch (e) {
      print('Error in _handleUnauthorized: $e');
    }
  }
}
