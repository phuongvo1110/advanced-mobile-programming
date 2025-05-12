class ThreadMessage {
  final String role;
  final int createdAt;
  final String content;

  ThreadMessage({
    required this.role,
    required this.createdAt,
    required this.content,
  });

  factory ThreadMessage.fromJson(Map<String, dynamic> json) {
    final contentList = json['content'] as List<dynamic>;
    final textContent = contentList.firstWhere(
      (item) => item['type'] == 'text',
      orElse: () => {'text': {'value': ''}},
    );
    return ThreadMessage(
      role: json['role'] ?? '',
      createdAt: json['createdAt'] ?? 0,
      content: textContent['text']['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'createdAt': createdAt,
      'content': [
        {
          'type': 'text',
          'text': {'value': content, 'annotations': []}
        }
      ],
    };
  }
}