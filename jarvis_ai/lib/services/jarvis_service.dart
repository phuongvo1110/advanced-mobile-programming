// Updated JarvisService using apiService methods
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis_ai/models/conversation.dart';
import 'package:jarvis_ai/models/member.dart';
import 'package:jarvis_ai/models/prompt.dart';
import 'package:jarvis_ai/models/query_message.dart';
import 'package:jarvis_ai/models/token.dart';
import 'package:jarvis_ai/models/user.dart';
import 'package:jarvis_ai/services/api_service.dart';
import 'package:jarvis_ai/services/exceptions/api_exception.dart';
import 'package:mobx/mobx.dart';

part 'jarvis_service.g.dart';

class MessageResponse {
  final String? message;
  final num? remainingUsage;

  MessageResponse({this.message, this.remainingUsage});

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      message: json['message'] as String?,
      remainingUsage: json['remainingUsage'] as num,
    );
  }
}

class JarvisService = _JarvisService with _$JarvisService;

abstract class _JarvisService with Store {
  final String baseUrl = 'https://api.dev.jarvis.cx';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final ApiService _apiService;

  _JarvisService({required ApiService apiService}) : _apiService = apiService;
  @observable
  bool isLoading = false;

  @observable
  Member? member;

  @observable
  ObservableList<Prompt> prompts = ObservableList<Prompt>();
  @observable
  ObservableList<Conversation> conversations = ObservableList<Conversation>();

  @observable
  int currentPage = 0;

  @observable
  bool hasMorePrompts = true;
  @observable
  bool hasMoreConversations = true;
  @observable
  String? promptSearchQuery;

  @action
  Future<Member?> getCurrentUser() async {
    runInAction(() {
      isLoading = true;
    });
    try {
      UserModel? user = await getUser();

      final data = await _apiService.get(
        '/api/v1/auth/me',
        headers: {
          'Content-Type': 'application/json',
          'X-Stack-Access-Type': 'client',
          'X-Stack-Publishable-Client-Key':
              'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
          'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
      );

      member = Member(
        id: data['id'],
        email: data['email'],
        username: data['username'],
        roles: List<String>.from(data['roles'] ?? []),
        geo: data['geo'],
      );

      return member;
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
      print('Error fetching user: $e');
      return null;
    } finally {
      runInAction(() {
        isLoading = false;
      });
    }
  }

  @action
  Future<void> getPrompts({
    int limit = 20,
    int offset = 0,
    String? search,
    String? category,
    bool? isPublic,
    bool? isFavorite,
    bool refresh = false,
  }) async {
    if (refresh) {
      prompts.clear();
      currentPage = 0;
      hasMorePrompts = true;
    }
    if (!hasMorePrompts) return;

    runInAction(() {
      isLoading = true;
    });
    try {
      UserModel? user = await getUser();

      final params = {
        'limit': limit.toString(),
        'offset': offset.toString(),
        if (search != null && search.isNotEmpty) 'query': search,
        if (category != null) 'category': category,
        if (isPublic != null) 'isPublic': isPublic.toString(),
        if (isFavorite != null) 'isFavorite': isFavorite.toString(),
      };

      final queryString = Uri(queryParameters: params).query;
      print('QueryString: $queryString');
      final data = await _apiService.get(
        '/api/v1/prompts?$queryString',
        headers: {
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
      );
      print('Data: $data');
      final List<Prompt> newPrompts =
          (data['items'] as List).map((item) => Prompt.fromJson(item)).toList();

      if (refresh) prompts.clear();
      prompts.addAll(newPrompts);
      hasMorePrompts = data['hasNext'] ?? false;
      currentPage++;
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
      print('Error fetching prompts: $e');
      rethrow;
    } finally {
      runInAction(() {
        isLoading = false;
      });
    }
  }

  @action
  Future<void> toggleFavorite(String id) async {
    try {
      UserModel? user = await getUser();
      Prompt prompt = prompts.firstWhere((x) => x.id == id);
      if (prompt.isFavorite != null) {
        final response =
            !prompt.isFavorite!
                ? await http.post(
                  Uri.parse('$baseUrl/api/v1/prompts/${id}/favorite'),
                  headers: {
                    'x-jarvis-guid': '',
                    'Authorization': 'Bearer ${user?.accessToken}',
                  },
                  body: {},
                )
                : await http.delete(
                  Uri.parse('$baseUrl/api/v1/prompts/${id}/favorite'),
                  headers: {
                    'x-jarvis-guid': '',
                    'Authorization': 'Bearer ${user?.accessToken}',
                  },
                );
        if (response.statusCode == 401) {
          throw ApiException('Session expired', 401, {});
        }
        final index = prompts.indexWhere((prompt) => prompt.id == id);
        if (index != -1) {
          final oldPrompt = prompts[index];
          print('Old prompt: $oldPrompt');
          prompts[index] = oldPrompt.copyWith(
            isFavorite: !(oldPrompt.isFavorite ?? false),
          );
        }
      }
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) {
        // This will trigger the unauthorized handler in ApiService
        rethrow;
      }
      print('Error toggling favorite: $e');
      rethrow;
    }
  }

  @action
  Future<Prompt> createPrompt({
    required String title,
    required String content,
    String? description,
    required bool isPublic,
    String? category,
    String? language,
  }) async {
    try {
      UserModel? user = await getUser();
      runInAction(() {
        isLoading = true;
      });

      final requestBody = {
        'title': title.trim(),
        'content': content.trim(),
        'isPublic': isPublic,
        if (description != null && description.trim().isNotEmpty)
          'description': description.trim(),
        if (category != null && category.trim().isNotEmpty)
          'category': category.trim().toLowerCase(),
      };

      final data = await _apiService.post(
        '/api/v1/prompts',
        headers: {
          'Content-Type': 'application/json',
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user?.accessToken}',
        },
        body: requestBody,
      );

      return Prompt.fromJson(data);
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
      print('Error creating prompt: $e');
      rethrow;
    } finally {
      runInAction(() {
        isLoading = false;
      });
    }
  }

