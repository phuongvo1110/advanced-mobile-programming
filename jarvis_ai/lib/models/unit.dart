class Unit {
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? deletedAt;
  String? id;
  String? name;
  String? type;
  int? size;
  bool? status;
  String? userId;
  String? knowledgeId;
  List<String>? openAiFileIds;
  Metadata? metadata;

  Unit(
      {this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.deletedAt,
      this.id,
      this.name,
      this.type,
      this.size,
      this.status,
      this.userId,
      this.knowledgeId,
      this.openAiFileIds,
      this.metadata});

  Unit.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    deletedAt = json['deletedAt'];
    id = json['id'];
    name = json['name'];
    type = json['type'];
    size = json['size'];
    status = json['status'];
    userId = json['userId'];
    knowledgeId = json['knowledgeId'];
    openAiFileIds = json['openAiFileIds'].cast<String>();
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['deletedAt'] = this.deletedAt;
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['size'] = this.size;
    data['status'] = this.status;
    data['userId'] = this.userId;
    data['knowledgeId'] = this.knowledgeId;
    data['openAiFileIds'] = this.openAiFileIds;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

class Metadata {
  String? name;
  String? mimetype;

  Metadata({this.name, this.mimetype});

  Metadata.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mimetype = json['mimetype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mimetype'] = this.mimetype;
    return data;
  }
}
