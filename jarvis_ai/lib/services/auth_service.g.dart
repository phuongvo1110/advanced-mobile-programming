// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthService on _AuthService, Store {
  late final _$isLoadingAtom =
      Atom(name: '_AuthService.isLoading', context: context);

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

  late final _$currentUserAtom =
      Atom(name: '_AuthService.currentUser', context: context);

  @override
  UserModel? get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(UserModel? value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  late final _$accessTokenAtom =
      Atom(name: '_AuthService.accessToken', context: context);

  @override
  String? get accessToken {
    _$accessTokenAtom.reportRead();
    return super.accessToken;
  }

  @override
  set accessToken(String? value) {
    _$accessTokenAtom.reportWrite(value, super.accessToken, () {
      super.accessToken = value;
    });
  }

  late final _$tokenExpiryTimeAtom =
      Atom(name: '_AuthService.tokenExpiryTime', context: context);

  @override
  DateTime? get tokenExpiryTime {
    _$tokenExpiryTimeAtom.reportRead();
    return super.tokenExpiryTime;
  }

  @override
  set tokenExpiryTime(DateTime? value) {
    _$tokenExpiryTimeAtom.reportWrite(value, super.tokenExpiryTime, () {
      super.tokenExpiryTime = value;
    });
  }

  late final _$loginAsyncAction =
      AsyncAction('_AuthService.login', context: context);

  @override
  Future<bool> login({required String email, required String password}) {
    return _$loginAsyncAction
        .run(() => super.login(email: email, password: password));
  }

  late final _$signupAsyncAction =
      AsyncAction('_AuthService.signup', context: context);

  @override
  Future<bool> signup({required String email, required String password}) {
    return _$signupAsyncAction
        .run(() => super.signup(email: email, password: password));
  }

  late final _$logoutAsyncAction =
      AsyncAction('_AuthService.logout', context: context);

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$_refreshTokenAsyncAction =
      AsyncAction('_AuthService._refreshToken', context: context);

  @override
  Future<bool> _refreshToken() {
    return _$_refreshTokenAsyncAction.run(() => super._refreshToken());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
currentUser: ${currentUser},
accessToken: ${accessToken},
tokenExpiryTime: ${tokenExpiryTime}
    ''';
  }
}
