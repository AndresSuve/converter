import 'package:flutter/material.dart';
import 'currency_service.dart';

class ExchangeRatePage extends StatefulWidget {
  @override
  _ExchangeRatePageState createState() => _ExchangeRatePageState();
}

class _ExchangeRatePageState extends State<ExchangeRatePage> {
  double _exchangeRate = 0.0;
  String _fromCurrency = 'EUR';
  String _toCurrency = 'USD';
  double _amountToConvert = 1.0;
  ApiService _apiService = ApiService(); // Change here

  void _refreshExchangeRate() async {
    Map<String, dynamic> responseData = await _apiService.fetchExchangeRates(); // Change here
    double rate = responseData['rates'][_toCurrency];
    setState(() {
      _exchangeRate = rate;
    });
  }

  void _switchCurrencies() {
    setState(() {
      String temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _refreshExchangeRate();
    });
  }

  void _updateAmountToConvert(String value) {
    setState(() {
      _amountToConvert = double.tryParse(value) ?? 1.0;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshExchangeRate,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Exchange Rate',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      '1 $_fromCurrency = $_exchangeRate $_toCurrency',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: _refreshExchangeRate,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.0),
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount to Convert',
                  border: OutlineInputBorder(),
                ),
                onChanged: _updateAmountToConvert,
              ),
              SizedBox(height: 20.0),
              Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: _switchCurrencies,
                  child: Text(
                    'Switch Currencies',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Converted Amount:',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '${(_amountToConvert * _exchangeRate).toStringAsFixed(2)} $_toCurrency',
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
