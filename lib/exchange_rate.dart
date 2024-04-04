import 'package:flutter/material.dart';
import 'currency_service.dart';
import 'currency_model.dart';

class ExchangeRatePage extends StatefulWidget {
  const ExchangeRatePage({super.key});

  @override
  _ExchangeRatePageState createState() => _ExchangeRatePageState();
}

class _ExchangeRatePageState extends State<ExchangeRatePage> {
  List<Currency> _currencies = [];
  ApiService _apiService = ApiService();
  double _amount = 1.0;
  Currency? _sourceCurrency;
  Currency? _targetCurrency;
  double _convertedAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _refreshExchangeRate();
  }

  void _refreshExchangeRate() async {
    try {
      List<Currency> currencies = await _apiService.fetchExchangeRates();
      setState(() {
        _currencies = currencies;
        _sourceCurrency = null; // Reset source currency selection
        _targetCurrency = null; // Reset target currency selection
        _convertedAmount = 0.0; // Reset converted amount
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch exchange rates: $e'),
        ),
      );
    }
  }


  double _calculateConvertedAmount() {
    if (_sourceCurrency != null && _targetCurrency != null) {
      return (_amount * _sourceCurrency!.value) / _targetCurrency!.value;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: _currencies.isNotEmpty
          ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<Currency>(
                value: _sourceCurrency,
                onChanged: (value) {
                  setState(() {
                    _sourceCurrency = value;
                    _convertedAmount = _calculateConvertedAmount();
                  });
                },
                items: _currencies
                    .map((currency) => DropdownMenuItem(
                  value: currency,
                  child: Text(currency.code),
                ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'From',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24.0),
              DropdownButtonFormField<Currency>(
                value: _targetCurrency,
                onChanged: (value) {
                  setState(() {
                    _targetCurrency = value;
                    _convertedAmount = _calculateConvertedAmount();
                  });
                },
                items: _currencies
                    .map((currency) => DropdownMenuItem(
                  value: currency,
                  child: Text(currency.code),
                ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'To',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                initialValue: _amount.toString(),
                onChanged: (value) {
                  setState(() {
                    _amount = double.tryParse(value) ?? 0.0;
                    _convertedAmount = _calculateConvertedAmount();
                  });
                },
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Converted Amount: ${_convertedAmount.toStringAsFixed(2)} ${_targetCurrency?.code ?? ''}',
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshExchangeRate,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
