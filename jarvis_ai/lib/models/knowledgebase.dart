class KnowledgeBase {
  String? createdAt;
  String? updatedAt;
  Null? createdBy;
  Null? updatedBy;
  Null? deletedAt;
  String? id;
  String? knowledgeName;
  String? description;
  String? userId;

  KnowledgeBase(
      {this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.deletedAt,
      this.id,
      this.knowledgeName,
      this.description,
      this.userId});

  KnowledgeBase.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    deletedAt = json['deletedAt'];
    id = json['id'];
    knowledgeName = json['knowledgeName'];
    description = json['description'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['deletedAt'] = this.deletedAt;
    data['id'] = this.id;
    data['knowledgeName'] = this.knowledgeName;
    data['description'] = this.description;
    data['userId'] = this.userId;
    return data;
  }
}