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

  late final _$getCurrentUserAsyncAction =
      AsyncAction('_JarvisService.getCurrentUser', context: context);

  @override
  Future<Member?> getCurrentUser() {
    return _$getCurrentUserAsyncAction.run(() => super.getCurrentUser());
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

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
member: ${member},
prompts: ${prompts},
currentPage: ${currentPage},
hasMorePrompts: ${hasMorePrompts},
promptSearchQuery: ${promptSearchQuery}
    ''';
  }
}
