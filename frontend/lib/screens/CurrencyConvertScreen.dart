import 'package:flip_cash/widgets/Custom_HeaderText.dart';
import 'package:flip_cash/widgets/NumberPad.dart';
import 'package:flutter/material.dart';
import 'package:flip_cash/services/exchange_rate_service.dart';

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
  Map<String, double>? rates;
  String enteredAmount = "0";
  double? convertedAmount;

  late String _spentCurrency;
  late String _baseCurrency;
  late String _spentFlag;
  late String _baseFlag;

  final Map<String, String> currencyToCountryCode = {
    'USD': 'US',
    'EUR': 'EU',
    'GBP': 'GB',
    'JPY': 'JP',
    'TRY': 'TR',
    'AUD': 'AU',
    'CAD': 'CA',
    'CHF': 'CH',
    'CNY': 'CN',
    'HKD': 'HK',
    'NZD': 'NZ',
    'SEK': 'SE',
    'NOK': 'NO',
    'SGD': 'SG',
    'MXN': 'MX',
    'ZAR': 'ZA',
    'KRW': 'KR',
    'INR': 'IN',
    'BRL': 'BR',
    'RUB': 'RU',
  };

  String getFlagFromCurrency(String currency) {
    final countryCode = currencyToCountryCode[currency];
    if (countryCode != null) {
      return countryCode
          .toUpperCase()
          .codeUnits
          .map((c) => String.fromCharCode(c + 127397))
          .join();
    }
    return '💰';
  }

  @override
  void initState() {
    super.initState();
    _spentCurrency = widget.spentCurrency;
    _baseCurrency = widget.baseCurrency;
    _spentFlag = widget.countryFlag;
    _baseFlag = getFlagFromCurrency(widget.baseCurrency);
    _loadCurrencies();
  }

  void _swapCurrencies() {
    setState(() {
      final oldBaseCurrency = _baseCurrency;
      final oldBaseFlag = _baseFlag;

      _baseCurrency = _spentCurrency;
      _baseFlag = _spentFlag;

      _spentCurrency = oldBaseCurrency;
      _spentFlag = oldBaseFlag;

      _loadCurrencies();
    });
  }

  void _loadCurrencies() async {
    final fetchedRates = await ExchangeRateService().getExchangeRates(
      _spentCurrency,
    );
    setState(() {
      rates = fetchedRates;
      _updateConvertedAmount();
    });
  }

  void _onNumberEntered(String number) {
    setState(() {
      if (enteredAmount == "0") {
        enteredAmount = number;
      } else {
        enteredAmount += number;
      }
      _updateConvertedAmount();
    });
  }

  void _onDelete() {
    setState(() {
      enteredAmount = "0"; // Girilen miktarı sıfırla
      convertedAmount = null; // Çevrilen miktarı sıfırla
    });
  }

  void _updateConvertedAmount() {
    double? amount = double.tryParse(enteredAmount);
    if (amount != null && rates != null) {
      double rate = rates![_baseCurrency] ?? 1;
      convertedAmount = amount * rate;
    } else {
      convertedAmount = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 21, 52),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeaderText(
                text: "Convert",
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
              ),
              CustomHeaderText(
                text:
                    "Destination Country : ${widget.countryFlag} ${widget.countryName}",
                color: Colors.grey[500],
                fontSize: 15,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 20),
              _currencyBox(_spentFlag, _spentCurrency, _spentCurrency),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: IconButton(
                    onPressed: _swapCurrencies,
                    icon: const Icon(
                      Icons.swap_vert_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
              _currencyBox(_baseFlag, _baseCurrency, _baseCurrency),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Miktar + Çevrilen miktar
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 30, 33, 70),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  enteredAmount,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.grey,
                              size: 25,
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  convertedAmount != null
                                      ? "${convertedAmount!.toStringAsFixed(2)} $_baseCurrency"
                                      : "0.00 $_baseCurrency",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "1 $_spentCurrency = ${(rates != null ? (rates![_baseCurrency]?.toStringAsFixed(4) ?? '...') : '...')} $_baseCurrency",
                        style: TextStyle(color: Colors.grey[500], fontSize: 13 , fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 20),
                      // NumberPad
                      Expanded(
                        child: SimpleNumberPad(
                          amount: enteredAmount,
                          onNumberEntered: _onNumberEntered,
                          onDelete: _onDelete,
                          currencyAmount:
                              convertedAmount != null
                                  ? "${convertedAmount!.toStringAsFixed(2)} $_baseCurrency"
                                  : "0.00 $_baseCurrency",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Text(
                    "Change Selections",
                    style: TextStyle(color: Colors.grey[500], fontSize: 15),
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

Widget _currencyBox(String flag, String name, String code) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey[400]!.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Text(flag, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 12),
        Text(
          code,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
