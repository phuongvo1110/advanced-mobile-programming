import 'package:flutter/material.dart';
import 'package:jarvis_ai/pages/home_page.dart';
import 'package:jarvis_ai/pages/login_page.dart';
import 'package:jarvis_ai/pages/messages_page.dart';
import 'package:jarvis_ai/pages/signup_page.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case '/messages':
        return MaterialPageRoute(builder: (_) => const MessagesPage());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
