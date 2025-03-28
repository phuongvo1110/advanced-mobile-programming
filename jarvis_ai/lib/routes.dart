import 'package:flutter/material.dart';
import 'package:jarvis_ai/pages/ai_bot_create.dart';
import 'package:jarvis_ai/pages/ai_bots_managing.dart';
import 'package:jarvis_ai/pages/ai_message_page.dart';
import 'package:jarvis_ai/pages/ai_subscribtion_page.dart';
import 'package:jarvis_ai/pages/home_page.dart';
import 'package:jarvis_ai/pages/login_page.dart';
import 'package:jarvis_ai/pages/messages_page.dart';
import 'package:jarvis_ai/pages/profile_page.dart';
import 'package:jarvis_ai/pages/prompt_create._page.dart';
import 'package:jarvis_ai/pages/prompt_managing_page.dart';
import 'package:jarvis_ai/pages/signup_page.dart';
import 'package:jarvis_ai/stores/api_store.dart';
final apiStore = ApiStore()..initServices();
class AppRoutes {
  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage(apiStore: apiStore));
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage(apiStore: apiStore));
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignupPage(apiStore: apiStore));
      case '/messages':
        return MaterialPageRoute(builder: (_) => const MessagesPage());
      case '/chat':
        return MaterialPageRoute(builder: (_) => const AIMessagePage());
      case '/bots':
        return MaterialPageRoute(builder: (_) => const AiBotsManagingPage());
      case '/create-bot':
        return MaterialPageRoute(builder: (_) => const AIBotCreatePageWidget());
      case '/prompts':
        return MaterialPageRoute(builder: (_) => const PromptManagingPage());
      case '/create-prompt':
        return MaterialPageRoute(builder: (_) => const PromptCreatingPage());
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfilePage(apiStore: apiStore));
      case '/premium':
        return MaterialPageRoute(
          builder: (_) => const AISubscribtionPageWidget(),
        );
      default:
        return MaterialPageRoute(builder: (_) => LoginPage(apiStore: apiStore));
    }
  }
}
