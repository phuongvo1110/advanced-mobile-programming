/// AssistantResDto
class AssistantDetail {
  final String assistantName;
  final DateTime createdAt;
  final String? createdBy;
  final String? description;
  final String id;
  final String? instructions;
  final String openAiAssistantId;
  final String? openAiThreadIdPlay;
  final DateTime? updatedAt;
  final String? updatedBy;
  final bool? isDefault;
  final bool? isFavorite;

  const AssistantDetail({
    required this.assistantName,
    required this.createdAt,
    this.createdBy,
    this.description,
    required this.id,
    this.instructions,
    required this.openAiAssistantId,
    this.openAiThreadIdPlay,
    this.updatedAt,
    this.updatedBy,
    this.isDefault,
    this.isFavorite,
  });
  AssistantDetail copyWith({
    String? assistantName,
    DateTime? createdAt,
    String? createdBy,
    String? description,
    String? id,
    String? instructions,
    String? openAiAssistantId,
    String? openAiThreadIdPlay,
    DateTime? updatedAt,
    String? updatedBy,
    bool? isDefault,
    bool? isFavorite,
  }) {
    return AssistantDetail(
      assistantName: assistantName ?? this.assistantName,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      description: description ?? this.description,
      id: id ?? this.id,
      instructions: instructions ?? this.instructions,
      openAiAssistantId: openAiAssistantId ?? this.openAiAssistantId,
      openAiThreadIdPlay: openAiThreadIdPlay ?? this.openAiThreadIdPlay,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      isDefault: isDefault ?? this.isDefault,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory AssistantDetail.fromJson(Map<String, dynamic> json) {
    return AssistantDetail(
      assistantName: json['assistantName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String?,
      description: json['description'] as String?,
      id: json['id'] as String,
      instructions: json['instructions'] as String?,
      openAiAssistantId: json['openAiAssistantId'] as String,
      openAiThreadIdPlay: json['openAiThreadIdPlay'] as String?,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
      updatedBy: json['updatedBy'] as String?,
      isDefault: json['isDefault'] as bool?,
      isFavorite: json['isFavorite'] as bool?,
    );
  }
  Map<String, dynamic> toJson() => {
    'assistantName': assistantName,
    'createdAt': createdAt.toIso8601String(),
    'createdBy': createdBy,
    'description': description,
    'id': id,
    'instructions': instructions,
    'openAiAssistantId': openAiAssistantId,
    'openAiThreadIdPlay': openAiThreadIdPlay,
    'updatedAt': updatedAt?.toIso8601String(),
    'updatedBy': updatedBy,
    'isDefault': isDefault,
    'isFavorite': isFavorite,
  };

  @override
  String toString() => 'Assistant(${toJson()})';
}
