class AssistantDetail {
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  DateTime? deletedAt;
  String id;
  String? description;
  String? instructions;
  String assistantName;
  dynamic config;
  String? userId;
  bool? isDefault;
  bool? isFavorite;

  AssistantDetail({
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    required this.id,
    this.description,
    this.instructions,
    required this.assistantName,
    this.config,
    this.userId,
    this.isDefault,
    this.isFavorite,
  });

  AssistantDetail.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        assistantName = json['assistantName'] ?? '' {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    deletedAt = json['deletedAt'];
    description = json['description'];
    instructions = json['instructions'];
    config = json['config'];
    userId = json['userId'];
    isDefault = json['isDefault'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['deletedAt'] = deletedAt;
    data['id'] = id;
    data['description'] = description;
    data['instructions'] = instructions;
    data['assistantName'] = assistantName;
    if (config != null) {
      data['config'] = config!.toJson();
    }
    data['userId'] = userId;
    data['isDefault'] = isDefault;
    data['isFavorite'] = isFavorite;
    return data;
  }

  AssistantDetail copyWith({
    String? createdAt,
    String? updatedAt,
    String? createdBy,
    String? updatedBy,
    DateTime? deletedAt,
    String? id,
    String? description,
    String? instructions,
    String? assistantName,
    dynamic config,
    String? userId,
    bool? isDefault,
    bool? isFavorite,
  }) {
    return AssistantDetail(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      id: id ?? this.id,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      assistantName: assistantName ?? this.assistantName,
      config: config ?? this.config,
      userId: userId ?? this.userId,
      isDefault: isDefault ?? this.isDefault,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
