import 'package:flip_cash/widgets/Custom_Button.dart';
import 'package:flip_cash/widgets/Custom_HeaderText.dart';
import 'package:flutter/material.dart';
import 'package:flip_cash/services/exchange_rate_service.dart';
import 'package:flip_cash/screens/SelectSpentCurrencyScreen.dart';

class SelectCurrencyScreen extends StatefulWidget {
  final String countryName;
  final String countryFlag;

  const SelectCurrencyScreen({
    super.key,
    required this.countryName,
    required this.countryFlag,
  });

  @override
  State<SelectCurrencyScreen> createState() => _SelectCurrencyScreenState();
}

class _SelectCurrencyScreenState extends State<SelectCurrencyScreen> {
  Map<String, double>? rates;
  String? selectedCurrency;

  final List<String> mainCurrencies = [
  "USD","EUR","GBP","JPY","TRY","AUD","CAD","CHF","CNY","HKD",
  "NZD","SEK","NOK","SGD","MXN","ZAR","KRW","INR","BRL","RUB",
  "COP","ARS","AED","SAR","THB","IDR","PLN","TWD",
  "DKK","HUF","CZK","ILS","EGP","PKR","VND","MYR","PHP","CLP",
  "KWD","QAR","BGN","RON","UAH",
  "MAD","DZD","NGN","GHS","KES","TND","LKR","BDT","MMK","IRR",
  "IQD","PEN","BOB","PAB","UYU"
];

final Map<String, String> currencyToCountryCode = {
  'USD': 'US','EUR': 'EU','GBP': 'GB','JPY': 'JP','TRY': 'TR',
  'AUD': 'AU','CAD': 'CA','CHF': 'CH','CNY': 'CN','HKD': 'HK',
  'NZD': 'NZ','SEK': 'SE','NOK': 'NO','SGD': 'SG','MXN': 'MX',
  'ZAR': 'ZA','KRW': 'KR','INR': 'IN','BRL': 'BR','RUB': 'RU',
  'COP': 'CO','ARS': 'AR','AED': 'AE','SAR': 'SA','THB': 'TH',
  'IDR': 'ID','PLN': 'PL','TWD': 'TW',
  'DKK': 'DK','HUF': 'HU','CZK': 'CZ','ILS': 'IL','EGP': 'EG',
  'PKR': 'PK','VND': 'VN','MYR': 'MY','PHP': 'PH','CLP': 'CL',
  'KWD': 'KW','QAR': 'QA','BGN': 'BG','RON': 'RO','UAH': 'UA',
  'MAD': 'MA','DZD': 'DZ','NGN': 'NG','GHS': 'GH','KES': 'KE',
  'TND': 'TN','LKR': 'LK','BDT': 'BD','MMK': 'MM','IRR': 'IR',
  'IQD': 'IQ','PEN': 'PE','BOB': 'BO','PAB': 'PA','UYU': 'UY',
};


  String countryCodeToFlag(String countryCode) {
    return countryCode.toUpperCase().codeUnits.map((c) => String.fromCharCode(c + 127397)).join();
  }

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  void _loadCurrencies() async {
    final fetchedRates = await ExchangeRateService().getExchangeRates("USD");
    setState(() {
      rates = fetchedRates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
  alignment: Alignment.topLeft,
  child: IconButton(
    icon: Icon(
      Icons.arrow_back_ios,
      size: 20,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black, 
    ),
    onPressed: () => Navigator.pop(context),
  ),
),

              CustomHeaderText(
                text: "Select Your Base Currency",
                fontSize: 32,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 20),

              Container(  
                height: 345,
  child: rates == null
      ? const Center(child: CircularProgressIndicator())
      : ListView(
          children: [
            // Öncelikli para birimleri
            ...mainCurrencies.where((c) => rates!.containsKey(c)).map((currency) {
              final isSelected = currency == selectedCurrency;
              final isoCode = currencyToCountryCode[currency];
              final flag = isoCode != null ? countryCodeToFlag(isoCode) : '';
              final displayName = currency;

              final isDark = Theme.of(context).brightness == Brightness.dark;
              final textColor = isSelected
                  ? (isDark ? Colors.green : Colors.green)
                  : (isDark ? Colors.white : Colors.black);

              final borderColor = isSelected
                  ? (isDark ? Colors.green : Colors.green)
                  : Colors.transparent;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 3),
                ),
                child: ListTile(
                  tileColor: Colors.transparent,
                  title: Row(
                    children: [
                      if (flag.isNotEmpty)
                        Text(flag, style: const TextStyle(fontSize: 24)),
                      if (flag.isNotEmpty) const SizedBox(width: 10),
                      Text(displayName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor)),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      selectedCurrency = currency;
                    });
                  },
                  trailing: isSelected
                      ? Icon(Icons.check, color: borderColor)
                      : null,
                ),
              );
            }),

            // Diğer para birimleri
            ...rates!.keys
                .where((c) => !mainCurrencies.contains(c))
                .map((currency) {
              final isSelected = currency == selectedCurrency;
              final isoCode = currencyToCountryCode[currency];
              final flag = isoCode != null ? countryCodeToFlag(isoCode) : '';
              final displayName = currency;

              final isDark = Theme.of(context).brightness == Brightness.dark;
              final textColor = isSelected
                  ? (isDark ? Colors.green : Colors.green)
                  : (isDark ? Colors.white : Colors.black);

              final borderColor = isSelected
                  ? (isDark ? Colors.green : Colors.green)
                  : Colors.transparent;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: ListTile(
                  tileColor: Colors.transparent,
                  title: Row(
                    children: [
                      if (flag.isNotEmpty)
                        Text(flag, style: const TextStyle(fontSize: 24)),
                      if (flag.isNotEmpty) const SizedBox(width: 10),
                      Text(displayName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor)),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      selectedCurrency = currency;
                    });
                  },
                  trailing: isSelected
                      ? Icon(Icons.check, color: borderColor)
                      : null,
                ),
              );
            }),
          ],
        ),
),

            ],
          ),
        ),
      ),
      bottomNavigationBar: selectedCurrency != null
          ? Padding(
              padding: const EdgeInsets.only(top:25, bottom: 70, left: 25, right: 25),
              child: CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectSpentCurrencyScreen(
                        countryName: widget.countryName,
                        baseCurrency: selectedCurrency!,
                        countryFlag: widget.countryFlag,
                      ),
                    ),
                  );
                },
                text: "Continue",
                borderRadius: 12,
                width: double.infinity,
                height: 45,
              ),
            )
          : null,
    );
  }
}
