import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jarvis_ai/models/member.dart';
import 'package:jarvis_ai/models/prompt.dart';
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
  @observable
  ObservableList<Prompt> prompts = ObservableList<Prompt>();
  @observable
  int currentPage = 0;
  @observable
  bool hasMorePrompts = true;
  @observable
  String? promptSearchQuery;
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
    if (!hasMorePrompts) {
      return;
    }
    isLoading = true;
    try {
      String? userJson = await _secureStorage.read(key: 'user');
      if (userJson == null) throw Exception('User not logged in');

      UserModel user = UserModel.fromJson(jsonDecode(userJson));
      final params = {
        'limit': limit.toString(),
        'offset': offset.toString(),
        if (search != null && search.isNotEmpty) 'query': search,
        if (category != null) 'category': category,
        if (isPublic != null) 'isPublic': isPublic.toString(),
        if (isFavorite != null) 'isFavorite': isFavorite.toString(),
      };
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/prompts').replace(queryParameters: params),
        headers: {
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user.accessToken}',
        },
      );
      print('${response.body}');
      final data = jsonDecode(response.body);
      final List<Prompt> newPrompts =
          (data['items'] as List).map((item) => Prompt.fromJson(item)).toList();
      if (refresh) {
        prompts.clear();
      }
      prompts.addAll(newPrompts);
      hasMorePrompts = data['hasNext'] ?? false;
      currentPage++;
    } catch (e) {
      print('Error fetching prompts: $e');
      rethrow;
    } finally {
      isLoading = false;
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
        print(response.body);
        final index = prompts.indexWhere((prompt) => prompt.id == id);
        if (index != -1) {
          final oldPrompt = prompts[index];
          final newPrompt = Prompt(
            id: oldPrompt.id,
            title: oldPrompt.title,
            description: oldPrompt.description,
            isPublic: oldPrompt.isPublic,
            isFavorite: !oldPrompt.isFavorite!,
            createdAt: oldPrompt.createdAt,
            updatedAt: oldPrompt.updatedAt,
            content: oldPrompt.content,
            userId: oldPrompt.userId,
            userName: oldPrompt.userName,
          );
          prompts[index] = newPrompt;
        }
      }
    } catch (e) {
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
      isLoading = true;
      if (title.trim().isEmpty) {
        throw Exception('Title is required');
      }
      if (content.trim().isEmpty) {
        throw Exception('Content is required');
      }

      // Prepare the request body
      final requestBody = {
        'title': title.trim(),
        'content': content.trim(),
        'isPublic': isPublic,
        if (description != null && description.trim().isNotEmpty)
          'description': description.trim(),
        if (category != null && category.trim().isNotEmpty)
          'category': category.trim().toLowerCase(),
      };

      print('Request body: $requestBody');

      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/prompts'),
        headers: {
          'Content-Type': 'application/json',
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user?.accessToken}',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final newPrompt = Prompt.fromJson(data);
        print('New Prompt $newPrompt');
        return newPrompt;
      } else {
        throw Exception('Failed to create prompt: ${response.body}');
      }
    } catch (e) {
      print('Error creating prompt: $e');
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<Prompt?> updatePrompt(Prompt updatePrompt) async {
    try {
      isLoading = true;
      final user = await getUser();
      if (user == null) throw Exception('User not logged in');
      final requestBody = {
        'title': updatePrompt.title.trim(),
        'content': updatePrompt.content.trim(),
        'isPublic': updatePrompt.isPublic,
        if (updatePrompt.description != null &&
            updatePrompt.description!.trim().isNotEmpty)
          'description': updatePrompt.description!.trim(),
        if (updatePrompt.category != null &&
            updatePrompt.category!.trim().isNotEmpty)
          'category': updatePrompt.category!.trim().toLowerCase(),
      };
      final response = await http.patch(
        Uri.parse('$baseUrl/api/v1/prompts/${updatePrompt.id}'),
        headers: {
          'Content-Type': 'application/json',
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user.accessToken}',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updatedPrompt = Prompt.fromJson(data);

        final index = prompts.indexWhere((p) => p.id == updatePrompt.id);
        if (index != -1) {
          prompts[index] = updatedPrompt;
        }
        return updatedPrompt;
      } else {
        throw Exception('Failed to update prompt: ${response.body}');
      }
    } catch (e) {
      print('Error updating prompt: $e');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> deletePrompt(String id) async {
    try {
      isLoading = true;
      final user = await getUser();
      if (user == null) throw Exception('User not logged in');
      final response = await http.delete(
        Uri.parse('$baseUrl/api/v1/prompts/${id}'),
        headers: {
          'Content-Type': 'application/json',
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user.accessToken}',
        },
      );
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        final index = prompts.indexWhere((p) => p.id == id);
        if (index != -1) {
          prompts.removeAt(index);
        }
        return true;
      } else
        return false;
    } catch (e) {
      print('Error deleting prompt: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<UserModel?> getUser() async {
    String? userJson = await _secureStorage.read(key: 'user');
    if (userJson == null) {
      print('No access token found. User needs to log in.');
      return null;
    }
    UserModel user = UserModel.fromJson(jsonDecode(userJson));
    return user;
  }
}