  @action
  Future<Prompt?> updatePrompt({
    required String id,
    required String title,
    required String content,
    String? description,
    required bool isPublic,
    String? category,
  }) async {
    try {
      runInAction(() {
        isLoading = true;
      });
      final user = await getUser();

      final requestBody = {
        'title': title.trim(),
        'content': content.trim(),
        'isPublic': isPublic,
        if (description != null && description.trim().isNotEmpty)
          'description': description.trim(),
        if (category != null && category.trim().isNotEmpty)
          'category': category.trim().toLowerCase(),
      };

      final data = await _apiService.patch(
        '/api/v1/prompts/${id}',
        headers: {
          'Content-Type': 'application/json',
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
        body: requestBody,
      );

      final updatedPrompt = Prompt.fromJson(data);
      final index = prompts.indexWhere((p) => p.id == id);
      if (index != -1) prompts[index] = updatedPrompt;
      return updatedPrompt;
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
      print('Error updating prompt: $e');
    } finally {
      runInAction(() {
        isLoading = false;
      });
    }
  }

  @action
  Future<bool> deletePrompt(String id) async {
    try {
      runInAction(() {
        isLoading = true;
      });
      final user = await getUser();

      await _apiService.delete(
        '/api/v1/prompts/$id',
        headers: {
          'Content-Type': 'application/json',
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
        body: {},
      );

      final index = prompts.indexWhere((p) => p.id == id);
      if (index != -1) prompts.removeAt(index);
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

  @action
  Future<void> loadMorePrompts() async {
    if (!hasMorePrompts || isLoading) return;
    await getPrompts(offset: currentPage * 20, search: promptSearchQuery);
  }

  @action
  Future<void> refreshPrompts() async {
    await getPrompts(refresh: true);
  }

  @action
  Future<void> getConversations({
    String? cursor,
    int? limit,
    String assistanId = 'gpt-4o-mini',
    String assistantModel = 'dify',
    bool refresh = false,
  }) async {
    if (refresh) {
      conversations.clear();
    }
    runInAction(() {
      isLoading = true;
    });
    try {
      final user = await getUser();
      final params = {
        if (cursor != null && cursor.isNotEmpty) 'cursor': cursor.toString(),
        if (limit != null) 'limit': limit.toString(),
        'assistantId': assistanId.toString(),
        'assistantModel': assistantModel.toString(),
      };

      final queryString = Uri(queryParameters: params).query;
      print('QueryString: $queryString');
      final response = await _apiService.get(
        '/api/v1/ai-chat/conversations?$queryString',
        headers: {
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
      );
      print('Conversations: $response');
      final List<Conversation> newConversations =
          (response['items'] as List)
              .map((item) => Conversation.fromJson(item))
              .toList();
      if (refresh) conversations.clear();
      conversations.addAll(newConversations);
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
      print('Error fetching prompts: $e');
      rethrow;
    } finally {
      runInAction(() {
        isLoading = false;
      });
    }
  }

  @action
  Future<List<MessageQuery>?> getConversationHistory({
    required String conversationId,
    String assistantModel = 'dify',
    required String assistantId,
    int limit = 20,
    String cursor = '',
  }) async {
    try {
      final user = await getUser();
      final params = {
        'limit': limit.toString(),
        'assistantId': assistantId,
        'cursor': cursor,
        'assistantModel': assistantModel,
      };
      final queryString = Uri(queryParameters: params).query;
      print('QueryString: $queryString');
      final response = await _apiService.get(
        '/api/v1/ai-chat/conversations/$conversationId/messages?$queryString',
        headers: {'Authorization': 'Bearer ${user!.accessToken}'},
      );
      print('Conversation history: $response');
      if (response == null || response['items'] == null) {
        return null;
      }
      return (response['items'] as List)
          .map((item) => MessageQuery.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching conversation history: $e');
      return null;
    }
  }

  @action
  Future<dynamic> requestSignedUrl({
    required String filename,
    required String mimetype,
  }) async {
    try {
      final user = await getUser();
      final requestBody = {'filename': filename, 'mimetype': mimetype};
      final response = await _apiService.post(
        '/api/v1/files/upload',
        body: requestBody,
        headers: {
          'Content-Type': 'application/json',
          'priority': 'u=1, i',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
      );
      if (response == null) {
        return null;
      }
      print('Response: $response');
      return response;
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
      print('Error fetching signed URL: $e');
      return null;
    }
  }

  @action
  Future<bool> uploadFileToSignedUrl({
    required String signedUrl,
    required PlatformFile file,
    required String mimetype,
  }) async {
    final headers = {
      'Content-Type': mimetype,
      'X-Goog-Content-Length-Range': '0,1073741824',
    };

    final response = await http.put(
      Uri.parse(signedUrl),
      headers: headers,
      body: file.bytes,
    );

    return response.statusCode == 200;
  }

  @action
  Future<dynamic> notifyUploadSuccess({
    required String filename,
    required String mimetype,
  }) async {
    try {
      final user = await getUser();
      final requestBody = {'filename': filename, 'mimetype': mimetype};
      final response = await _apiService.post(
        '/api/v1/files/upload/success',
        body: requestBody,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
      );
      if (response == null) {
        return null;
      }
      print('Response: $response');
      return response;
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
      print('Error notifying upload success: $e');
      return null;
    }
  }

  @action
  Future<MessageResponse?> sendMessage({
    required String content,
    required Assistant assistant,
    List<String> files = const [],
    List<Map<String, dynamic>> conversationHistory = const [],
    String? conversationId,
  }) async {
    try {
      final user = await getUser();
      final userMessage = Message(
        assistant: assistant,
        content: content,
        files: files,
        role: 'user',
      );
      final messages =
          conversationHistory.isEmpty
              ? [userMessage.toJson()]
              : [...conversationHistory, userMessage.toJson()];
      print('Messages: $messages');
      final requestBody = {
        'content': content,
        'files': files,
        'metadata': {
          'conversation': {
            if (conversationId != null) 'id': conversationId,
            'messages': messages,
          },
        },
        'assistant': assistant.toJson(),
      };
      print('Request body: $requestBody');

      final data = await _apiService.post(
        '/api/v1/ai-chat/messages',
        headers: {
          'Content-Type': 'application/json',
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
        body: requestBody,
      );
      return MessageResponse.fromJson(data);
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
      print('Error send message: $e');
      rethrow;
    }
  }

  @action
  Future<UserModel?> getUser() async {
    String? userJson = await _secureStorage.read(key: 'user');
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  @action
  Future<Token?> getUsage() async {
    try {
      final user = await getUser();

      final response = await _apiService.get(
        '/api/v1/tokens/usage',
        headers: {
          'Content-Type': 'application/json',
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
      );
      if (response == null) {
        return null;
      }
      return Token.fromJson(response);
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
      print('Error send message: $e');
    }
  }
}
