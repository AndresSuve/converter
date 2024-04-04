import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:converter/exchange_rate.dart';

class ExchangeRateService {
  final String _apiKey = 'fca_live_VgDlR1cLqcUrWCPQ8tvt00jyNMEPvgjnHW4rWoMs';

  Future<ExchangeRate> getExchangeRate(String baseCurrency, String targetCurrency) async {
    final Uri url = Uri.parse('https://api.currencyapi.com/v3/latest?apikey=$_apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final rates = responseData['rates'] as Map<String, dynamic>;
      final rate = rates[targetCurrency].toDouble();
      return ExchangeRate(
        baseCurrency: baseCurrency,
        targetCurrency: targetCurrency,
        rate: rate,
      );
    } else {
      throw Exception('Failed to load exchange rate');
    }
  }
}

