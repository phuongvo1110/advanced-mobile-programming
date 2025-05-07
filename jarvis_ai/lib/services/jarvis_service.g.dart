// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jarvis_service.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$JarvisService on _JarvisService, Store {
  late final _$isLoadingAtom =
      Atom(name: '_JarvisService.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$memberAtom =
      Atom(name: '_JarvisService.member', context: context);

  @override
  Member? get member {
    _$memberAtom.reportRead();
    return super.member;
  }

  @override
  set member(Member? value) {
    _$memberAtom.reportWrite(value, super.member, () {
      super.member = value;
    });
  }

  late final _$promptsAtom =
      Atom(name: '_JarvisService.prompts', context: context);

  @override
  ObservableList<Prompt> get prompts {
    _$promptsAtom.reportRead();
    return super.prompts;
  }

  @override
  set prompts(ObservableList<Prompt> value) {
    _$promptsAtom.reportWrite(value, super.prompts, () {
      super.prompts = value;
    });
  }

  late final _$conversationsAtom =
      Atom(name: '_JarvisService.conversations', context: context);

  @override
  ObservableList<Conversation> get conversations {
    _$conversationsAtom.reportRead();
    return super.conversations;
  }

  @override
  set conversations(ObservableList<Conversation> value) {
    _$conversationsAtom.reportWrite(value, super.conversations, () {
      super.conversations = value;
    });
  }

  late final _$currentPageAtom =
      Atom(name: '_JarvisService.currentPage', context: context);

  @override
  int get currentPage {
    _$currentPageAtom.reportRead();
    return super.currentPage;
  }

  @override
  set currentPage(int value) {
    _$currentPageAtom.reportWrite(value, super.currentPage, () {
      super.currentPage = value;
    });
  }

  late final _$hasMorePromptsAtom =
      Atom(name: '_JarvisService.hasMorePrompts', context: context);

  @override
  bool get hasMorePrompts {
    _$hasMorePromptsAtom.reportRead();
    return super.hasMorePrompts;
  }

  @override
  set hasMorePrompts(bool value) {
    _$hasMorePromptsAtom.reportWrite(value, super.hasMorePrompts, () {
      super.hasMorePrompts = value;
    });
  }

  late final _$hasMoreConversationsAtom =
      Atom(name: '_JarvisService.hasMoreConversations', context: context);

  @override
  bool get hasMoreConversations {
    _$hasMoreConversationsAtom.reportRead();
    return super.hasMoreConversations;
  }

  @override
  set hasMoreConversations(bool value) {
    _$hasMoreConversationsAtom.reportWrite(value, super.hasMoreConversations,
        () {
      super.hasMoreConversations = value;
    });
  }

  late final _$promptSearchQueryAtom =
      Atom(name: '_JarvisService.promptSearchQuery', context: context);

  @override
  String? get promptSearchQuery {
    _$promptSearchQueryAtom.reportRead();
    return super.promptSearchQuery;
  }

  @override
  set promptSearchQuery(String? value) {
    _$promptSearchQueryAtom.reportWrite(value, super.promptSearchQuery, () {
      super.promptSearchQuery = value;
    });
  }

  late final _$isUserTokenLoadingAtom =
      Atom(name: '_JarvisService.isUserTokenLoading', context: context);

  @override
  bool get isUserTokenLoading {
    _$isUserTokenLoadingAtom.reportRead();
    return super.isUserTokenLoading;
  }

  @override
  set isUserTokenLoading(bool value) {
    _$isUserTokenLoadingAtom.reportWrite(value, super.isUserTokenLoading, () {
      super.isUserTokenLoading = value;
    });
  }

  late final _$getUserTokenAsyncAction =
      AsyncAction('_JarvisService.getUserToken', context: context);

  @override
  Future<UserToken?> getUserToken() {
    return _$getUserTokenAsyncAction.run(() => super.getUserToken());
  }

  late final _$getCurrentUserAsyncAction =
      AsyncAction('_JarvisService.getCurrentUser', context: context);

  @override
  Future<Member?> getCurrentUser() {
    return _$getCurrentUserAsyncAction.run(() => super.getCurrentUser());
  }

  late final _$getPromptsAsyncAction =
      AsyncAction('_JarvisService.getPrompts', context: context);

  @override
  Future<void> getPrompts(
      {int limit = 20,
      int offset = 0,
      String? search,
      String? category,
      bool? isPublic,
      bool? isFavorite,
      bool refresh = false}) {
    return _$getPromptsAsyncAction.run(() => super.getPrompts(
        limit: limit,
        offset: offset,
        search: search,
        category: category,
        isPublic: isPublic,
        isFavorite: isFavorite,
        refresh: refresh));
  }

  late final _$toggleFavoriteAsyncAction =
      AsyncAction('_JarvisService.toggleFavorite', context: context);

  @override
  Future<void> toggleFavorite(String id) {
    return _$toggleFavoriteAsyncAction.run(() => super.toggleFavorite(id));
  }

  late final _$createPromptAsyncAction =
      AsyncAction('_JarvisService.createPrompt', context: context);

  @override
  Future<Prompt> createPrompt(
      {required String title,
      required String content,
      String? description,
      required bool isPublic,
      String? category,
      String? language}) {
    return _$createPromptAsyncAction.run(() => super.createPrompt(
        title: title,
        content: content,
        description: description,
        isPublic: isPublic,
        category: category,
        language: language));
  }

  late final _$updatePromptAsyncAction =
      AsyncAction('_JarvisService.updatePrompt', context: context);

  @override
  Future<Prompt?> updatePrompt(
      {required String id,
      required String title,
      required String content,
      String? description,
      required bool isPublic,
      String? category}) {
    return _$updatePromptAsyncAction.run(() => super.updatePrompt(
        id: id,
        title: title,
        content: content,
        description: description,
        isPublic: isPublic,
        category: category));
  }

  late final _$deletePromptAsyncAction =
      AsyncAction('_JarvisService.deletePrompt', context: context);

  @override
  Future<bool> deletePrompt(String id) {
    return _$deletePromptAsyncAction.run(() => super.deletePrompt(id));
  }

  late final _$loadMorePromptsAsyncAction =
      AsyncAction('_JarvisService.loadMorePrompts', context: context);

  @override
  Future<void> loadMorePrompts() {
    return _$loadMorePromptsAsyncAction.run(() => super.loadMorePrompts());
  }

  late final _$refreshPromptsAsyncAction =
      AsyncAction('_JarvisService.refreshPrompts', context: context);

  @override
  Future<void> refreshPrompts() {
    return _$refreshPromptsAsyncAction.run(() => super.refreshPrompts());
  }

  late final _$getConversationsAsyncAction =
      AsyncAction('_JarvisService.getConversations', context: context);

  @override
  Future<void> getConversations(
      {String? cursor,
      int? limit,
      String assistanId = 'gpt-4o-mini',
      String assistantModel = 'dify',
      bool refresh = false}) {
    return _$getConversationsAsyncAction.run(() => super.getConversations(
        cursor: cursor,
        limit: limit,
        assistanId: assistanId,
        assistantModel: assistantModel,
        refresh: refresh));
  }

  late final _$getConversationHistoryAsyncAction =
      AsyncAction('_JarvisService.getConversationHistory', context: context);

  @override
  Future<List<MessageQuery>?> getConversationHistory(
      {required String conversationId,
      String assistantModel = 'dify',
      required String assistantId,
      int limit = 20,
      String cursor = ''}) {
    return _$getConversationHistoryAsyncAction.run(() => super
        .getConversationHistory(
            conversationId: conversationId,
            assistantModel: assistantModel,
            assistantId: assistantId,
            limit: limit,
            cursor: cursor));
  }

  late final _$requestSignedUrlAsyncAction =
      AsyncAction('_JarvisService.requestSignedUrl', context: context);

  @override
  Future<dynamic> requestSignedUrl(
      {required String filename, required String mimetype}) {
    return _$requestSignedUrlAsyncAction.run(
        () => super.requestSignedUrl(filename: filename, mimetype: mimetype));
  }

  late final _$uploadFileToSignedUrlAsyncAction =
      AsyncAction('_JarvisService.uploadFileToSignedUrl', context: context);

  @override
  Future<bool> uploadFileToSignedUrl(
      {required String signedUrl,
      required PlatformFile file,
      required String mimetype}) {
    return _$uploadFileToSignedUrlAsyncAction.run(() => super
        .uploadFileToSignedUrl(
            signedUrl: signedUrl, file: file, mimetype: mimetype));
  }

  late final _$notifyUploadSuccessAsyncAction =
      AsyncAction('_JarvisService.notifyUploadSuccess', context: context);

  @override
  Future<dynamic> notifyUploadSuccess(
      {required String filename, required String mimetype}) {
    return _$notifyUploadSuccessAsyncAction.run(() =>
        super.notifyUploadSuccess(filename: filename, mimetype: mimetype));
  }

  late final _$sendMessageAsyncAction =
      AsyncAction('_JarvisService.sendMessage', context: context);

  @override
  Future<MessageResponse?> sendMessage(
      {required String content,
      required Assistant assistant,
      List<String> files = const [],
      List<Map<String, dynamic>> conversationHistory = const [],
      String? conversationId}) {
    return _$sendMessageAsyncAction.run(() => super.sendMessage(
        content: content,
        assistant: assistant,
        files: files,
        conversationHistory: conversationHistory,
        conversationId: conversationId));
  }

  late final _$getUserAsyncAction =
      AsyncAction('_JarvisService.getUser', context: context);

  @override
  Future<UserModel?> getUser() {
    return _$getUserAsyncAction.run(() => super.getUser());
  }

  late final _$getUsageAsyncAction =
      AsyncAction('_JarvisService.getUsage', context: context);

  @override
  Future<Token?> getUsage() {
    return _$getUsageAsyncAction.run(() => super.getUsage());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
member: ${member},
prompts: ${prompts},
conversations: ${conversations},
currentPage: ${currentPage},
hasMorePrompts: ${hasMorePrompts},
hasMoreConversations: ${hasMoreConversations},
promptSearchQuery: ${promptSearchQuery},
isUserTokenLoading: ${isUserTokenLoading}
    ''';
  }
}
