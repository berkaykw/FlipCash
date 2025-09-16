import 'package:flutter/material.dart';

class CurrencyConvertScreen extends StatefulWidget {
  const CurrencyConvertScreen({super.key});

  @override
  State<CurrencyConvertScreen> createState() => _CurrencyConvertScreenState();
}

class _CurrencyConvertScreenState extends State<CurrencyConvertScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Currency Convert Screen'),
      ),
    );
  }
}