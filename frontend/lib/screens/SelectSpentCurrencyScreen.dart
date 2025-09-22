import 'package:flip_cash/screens/ConfirmSelectionScreen.dart';
import 'package:flip_cash/widgets/Custom_Button.dart';
import 'package:flip_cash/widgets/Custom_HeaderText.dart';
import 'package:flutter/material.dart';
import 'package:flip_cash/services/exchange_rate_service.dart';

class SelectSpentCurrencyScreen extends StatefulWidget {
  final String countryName;
  final String baseCurrency;
  final String countryFlag;

  const SelectSpentCurrencyScreen({
    super.key,
    required this.countryName,
    required this.baseCurrency,
    required this.countryFlag,
  });

  @override
  State<SelectSpentCurrencyScreen> createState() => _SelectSpentCurrencyScreenState();
}

class _SelectSpentCurrencyScreenState extends State<SelectSpentCurrencyScreen> {
  Map<String, double>? rates;
  String? selectedSpentCurrency;

  final List<String> mainCurrencies = ["USD","EUR","GBP","JPY","TRY","AUD","CAD","CHF","CNY","HKD","NZD","SEK","NOK","SGD","MXN","ZAR","KRW","INR","BRL","RUB"];

  final Map<String, String> currencyToCountryCode = {
    'USD': 'US', 'EUR': 'EU', 'GBP': 'GB', 'JPY': 'JP', 'TRY': 'TR',
    'AUD': 'AU', 'CAD': 'CA', 'CHF': 'CH', 'CNY': 'CN', 'HKD': 'HK',
    'NZD': 'NZ', 'SEK': 'SE', 'NOK': 'NO', 'SGD': 'SG', 'MXN': 'MX',
    'ZAR': 'ZA', 'KRW': 'KR', 'INR': 'IN', 'BRL': 'BR', 'RUB': 'RU',
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
      backgroundColor: const Color.fromARGB(255, 18, 21, 52),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios,color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              CustomHeaderText(
                text: "Choose Your Spending Currency",
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: rates == null
                    ? Center(child: CircularProgressIndicator())
                    : ListView(
                        children: [
                          ...mainCurrencies
                              .where((c) => rates!.containsKey(c))
                              .map((currency) {
                            final isSelected = currency == selectedSpentCurrency;
                            final isoCode = currencyToCountryCode[currency];
                            final flag = isoCode != null ? countryCodeToFlag(isoCode) : '';
                            final displayName = currency;

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? Colors.green : Colors.transparent,
                                  width: 3,
                                ),
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
                                            color: isSelected ? Colors.green : Colors.white)),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedSpentCurrency = currency;
                                  });
                                },
                                trailing: isSelected
                                    ? Icon(Icons.check, color: Colors.green)
                                    : null,
                              ),
                            );
                          }),
                          ...rates!.keys
                              .where((c) => !mainCurrencies.contains(c))
                              .map((currency) {
                            final isSelected = currency == selectedSpentCurrency;
                            final isoCode = currencyToCountryCode[currency];
                            final flag = isoCode != null ? countryCodeToFlag(isoCode) : '';
                            final displayName = currency;

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? Colors.green : Colors.transparent,
                                  width: 2,
                                ),
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
                                            color: isSelected ? Colors.green : Colors.white)),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedSpentCurrency = currency;
                                  });
                                },
                                trailing: isSelected
                                    ? Icon(Icons.check, color: Colors.green)
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
      bottomNavigationBar: selectedSpentCurrency != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 70, left: 25,right: 25 ),
              child: CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmSelectionScreen(
                        countryName: widget.countryName,
                        countryFlag: widget.countryFlag,
                        baseCurrency: widget.baseCurrency,
                        spentCurrency: selectedSpentCurrency!,
                      ),
                    ),
                  );
                },
                text: "Continue",
                backgroundColor: Colors.white,
                borderRadius: 12,
                width: double.infinity,
                height: 45,
                textColor: Colors.black,
              ),
            )
          : null,
    );
  }
}
