import 'package:flutter/material.dart';
import 'package:jarvis_ai/pages/ai_bot_create.dart';
import 'package:jarvis_ai/pages/ai_bots_managing.dart';
import 'package:jarvis_ai/pages/ai_message_page.dart';
import 'package:jarvis_ai/pages/ai_preview_page.dart';
import 'package:jarvis_ai/pages/ai_subscribtion_page.dart';
import 'package:jarvis_ai/pages/home_page.dart';
import 'package:jarvis_ai/pages/login_page.dart';
import 'package:jarvis_ai/pages/messages_page.dart';
import 'package:jarvis_ai/pages/profile_page.dart';
import 'package:jarvis_ai/pages/prompt_create._page.dart';
import 'package:jarvis_ai/pages/prompt_managing_page.dart';
import 'package:jarvis_ai/pages/signup_page.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:provider/provider.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(
    RouteSettings settings,
    ApiStore apiStore,
  ) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage(apiStore: apiStore));
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage(apiStore: apiStore));
      case '/signup':
        return MaterialPageRoute(
          builder: (_) => SignupPage(apiStore: apiStore),
        );
      case '/messages':
        return MaterialPageRoute(
          builder: (_) => MessagesPage(apiStore: apiStore),
        );
      case '/chat':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:
              (_) => AIMessagePage(
                apiStore: apiStore,
                assistantId: args?['assistantId'] as String?,
              ),
        );
      case '/bots':
        return MaterialPageRoute(
          builder: (_) => AiBotsManagingPage(apiStore: apiStore),
        );
      case '/create-bot':
        return MaterialPageRoute(
          builder: (_) => AIBotCreatePageWidget(apiStore: apiStore),
        );
      case '/prompts':
        return MaterialPageRoute(
          builder: (_) => PromptManagingPage(apiStore: apiStore),
        );
      case '/create-prompt':
        return MaterialPageRoute(
          builder: (_) => PromptCreatingPage(apiStore: apiStore),
        );
      case '/profile':
        return MaterialPageRoute(
          builder: (_) => ProfilePage(apiStore: apiStore),
        );
      case '/premium':
        return MaterialPageRoute(
          builder: (_) => const AISubscribtionPageWidget(),
        );
      case '/preview':
        return MaterialPageRoute(
          builder: (_) => PreviewpageWidget(apiStore: apiStore),
        );
      default:
        return MaterialPageRoute(builder: (_) => LoginPage(apiStore: apiStore));
    }
  }
}
