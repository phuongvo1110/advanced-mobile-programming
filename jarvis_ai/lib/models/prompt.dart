class Prompt {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? category;
  final String content;
  final String? description;
  final bool isPublic;
  final String? language;
  final String title;
  final String? userId;
  final String? userName;
  final bool? isFavorite;

  Prompt({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.category,
    required this.content,
    this.description,
    required this.isPublic,
    this.language,
    required this.title,
    this.userId,
    this.userName,
    this.isFavorite,
  });
  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      id: json['_id'] ?? '',  // Provide default empty string if null
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
      category: json['category'],
      content: json['content'] ?? '',  // Provide default empty string if null
      description: json['description'],
      isPublic: json['isPublic'] ?? false,  // Default to false if null
      language: json['language'],
      title: json['title'] ?? 'Untitled',  // Provide default title if null
      userId: json['userId'] ?? '',  // Provide default empty string if null
      userName: json['userName'] ?? 'Unknown',  // Provide default name if null
      isFavorite: json['isFavorite'] ?? false,  // Default to false if null
    );
  }
}
