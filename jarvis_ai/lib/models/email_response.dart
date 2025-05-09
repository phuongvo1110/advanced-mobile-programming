class EmailResponse {
  String? email;
  int? remainingUsage;
  List<String>? improvedActions;

  EmailResponse({this.email, this.remainingUsage, this.improvedActions});

  EmailResponse.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    remainingUsage = json['remainingUsage'];
    improvedActions = json['improvedActions'] != null
        ? List<String>.from(json['improvedActions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['remainingUsage'] = this.remainingUsage;
    if (this.improvedActions != null) {
      data['improvedActions'] = this.improvedActions;
    }
    return data;
  }
}
