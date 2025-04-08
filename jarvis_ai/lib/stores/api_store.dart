import 'package:flutter/material.dart';
import 'package:jarvis_ai/pages/login_page.dart';
import 'package:jarvis_ai/services/jarvis_service.dart';
import 'package:mobx/mobx.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
part 'api_store.g.dart';

class ApiStore = _ApiStore with _$ApiStore;

abstract class _ApiStore with Store {
  late final ApiService apiService;
  late final AuthService authService;
  late final JarvisService jarvisService;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  ApiStore get asApiStore => this as ApiStore;

  @action
  void initServices(GlobalKey<NavigatorState> navigatorKey) {
    apiService = ApiService(
      baseUrl: 'https://auth-api.dev.jarvis.cx',
      onUnauthorized: () {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage(apiStore: this as ApiStore,)),
          (route) => false,
        );
      },
    );
    authService = AuthService(apiService: apiService);
    jarvisService = JarvisService();
  }
}
