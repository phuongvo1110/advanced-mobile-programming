import 'package:flutter/material.dart';
import 'package:jarvis_ai/pages/ai_bots_managing.dart';
import 'package:jarvis_ai/pages/ai_message_page.dart';
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
      case '/chat':
        return MaterialPageRoute(builder: (_) => const AIMessagePage());
      case '/bots':
        return MaterialPageRoute(builder: (_) => const AiBotsManagingPage());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
