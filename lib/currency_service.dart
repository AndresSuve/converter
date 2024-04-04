import 'dart:convert';
import 'package:http/http.dart' as http;
import 'currency_model.dart';

class ApiService {
  static const String apiKey = 'fca_live_VgDlR1cLqcUrWCPQ8tvt00jyNMEPvgjnHW4rWoMs';
  static const String apiUrl = 'https://api.currencyapi.com/v3/latest?apikey=fca_live_VgDlR1cLqcUrWCPQ8tvt00jyNMEPvgjnHW4rWoMs';

  Future<List<Currency>> fetchExchangeRates() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        List<Currency> currencies = [];

        responseData['data'].forEach((key, value) {
          currencies.add(Currency.fromJson(value));
        });

        return currencies;
      } else {
        throw Exception('Failed to load exchange rates: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
