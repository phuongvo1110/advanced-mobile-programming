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

  late final _$getCurrentUserAsyncAction =
      AsyncAction('_JarvisService.getCurrentUser', context: context);

  @override
  Future<Member?> getCurrentUser() {
    return _$getCurrentUserAsyncAction.run(() => super.getCurrentUser());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
member: ${member}
    ''';
  }
}
