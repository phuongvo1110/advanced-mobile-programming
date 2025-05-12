class UserToken {
  String? name;
  int? dailyTokens;
  int? monthlyTokens;
  int? annuallyTokens;

  UserToken(
      {this.name, this.dailyTokens, this.monthlyTokens, this.annuallyTokens});

  UserToken.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dailyTokens = json['dailyTokens'];
    monthlyTokens = json['monthlyTokens'];
    annuallyTokens = json['annuallyTokens'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['dailyTokens'] = this.dailyTokens;
    data['monthlyTokens'] = this.monthlyTokens;
    data['annuallyTokens'] = this.annuallyTokens;
    return data;
  }
}
