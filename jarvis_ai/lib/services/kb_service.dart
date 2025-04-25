import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jarvis_ai/models/assistant.dart';
import 'package:jarvis_ai/models/user.dart';
import 'package:jarvis_ai/services/api_service.dart';
import 'package:jarvis_ai/services/exceptions/api_exception.dart';
import 'package:mobx/mobx.dart';

part 'kb_service.g.dart';

class KBService = _KBService with _$KBService;

abstract class _KBService with Store {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final ApiService _apiService;

  _KBService({required ApiService apiService}) : _apiService = apiService;
  @observable
  bool isLoading = false;
  @observable
  bool hasMoreAssistants = true;
  @observable
  String? assistantSearchQuery;
  @observable
  int currentPage = 0;
  @observable
  ObservableList<AssistantDetail> assistants = ObservableList<AssistantDetail>();
  @action
  Future<UserModel?> getUser() async {
    String? userJson = await _secureStorage.read(key: 'user');
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  @action
  Future<void> getAssistants({
    int limit = 20,
    int offset = 0,
    String? search = '',
    String? order = 'ASC',
    String? order_field = 'createdAt',
    bool isFavorite = false,
    bool isPublished = false,
    bool refresh = false,
  }) async {
    if (refresh) {
      assistants.clear();
      currentPage = 0;
      hasMoreAssistants = true;
    }
    if (!hasMoreAssistants) return;

    runInAction(() {
      isLoading = true;
    });

    try {
      UserModel? user = await getUser();
      isLoading = true;

      final params = {
        'q': search,
        'order': order,
        'order_field': order_field,
        'limit': limit.toString(),
        'offset': offset.toString(),
        'is_favorite': isFavorite.toString(),
        'is_published': isPublished.toString(),
      };

      final queryString = Uri(queryParameters: params).query;
      print('QueryString: $queryString');
      final data = await _apiService.get(
        '/kb-core/v1/ai-assistant?$queryString',
        headers: {
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
      );
      print('Data: $data');
      final List<AssistantDetail> newAssistants =
          (data['data'] as List)
              .map((item) => AssistantDetail.fromJson(item))
              .toList();
      if (refresh) assistants.clear();
      assistants.addAll(newAssistants);
      final meta = data['meta'];
      hasMoreAssistants = meta['hasNext'] ?? false;
      currentPage++;
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
    } finally {
      runInAction(() {
        isLoading = false;
      });
    }
  }

  @action
  Future<AssistantDetail?> getAssistantById({required String id}) async {
    runInAction(() {
      isLoading = true;
    });
    try {
      UserModel? user = await getUser();
      isLoading = true;
      final data = await _apiService.get(
        '/kb-core/v1/ai-assistant/$id',
        headers: {
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
      );
      return AssistantDetail.fromJson(data);
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
    } finally {
      runInAction(() {
        isLoading = false;
      });
    }
  }

  @action
  Future<void> loadMoreAssistants() async {
    if (!hasMoreAssistants || isLoading) return;
    await getAssistants(offset: currentPage * 20, search: assistantSearchQuery);
  }

  // Add this to your KBService class
  @action
  Future<AssistantDetail?> createAssistant({
    required String assistantName,
    required String instructions,
    required String description,
  }) async {
    try {
      final user = await getUser();

      final requestBody = {
        'assistantName': assistantName,
        'instructions': instructions,
        'description': description,
      };
      print('$requestBody');
      final response = await _apiService.post(
        '/kb-core/v1/ai-assistant',
        headers: {
          'Content-Type': 'application/json',
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
        body: requestBody,
      );
      print('REsponse: $response');
      return AssistantDetail.fromJson(response);
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
    }
  }

  // Add this to your KBService class
  @action
  Future<AssistantDetail?> updateAssistant({
    required String assistantId,
    required String assistantName,
    required String instructions,
    required String description,
  }) async {
    try {
      final user = await getUser();

      final requestBody = {
        'assistantName': assistantName,
        'instructions': instructions,
        'description': description,
      };

      final response = await _apiService.patch(
        '/kb-core/v1/ai-assistant/$assistantId',
        headers: {
          'Content-Type': 'application/json',
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
        body: requestBody,
      );

      return AssistantDetail.fromJson(response);
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
    }
  }

  @action
  Future<bool> deleteAssistant({required String id}) async {
    try {
      final user = await getUser();
      final response = await _apiService.delete(
        '/kb-core/v1/ai-assistant/${id}',
        body: {},
        headers: {
          'Content-Type': 'application/json',
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
      );
      final index = assistants.indexWhere((p) => p.id == id);
      if (index != -1) assistants.removeAt(index);
      return true;
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
      print('Error deleting prompt: $e');
      return false;
    } finally {
      runInAction(() {
        isLoading = false;
      });
    }
  }
}
