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

  late final _$isMessageLoadingAtom =
      Atom(name: '_KBService.isMessageLoading', context: context);

  @override
  bool get isMessageLoading {
    _$isMessageLoadingAtom.reportRead();
    return super.isMessageLoading;
  }

  @override
  set isMessageLoading(bool value) {
    _$isMessageLoadingAtom.reportWrite(value, super.isMessageLoading, () {
      super.isMessageLoading = value;
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

  late final _$hasMoreKnowledgeBasesAtom =
      Atom(name: '_KBService.hasMoreKnowledgeBases', context: context);

  @override
  bool get hasMoreKnowledgeBases {
    _$hasMoreKnowledgeBasesAtom.reportRead();
    return super.hasMoreKnowledgeBases;
  }

  @override
  set hasMoreKnowledgeBases(bool value) {
    _$hasMoreKnowledgeBasesAtom.reportWrite(value, super.hasMoreKnowledgeBases,
        () {
      super.hasMoreKnowledgeBases = value;
    });
  }

  late final _$knowledgeBasePageAtom =
      Atom(name: '_KBService.knowledgeBasePage', context: context);

  @override
  int get knowledgeBasePage {
    _$knowledgeBasePageAtom.reportRead();
    return super.knowledgeBasePage;
  }

  @override
  set knowledgeBasePage(int value) {
    _$knowledgeBasePageAtom.reportWrite(value, super.knowledgeBasePage, () {
      super.knowledgeBasePage = value;
    });
  }

  late final _$knowledgeBasesAtom =
      Atom(name: '_KBService.knowledgeBases', context: context);

  @override
  ObservableList<KnowledgeBase> get knowledgeBases {
    _$knowledgeBasesAtom.reportRead();
    return super.knowledgeBases;
  }

  @override
  set knowledgeBases(ObservableList<KnowledgeBase> value) {
    _$knowledgeBasesAtom.reportWrite(value, super.knowledgeBases, () {
      super.knowledgeBases = value;
    });
  }

  late final _$messagesAtom =
      Atom(name: '_KBService.messages', context: context);

  @override
  ObservableList<ThreadMessage> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(ObservableList<ThreadMessage> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  late final _$globalKnowledgeBasesAtom =
      Atom(name: '_KBService.globalKnowledgeBases', context: context);

  @override
  ObservableList<KnowledgeBase> get globalKnowledgeBases {
    _$globalKnowledgeBasesAtom.reportRead();
    return super.globalKnowledgeBases;
  }

  @override
  set globalKnowledgeBases(ObservableList<KnowledgeBase> value) {
    _$globalKnowledgeBasesAtom.reportWrite(value, super.globalKnowledgeBases,
        () {
      super.globalKnowledgeBases = value;
    });
  }

  late final _$hasMoreGlobalKnowledgeBasesAtom =
      Atom(name: '_KBService.hasMoreGlobalKnowledgeBases', context: context);

  @override
  bool get hasMoreGlobalKnowledgeBases {
    _$hasMoreGlobalKnowledgeBasesAtom.reportRead();
    return super.hasMoreGlobalKnowledgeBases;
  }

  @override
  set hasMoreGlobalKnowledgeBases(bool value) {
    _$hasMoreGlobalKnowledgeBasesAtom
        .reportWrite(value, super.hasMoreGlobalKnowledgeBases, () {
      super.hasMoreGlobalKnowledgeBases = value;
    });
  }

  late final _$globalKnowledgeBasePageAtom =
      Atom(name: '_KBService.globalKnowledgeBasePage', context: context);

  @override
  int get globalKnowledgeBasePage {
    _$globalKnowledgeBasePageAtom.reportRead();
    return super.globalKnowledgeBasePage;
  }

  @override
  set globalKnowledgeBasePage(int value) {
    _$globalKnowledgeBasePageAtom
        .reportWrite(value, super.globalKnowledgeBasePage, () {
      super.globalKnowledgeBasePage = value;
    });
  }

  late final _$unitsAtom = Atom(name: '_KBService.units', context: context);

  @override
  ObservableList<Unit> get units {
    _$unitsAtom.reportRead();
    return super.units;
  }

  @override
  set units(ObservableList<Unit> value) {
    _$unitsAtom.reportWrite(value, super.units, () {
      super.units = value;
    });
  }

  late final _$unitsPageAtom =
      Atom(name: '_KBService.unitsPage', context: context);

  @override
  int get unitsPage {
    _$unitsPageAtom.reportRead();
    return super.unitsPage;
  }

  @override
  set unitsPage(int value) {
    _$unitsPageAtom.reportWrite(value, super.unitsPage, () {
      super.unitsPage = value;
    });
  }

  late final _$hasMoreUnitsAtom =
      Atom(name: '_KBService.hasMoreUnits', context: context);

  @override
  bool get hasMoreUnits {
    _$hasMoreUnitsAtom.reportRead();
    return super.hasMoreUnits;
  }

  @override
  set hasMoreUnits(bool value) {
    _$hasMoreUnitsAtom.reportWrite(value, super.hasMoreUnits, () {
      super.hasMoreUnits = value;
    });
  }

  late final _$isUnitLoadingAtom =
      Atom(name: '_KBService.isUnitLoading', context: context);

  @override
  bool get isUnitLoading {
    _$isUnitLoadingAtom.reportRead();
    return super.isUnitLoading;
  }

  @override
  set isUnitLoading(bool value) {
    _$isUnitLoadingAtom.reportWrite(value, super.isUnitLoading, () {
      super.isUnitLoading = value;
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

  late final _$removeKnowledgeBaseFromBotAsyncAction =
      AsyncAction('_KBService.removeKnowledgeBaseFromBot', context: context);

  @override
  Future<bool> removeKnowledgeBaseFromBot(
      {required String assistantId, required String knowledgeId}) {
    return _$removeKnowledgeBaseFromBotAsyncAction.run(() => super
        .removeKnowledgeBaseFromBot(
            assistantId: assistantId, knowledgeId: knowledgeId));
  }

  late final _$createKnowledgeBaseAsyncAction =
      AsyncAction('_KBService.createKnowledgeBase', context: context);

  @override
  Future<KnowledgeBase?> createKnowledgeBase(
      {required String name, String? description}) {
    return _$createKnowledgeBaseAsyncAction.run(
        () => super.createKnowledgeBase(name: name, description: description));
  }

  late final _$uploadFileCreateBotAsyncAction =
      AsyncAction('_KBService.uploadFileCreateBot', context: context);

  @override
  Future<AssistantDetail?> uploadFileCreateBot(
      {required String assistantName,
      required String description,
      required String instructions,
      required List<PlatformFile> files}) {
    return _$uploadFileCreateBotAsyncAction.run(() => super.uploadFileCreateBot(
        assistantName: assistantName,
        description: description,
        instructions: instructions,
        files: files));
  }

  late final _$uploadFileToKnowledgeBaseAsyncAction =
      AsyncAction('_KBService.uploadFileToKnowledgeBase', context: context);

  @override
  Future<Unit?> uploadFileToKnowledgeBase(
      {required String knowledgeId, required List<PlatformFile> files}) {
    return _$uploadFileToKnowledgeBaseAsyncAction.run(() => super
        .uploadFileToKnowledgeBase(knowledgeId: knowledgeId, files: files));
  }

  late final _$deleteUnitAsyncAction =
      AsyncAction('_KBService.deleteUnit', context: context);

  @override
  Future<bool> deleteUnit(
      {required String knowledgeId, required String unitId}) {
    return _$deleteUnitAsyncAction
        .run(() => super.deleteUnit(knowledgeId: knowledgeId, unitId: unitId));
  }

  late final _$updateStatusUnitAsyncAction =
      AsyncAction('_KBService.updateStatusUnit', context: context);

  @override
  Future<Unit?> updateStatusUnit(
      {required String unitId, required bool status}) {
    return _$updateStatusUnitAsyncAction
        .run(() => super.updateStatusUnit(unitId: unitId, status: status));
  }

  late final _$uploadWebToKnowledgeBaseAsyncAction =
      AsyncAction('_KBService.uploadWebToKnowledgeBase', context: context);

  @override
  Future<Unit?> uploadWebToKnowledgeBase(
      {required String knowledgeId,
      required String unitName,
      required String webUrl}) {
    return _$uploadWebToKnowledgeBaseAsyncAction.run(() => super
        .uploadWebToKnowledgeBase(
            knowledgeId: knowledgeId, unitName: unitName, webUrl: webUrl));
  }

  late final _$getKnowledgeBasesAsyncAction =
      AsyncAction('_KBService.getKnowledgeBases', context: context);

  @override
  Future<void> getKnowledgeBases(
      {required String assistantId,
      int limit = 5,
      int offset = 0,
      String? search = '',
      String order = 'DESC',
      String orderField = 'createdAt',
      bool refresh = false}) {
    return _$getKnowledgeBasesAsyncAction.run(() => super.getKnowledgeBases(
        assistantId: assistantId,
        limit: limit,
        offset: offset,
        search: search,
        order: order,
        orderField: orderField,
        refresh: refresh));
  }

  late final _$loadMoreKnowledgeBasesAsyncAction =
      AsyncAction('_KBService.loadMoreKnowledgeBases', context: context);

  @override
  Future<void> loadMoreKnowledgeBases({required String assistantId}) {
    return _$loadMoreKnowledgeBasesAsyncAction
        .run(() => super.loadMoreKnowledgeBases(assistantId: assistantId));
  }

  late final _$getThreadMessagesAsyncAction =
      AsyncAction('_KBService.getThreadMessages', context: context);

  @override
  Future<void> getThreadMessages(
      {required String threadId, bool refresh = false}) {
    return _$getThreadMessagesAsyncAction.run(
        () => super.getThreadMessages(threadId: threadId, refresh: refresh));
  }

  late final _$sendMessageAsyncAction =
      AsyncAction('_KBService.sendMessage', context: context);

  @override
  Future<void> sendMessage(
      {required String assistantId,
      required String threadId,
      required String message,
      String additionalInstruction = ''}) {
    return _$sendMessageAsyncAction.run(() => super.sendMessage(
        assistantId: assistantId,
        threadId: threadId,
        message: message,
        additionalInstruction: additionalInstruction));
  }

  late final _$getKnowledgeUnitsAsyncAction =
      AsyncAction('_KBService.getKnowledgeUnits', context: context);

  @override
  Future<void> getKnowledgeUnits(
      {required String knowledgeId,
      String? search = '',
      String order = 'DESC',
      String orderField = 'createdAt',
      int limit = 20,
      int offset = 0,
      bool refresh = false}) {
    return _$getKnowledgeUnitsAsyncAction.run(() => super.getKnowledgeUnits(
        knowledgeId: knowledgeId,
        search: search,
        order: order,
        orderField: orderField,
        limit: limit,
        offset: offset,
        refresh: refresh));
  }

  late final _$loadMoreKnowledgeUnitsAsyncAction =
      AsyncAction('_KBService.loadMoreKnowledgeUnits', context: context);

  @override
  Future<void> loadMoreKnowledgeUnits({required String id}) {
    return _$loadMoreKnowledgeUnitsAsyncAction
        .run(() => super.loadMoreKnowledgeUnits(id: id));
  }

  late final _$getGlobalKnowledgeBasesAsyncAction =
      AsyncAction('_KBService.getGlobalKnowledgeBases', context: context);

  @override
  Future<void> getGlobalKnowledgeBases(
      {int limit = 20,
      int offset = 0,
      String? search = '',
      String order = 'DESC',
      String orderField = 'createdAt',
      bool refresh = false}) {
    return _$getGlobalKnowledgeBasesAsyncAction.run(() => super
        .getGlobalKnowledgeBases(
            limit: limit,
            offset: offset,
            search: search,
            order: order,
            orderField: orderField,
            refresh: refresh));
  }

  late final _$loadMoreGlobalKnowledgeBasesAsyncAction =
      AsyncAction('_KBService.loadMoreGlobalKnowledgeBases', context: context);

  @override
  Future<void> loadMoreGlobalKnowledgeBases() {
    return _$loadMoreGlobalKnowledgeBasesAsyncAction
        .run(() => super.loadMoreGlobalKnowledgeBases());
  }

  late final _$attachKnowledgeBaseAsyncAction =
      AsyncAction('_KBService.attachKnowledgeBase', context: context);

  @override
  Future<bool> attachKnowledgeBase(
      {required String assistantId, required String knowledgeId}) {
    return _$attachKnowledgeBaseAsyncAction.run(() => super.attachKnowledgeBase(
        assistantId: assistantId, knowledgeId: knowledgeId));
  }

  late final _$updateInstructionAssistantAsyncAction =
      AsyncAction('_KBService.updateInstructionAssistant', context: context);

  @override
  Future<AssistantDetail?> updateInstructionAssistant(
      {required String assistantId,
      required String instructions,
      required String assistantName}) {
    return _$updateInstructionAssistantAsyncAction.run(() => super
        .updateInstructionAssistant(
            assistantId: assistantId,
            instructions: instructions,
            assistantName: assistantName));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isMessageLoading: ${isMessageLoading},
hasMoreAssistants: ${hasMoreAssistants},
assistantSearchQuery: ${assistantSearchQuery},
currentPage: ${currentPage},
assistants: ${assistants},
hasMoreKnowledgeBases: ${hasMoreKnowledgeBases},
knowledgeBasePage: ${knowledgeBasePage},
knowledgeBases: ${knowledgeBases},
messages: ${messages},
globalKnowledgeBases: ${globalKnowledgeBases},
hasMoreGlobalKnowledgeBases: ${hasMoreGlobalKnowledgeBases},
globalKnowledgeBasePage: ${globalKnowledgeBasePage},
units: ${units},
unitsPage: ${unitsPage},
hasMoreUnits: ${hasMoreUnits},
isUnitLoading: ${isUnitLoading}
    ''';
  }
}
