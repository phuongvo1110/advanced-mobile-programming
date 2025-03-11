import 'package:flutter/material.dart';
import 'package:jarvis_ai/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jarvis AI',
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
