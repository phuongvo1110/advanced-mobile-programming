class MessageQuery {
  String? answer;
  String? createdAt;
  String? query;

  MessageQuery({this.answer, this.createdAt, this.query});

  MessageQuery.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
    createdAt = json['createdAt'];
    query = json['query'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer'] = this.answer;
    data['createdAt'] = this.createdAt;
    data['query'] = this.query;
    return data;
  }
}