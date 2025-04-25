// assistant.dart
class Assistant {
  final String? id;
  final String model;
  final String name;

  Assistant({this.id, required this.model, required this.name});

  factory Assistant.fromJson(Map<String, dynamic> json) {
    return Assistant(
      id: json['id'],
      model: json['model'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'name': name,
    };
  }
}

enum Model { 
  DIFY,
  KNOWLEDGE_BASE
}
enum Id {
    CLAUDE_3_HAIKU_20240307,
    CLAUDE_3_SONNET_20240229,
    GEMINI_15_FLASH_LATEST,
    GEMINI_15_PRO_LATEST,
    GPT_4O,
    GPT_4O_MINI
}
// message.dart
class Message {
  final Assistant assistant;
  final String content;
  final List<String>? files;
  final String role; // 'user' or 'model'

  Message({
    required this.assistant,
    required this.content,
    this.files,
    required this.role,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      assistant: Assistant.fromJson(json['assistant']),
      content: json['content'],
      files: List<String>.from(json['files'] ?? []),
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assistant': assistant.toJson(),
      'content': content,
      'files': files,
      'role': role,
    };
  }
}

// conversation.dart
class Conversation {
  final String id;
  final String? title;
  final List<Message> messages;
  final DateTime createdAt;

  Conversation({
    required this.id,
    this.title,
    required this.messages,
    required this.createdAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      title: json['title'],
      messages: List<Message>.from(
          json['messages']?.map((x) => Message.fromJson(x)) ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((x) => x.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}