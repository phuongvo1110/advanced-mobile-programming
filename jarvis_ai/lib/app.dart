import 'package:flutter/material.dart';
import 'package:jarvis_ai/routes.dart';

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
    return MaterialApp(
      title: 'Jarvis AI',
      navigatorKey: navigatorKey, // Assign the navigator key
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
