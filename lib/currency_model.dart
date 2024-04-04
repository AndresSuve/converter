class Currency {
  final String code;
  final double value;

  Currency({
    required this.code,
    required this.value,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'],
      value: json['value'].toDouble(),
    );
  }
}
