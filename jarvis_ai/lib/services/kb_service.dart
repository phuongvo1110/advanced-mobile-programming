import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:jarvis_ai/models/assistant.dart';
import 'package:jarvis_ai/models/knowledgebase.dart';
import 'package:jarvis_ai/models/thread_message.dart';
import 'package:jarvis_ai/models/user.dart';
import 'package:jarvis_ai/services/api_service.dart';
import 'package:jarvis_ai/services/exceptions/api_exception.dart';
import 'package:jarvis_ai/theme/flutter_flow_util.dart' as Platform;
import 'package:mime/mime.dart';
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
  bool isMessageLoading = false;
  @observable
  bool hasMoreAssistants = true;
  @observable
  String? assistantSearchQuery;
  @observable
  int currentPage = 0;
  @observable
  ObservableList<AssistantDetail> assistants =
      ObservableList<AssistantDetail>();
  @observable
  bool hasMoreKnowledgeBases = true;
  @observable
  int knowledgeBasePage = 0;
  @observable
  ObservableList<KnowledgeBase> knowledgeBases =
      ObservableList<KnowledgeBase>();
  @observable
  ObservableList<ThreadMessage> messages = ObservableList<ThreadMessage>();
  @observable
  ObservableList<KnowledgeBase> globalKnowledgeBases =
      ObservableList<KnowledgeBase>();
  @observable
  bool hasMoreGlobalKnowledgeBases = true;
  @observable
  int globalKnowledgeBasePage = 0;
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

  // @action
  // Future<dynamic> uploadFileCreateBot({
  //   required String assistantName,
  //   required String description,
  //   required String instructions,
  //   required List<PlatformFile> files,
  // }) async {
  //   try {
  //     final user = await getUser();
  //     final request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(
  //         'https://knowledge-api.dev.jarvis.cx/kb-core/v1/ai-assistant/knowledge/local-file',
  //       ),
  //     );
  //     request.headers.addAll({
  //       'Authorization': 'Bearer ${user!.accessToken}',
  //       'priority': 'u=1, i',
  //       'Content-Type': 'multipart/form-data',
  //     });
  //     request.fields['assistantName'] = assistantName;
  //     request.fields['description'] = description;
  //     request.fields['instructions'] = instructions;

  //     for (final file in files) {
  //       print('Processing file: name=${file.name}, path=${file.path}, bytes=${file.bytes?.length}, size=${file.size}');
  //       if (file.path != null && !Platform.isWeb) {
  //         final multipartFile = await http.MultipartFile.fromPath(
  //           'files',
  //           file.path!,
  //           filename: file.name,
  //         );
  //         request.files.add(multipartFile);
  //         print('Added file from path: ${file.path}');
  //       } else if (file.bytes != null) {
  //         final multipartFile = http.MultipartFile.fromBytes(
  //           'files',
  //           file.bytes!,
  //           filename: file.name,
  //         );
  //         request.files.add(multipartFile);
  //         print('Added file from bytes: ${file.name}');
  //       } else {
  //         throw Exception('File ${file.name} has no path or bytes');
  //       }
  //     }
  //     final response = await request.send();
  //     final responseBody = await response.stream.bytesToString();
  //     print(
  //       'Upload file response: $responseBody (status: ${response.statusCode})',
  //     );

  //     if (response.statusCode >= 200 && response.statusCode < 300) {
  //       return response;
  //     } else {
  //       throw ApiException(
  //         'Failed to upload file: ${response.reasonPhrase}',
  //         response.statusCode,
  //         {'body': responseBody},
  //       );
  //     }
  //   } catch (e) {
  //     if (e is ApiException && e.statusCode == 401) rethrow;
  //     print('Error uploading file: $e');
  //     return null;
  //   }
  // }
  @action
  Future<bool> uploadFileCreateBot({
    required String assistantName,
    required String description,
    required String instructions,
    required List<PlatformFile> files,
  }) async {
    try {
      if (files.isEmpty) {
        throw Exception('No files provided for upload');
      }

      final user = await getUser();
      final dioClient = dio.Dio();
      final formData = dio.FormData();

      // Add form fields
      formData.fields.addAll([
        MapEntry('assistantName', assistantName),
        MapEntry('description', description),
        MapEntry('instructions', instructions),
      ]);

      // Add files
      for (final file in files) {
        print(
          'Processing file: name=${file.name}, path=${file.path}, bytes=${file.bytes?.length}, size=${file.size}',
        );
        // Validate file type
        final fileExtension = file.name.split('.').last.toLowerCase();
        if (!['docx', 'pdf', 'txt'].contains(fileExtension)) {
          throw Exception('Unsupported file type: ${file.name}');
        }
        // Validate file size (e.g., < 10MB)
        if (file.size > 10 * 1024 * 1024) {
          throw Exception('File ${file.name} exceeds 10MB limit');
        }
        if (file.path != null && !Platform.isWeb) {
          // Non-web platforms: use file path
          final fileObj = File(file.path!);
          if (!await fileObj.exists()) {
            throw Exception('File ${file.name} does not exist at ${file.path}');
          }
          final fileLength = await fileObj.length();
          print('File exists: true, length: $fileLength');
          final mimeType =
              lookupMimeType(file.name) ?? 'application/octet-stream';
          formData.files.add(
            MapEntry(
              'files',
              await dio.MultipartFile.fromFile(
                file.path!,
                filename: file.name,
                contentType: http_parser.MediaType.parse(mimeType),
              ),
            ),
          );
          print('Added file from path: ${file.path}, MIME: $mimeType');
        } else if (file.bytes != null) {
          // Web platform
          final mimeType =
              lookupMimeType(file.name) ?? 'application/octet-stream';
          formData.files.add(
            MapEntry(
              'files',
              dio.MultipartFile.fromBytes(
                file.bytes!,
                filename: file.name,
                contentType: http_parser.MediaType.parse(mimeType),
              ),
            ),
          );
          print('Added file from bytes: ${file.name}, MIME: $mimeType');
        } else {
          throw Exception('File ${file.name} has no path or bytes');
        }
      }

      // Log form data
      print('Form fields: ${formData.fields}');
      print(
        'Form files: ${formData.files.map((f) => f.value.filename).toList()}',
      );

      // Log authorization token
      print('Authorization token: ${user!.accessToken}');

      // Send request
      final response = await dioClient.post(
        'https://knowledge-api.dev.jarvis.cx/kb-core/v1/ai-assistant/knowledge/local-file',
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer ${user!.accessToken}',
            'priority': 'u=1, i',
          },
        ),
      );

      print(
        'Upload file response: ${response.data} (status: ${response.statusCode})',
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return true;
      } else {
        throw ApiException(
          'Failed to upload file: ${response.statusMessage}',
          response.statusCode!,
          {'body': response.data},
        );
      }
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
      print('Error uploading file: $e');
      return false;
    }
  }

  @action
  Future<void> getKnowledgeBases({
    required String assistantId,
    int limit = 5,
    int offset = 0,
    String? search = '',
    String order = 'DESC',
    String orderField = 'createdAt',
    bool refresh = false,
  }) async {
    if (refresh) {
      knowledgeBases.clear();
      knowledgeBasePage = 0;
      hasMoreKnowledgeBases = true;
    }
    if (!hasMoreKnowledgeBases) return;

    runInAction(() {
      isLoading = true;
    });

    try {
      UserModel? user = await getUser();
      final params = {
        'q': search ?? '',
        'order': order,
        'order_field': orderField,
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      final queryString = Uri(queryParameters: params).query;
      print('KnowledgeBase QueryString: $queryString');
      final data = await _apiService.get(
        '/kb-core/v1/ai-assistant/$assistantId/knowledges?$queryString',
        headers: {
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
      );
      print('KnowledgeBase Data: $data');
      final List<KnowledgeBase> newKnowledgeBases =
          (data['data'] as List)
              .map((item) => KnowledgeBase.fromJson(item))
              .toList();
      if (refresh) knowledgeBases.clear();
      knowledgeBases.addAll(newKnowledgeBases);
      final meta = data['meta'];
      hasMoreKnowledgeBases = meta['hasNext'] ?? false;
      knowledgeBasePage++;
    } catch (e) {
      print('Error fetching knowledge bases: $e');
      if (e is ApiException && e.statusCode == 401) rethrow;
    } finally {
      runInAction(() {
        isLoading = false;
      });
    }
  }

  @action
  Future<void> loadMoreKnowledgeBases({required String assistantId}) async {
    if (!hasMoreKnowledgeBases || isLoading) return;
    await getKnowledgeBases(
      assistantId: assistantId,
      offset: knowledgeBasePage * 5,
    );
  }

  @action
  Future<void> getThreadMessages({
    required String threadId,
    bool refresh = false,
  }) async {
    if (refresh) {
      messages.clear();
    }

    runInAction(() {
      isLoading = true;
    });

    try {
      UserModel? user = await getUser();
      final data = await _apiService.get(
        '/kb-core/v1/ai-assistant/thread/$threadId/messages',
        headers: {
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
      );
      print('Thread Messages Data: $data');
      final List<ThreadMessage> newMessages =
          (data as List).map((item) => ThreadMessage.fromJson(item)).toList();
      if (refresh) messages.clear();
      messages.addAll(newMessages);
      messages = ObservableList.of(messages.reversed);
    } catch (e) {
      print('Error fetching thread messages: $e');
      if (e is ApiException && e.statusCode == 401) rethrow;
    } finally {
      runInAction(() {
        isLoading = false;
      });
    }
  }

  @action
  Future<void> sendMessage({
    required String assistantId,
    required String threadId,
    required String message,
    String additionalInstruction = '',
  }) async {
    runInAction(() {
      isMessageLoading = true;
    });

    try {
      UserModel? user = await getUser();
      final requestBody = {
        'message': message,
        'openAiThreadId': threadId,
        'additionalInstruction': additionalInstruction,
      };
      print('Send Message Body: $requestBody');

      final response = await _apiService.post(
        '/kb-core/v1/ai-assistant/$assistantId/ask',
        headers: {
          'Content-Type': 'application/json',
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
        body: requestBody,
      );
      print('Send Message Response: $response');

      // Handle plain text response as assistant message
      if (response is String) {
        final assistantMessage = ThreadMessage(
          role: 'assistant',
          createdAt: (DateTime.now().millisecondsSinceEpoch ~/ 1000),
          content: response,
        );
        messages.add(assistantMessage);
      }

      // Refresh messages to sync with server
      // await getThreadMessages(threadId: threadId, refresh: true);
    } catch (e) {
      print('Error sending message: $e');
      if (e is ApiException && e.statusCode == 401) rethrow;
      rethrow;
    } finally {
      runInAction(() {
        isMessageLoading = false;
      });
    }
  }

  @action
  Future<void> getGlobalKnowledgeBases({
    int limit = 20,
    int offset = 0,
    String? search = '',
    String order = 'DESC',
    String orderField = 'createdAt',
    bool refresh = false,
  }) async {
    if (refresh) {
      globalKnowledgeBases.clear();
      globalKnowledgeBasePage = 0;
      hasMoreGlobalKnowledgeBases = true;
    }
    if (!hasMoreGlobalKnowledgeBases) return;

    runInAction(() {
      isLoading = true;
    });

    try {
      UserModel? user = await getUser();
      final params = {
        'q': search ?? '',
        'order': order,
        'order_field': orderField,
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      final queryString = Uri(queryParameters: params).query;
      print('Global KnowledgeBase QueryString: $queryString');
      final data = await _apiService.get(
        '/kb-core/v1/knowledge?$queryString',
        headers: {
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
      );
      print('Global KnowledgeBase Data: $data');
      final List<KnowledgeBase> newKnowledgeBases =
          (data['data'] as List)
              .map((item) => KnowledgeBase.fromJson(item))
              .toList();
      if (refresh) globalKnowledgeBases.clear();
      globalKnowledgeBases.addAll(newKnowledgeBases);
      final meta = data['meta'];
      hasMoreGlobalKnowledgeBases = meta['hasNext'] ?? false;
      globalKnowledgeBasePage++;
    } catch (e) {
      print('Error fetching global knowledge bases: $e');
      if (e is ApiException && e.statusCode == 401) rethrow;
    } finally {
      runInAction(() {
        isLoading = false;
      });
    }
  }

  @action
  Future<void> loadMoreGlobalKnowledgeBases() async {
    if (!hasMoreGlobalKnowledgeBases || isLoading) return;
    await getGlobalKnowledgeBases(offset: globalKnowledgeBasePage * 20);
  }

  @action
  Future<bool> attachKnowledgeBase({
    required String assistantId,
    required String knowledgeId,
  }) async {
    try {
      final user = await getUser();
      final response = await _apiService.post(
        '/kb-core/v1/ai-assistant/$assistantId/knowledges/$knowledgeId',
        headers: {
          'Content-Type': 'application/json',
          'x-jarvis-guid': '',
          'Authorization': 'Bearer ${user!.accessToken}',
        },
        body: {},
      );
      print('Attach KnowledgeBase Response: $response');
      return true;
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
      print('Error attaching knowledge base: $e');
      return false;
    }
  }
  @action
  Future<AssistantDetail?> updateInstructionAssistant({
    required String assistantId,
    required String instructions,
  }) async {
    try {
      final user = await getUser();

      final requestBody = {
        'instructions': instructions,
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
      print('Update Instruction Response: $response');
      return AssistantDetail.fromJson(response);
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) rethrow;
      
      print('Error updating instruction: $e');
    }
  }
}
