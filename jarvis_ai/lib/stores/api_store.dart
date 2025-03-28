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

  @action
  void initServices() {
    apiService = ApiService(baseUrl: 'https://auth-api.dev.jarvis.cx');
    authService = AuthService(apiService: apiService);
    jarvisService = JarvisService();
  }
}
