class Token {
  final num availableTokens;
  final num totalTokens;
  final bool unlimited;
  final DateTime? date;

  const Token({
    required this.availableTokens,
    required this.totalTokens,
    required this.unlimited,
    this.date,
  });

  Token copyWith({
    num? availableTokens,
    num? totalTokens,
    bool? unlimited,
    DateTime? date,
  }) {
    return Token(
      availableTokens: availableTokens ?? this.availableTokens,
      totalTokens: totalTokens ?? this.totalTokens,
      unlimited: unlimited ?? this.unlimited,
      date: date ?? this.date,
    );
  }

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      availableTokens: json['availableTokens'] as num,
      totalTokens: json['totalTokens'] as num,
      unlimited: json['unlimited'] as bool,
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availableTokens': availableTokens,
      'totalTokens': totalTokens,
      'unlimited': unlimited,
      'date': date?.toIso8601String(),
    };
  }
}