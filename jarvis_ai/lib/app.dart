import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jarvis_ai/routes.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Method to access the state from anywhere
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late final ApiStore _apiStore;
  @override
  void initState() {
    super.initState();
    _apiStore = ApiStore()..initServices(navigatorKey);
  }

  String getCurrentRoute() {
    final context = navigatorKey.currentContext;
    return context != null ? ModalRoute.of(context)?.settings.name ?? '' : '';
  }

  List<String> getCurrentRouteStack() {
    // Implement stack tracking logic if needed
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ApiStore>.value(
      value: _apiStore,
      child: MaterialApp(
        title: 'Jarvis AI',
        navigatorKey: navigatorKey,
        initialRoute: '/login',
        onGenerateRoute: AppRoutes.generateRoute,
        builder: (context, child) {
          return Observer(
            builder: (context) {
              // Any global reactions to store changes can go here
              return child!;
            },
          );
        },
      ),
    );
  }
}
