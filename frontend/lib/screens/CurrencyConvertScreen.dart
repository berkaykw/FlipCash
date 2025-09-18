import 'package:flutter/material.dart';

class CurrencyConvertScreen extends StatefulWidget {

  final String countryName;
  final String countryFlag;
  final String baseCurrency;
  final String spentCurrency;

  const CurrencyConvertScreen({
      super.key,
      required this.countryName,
      required this.countryFlag,
      required this.baseCurrency,
      required this.spentCurrency,
  });

  @override
  State<CurrencyConvertScreen> createState() => _CurrencyConvertScreenState();
}

class _CurrencyConvertScreenState extends State<CurrencyConvertScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Country: ${widget.countryName}"),
          Text("Flag: ${widget.countryFlag}"),
          Text("Base Currency: ${widget.baseCurrency}"),
          Text("Spent Currency: ${widget.spentCurrency}"),
        ],
      ),
        
    );
  }
}