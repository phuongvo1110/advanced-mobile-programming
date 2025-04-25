// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kb_service.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$KBService on _KBService, Store {
  late final _$isLoadingAtom =
      Atom(name: '_KBService.isLoading', context: context);

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

  late final _$hasMoreAssistantsAtom =
      Atom(name: '_KBService.hasMoreAssistants', context: context);

  @override
  bool get hasMoreAssistants {
    _$hasMoreAssistantsAtom.reportRead();
    return super.hasMoreAssistants;
  }

  @override
  set hasMoreAssistants(bool value) {
    _$hasMoreAssistantsAtom.reportWrite(value, super.hasMoreAssistants, () {
      super.hasMoreAssistants = value;
    });
  }

  late final _$assistantSearchQueryAtom =
      Atom(name: '_KBService.assistantSearchQuery', context: context);

  @override
  String? get assistantSearchQuery {
    _$assistantSearchQueryAtom.reportRead();
    return super.assistantSearchQuery;
  }

  @override
  set assistantSearchQuery(String? value) {
    _$assistantSearchQueryAtom.reportWrite(value, super.assistantSearchQuery,
        () {
      super.assistantSearchQuery = value;
    });
  }

  late final _$currentPageAtom =
      Atom(name: '_KBService.currentPage', context: context);

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

  late final _$assistantsAtom =
      Atom(name: '_KBService.assistants', context: context);

  @override
  ObservableList<AssistantDetail> get assistants {
    _$assistantsAtom.reportRead();
    return super.assistants;
  }

  @override
  set assistants(ObservableList<AssistantDetail> value) {
    _$assistantsAtom.reportWrite(value, super.assistants, () {
      super.assistants = value;
    });
  }

  late final _$getUserAsyncAction =
      AsyncAction('_KBService.getUser', context: context);

  @override
  Future<UserModel?> getUser() {
    return _$getUserAsyncAction.run(() => super.getUser());
  }

  late final _$getAssistantsAsyncAction =
      AsyncAction('_KBService.getAssistants', context: context);

  @override
  Future<void> getAssistants(
      {int limit = 20,
      int offset = 0,
      String? search = '',
      String? order = 'ASC',
      String? order_field = 'createdAt',
      bool isFavorite = false,
      bool isPublished = false,
      bool refresh = false}) {
    return _$getAssistantsAsyncAction.run(() => super.getAssistants(
        limit: limit,
        offset: offset,
        search: search,
        order: order,
        order_field: order_field,
        isFavorite: isFavorite,
        isPublished: isPublished,
        refresh: refresh));
  }

  late final _$getAssistantByIdAsyncAction =
      AsyncAction('_KBService.getAssistantById', context: context);

  @override
  Future<AssistantDetail?> getAssistantById({required String id}) {
    return _$getAssistantByIdAsyncAction
        .run(() => super.getAssistantById(id: id));
  }

  late final _$loadMoreAssistantsAsyncAction =
      AsyncAction('_KBService.loadMoreAssistants', context: context);

  @override
  Future<void> loadMoreAssistants() {
    return _$loadMoreAssistantsAsyncAction
        .run(() => super.loadMoreAssistants());
  }

  late final _$createAssistantAsyncAction =
      AsyncAction('_KBService.createAssistant', context: context);

  @override
  Future<AssistantDetail?> createAssistant(
      {required String assistantName,
      required String instructions,
      required String description}) {
    return _$createAssistantAsyncAction.run(() => super.createAssistant(
        assistantName: assistantName,
        instructions: instructions,
        description: description));
  }

  late final _$updateAssistantAsyncAction =
      AsyncAction('_KBService.updateAssistant', context: context);

  @override
  Future<AssistantDetail?> updateAssistant(
      {required String assistantId,
      required String assistantName,
      required String instructions,
      required String description}) {
    return _$updateAssistantAsyncAction.run(() => super.updateAssistant(
        assistantId: assistantId,
        assistantName: assistantName,
        instructions: instructions,
        description: description));
  }

  late final _$deleteAssistantAsyncAction =
      AsyncAction('_KBService.deleteAssistant', context: context);

  @override
  Future<bool> deleteAssistant({required String id}) {
    return _$deleteAssistantAsyncAction
        .run(() => super.deleteAssistant(id: id));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
hasMoreAssistants: ${hasMoreAssistants},
assistantSearchQuery: ${assistantSearchQuery},
currentPage: ${currentPage},
assistants: ${assistants}
    ''';
  }
}
