class ExchangeRate {
  final String baseCurrency;
  final String targetCurrency;
  final double rate;

  ExchangeRate({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      baseCurrency: json['base'],
      targetCurrency: json['target'],
      rate: json['rate'],
    );
  }
}
