import 'package:flutter/material.dart';
import 'exchange_service.dart';
import 'exchange_rate.dart';

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  late ExchangeRate _exchangeRate = ExchangeRate(
    baseCurrency: '',
    targetCurrency: '',
    rate: 0.0,
  );
  String _baseCurrency = 'EUR';
  String _targetCurrency = 'USD';
  bool _isLoading = true; // Add a loading state
  TextEditingController _amountController = TextEditingController(text: '1');

  ExchangeRateService _exchangeRateService = ExchangeRateService();

  @override
  void initState() {
    super.initState();
    _fetchExchangeRate();
  }

  Future<void> _fetchExchangeRate() async {
    try {
      ExchangeRate exchangeRate = await _exchangeRateService.getExchangeRate(_baseCurrency, _targetCurrency);
      setState(() {
        _exchangeRate = exchangeRate;
        _isLoading = false; // Set loading state to false once exchange rate is fetched
      });
    } catch (e) {
      print('Error fetching exchange rate: $e');
      setState(() {
        _isLoading = false; // Set loading state to false in case of error
      });
    }
  }

  double _convertAmount() {
    double amount = double.tryParse(_amountController.text) ?? 1;
    return amount * _exchangeRate.rate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _baseCurrency,
                    items: ['EUR', 'USD'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _baseCurrency = value!;
                        _isLoading = true;
                      });
                      _fetchExchangeRate();
                    },
                    decoration: InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _targetCurrency,
                    items: ['EUR', 'USD'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _targetCurrency = value!;
                        _isLoading = true;
                      });
                      _fetchExchangeRate();
                    },
                    decoration: InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Enter amount to convert',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 20),
            Text(
              'Converted Amount:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${_convertAmount().toStringAsFixed(2)} $_targetCurrency',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchExchangeRate,
              child: Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
