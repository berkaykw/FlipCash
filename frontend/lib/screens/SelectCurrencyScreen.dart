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

  final List<String> mainCurrencies = ["USD", "EUR", "GBP", "JPY", "TRY"];

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
                  icon: Icon(Icons.arrow_back_ios, size: 20,color: Colors.white,),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              CustomHeaderText(
                text: "Select Your Base Currency",
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 20),

              // ListTile'ların bulunduğu sabit alan
              Container(
  height: 420,
  child: rates == null
      ? Center(child: CircularProgressIndicator())
      : ListView(
          children: [
            ...mainCurrencies
                .where((c) => rates!.containsKey(c))
                .map((currency) {
              final isSelected = currency == selectedCurrency;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.transparent, // burayı şeffaf yaptık
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.green : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: ListTile(
                  tileColor: Colors.transparent, // ListTile arka planını kaldır
                  title: Text(
                    currency,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.green : Colors.white,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check, color: Colors.green, size: 25)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedCurrency = currency;
                    });
                  },
                ),
              );
            }),
            ...rates!.keys
                .where((c) => !mainCurrencies.contains(c))
                .map((currency) {
              final isSelected = currency == selectedCurrency;
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
                  title: Text(
                    currency,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.green : Colors.white,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check, color: Colors.green, size: 25)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedCurrency = currency;
                    });
                  },
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
      bottomNavigationBar:
          selectedCurrency != null
              ? Padding(
                padding: const EdgeInsets.only(bottom: 70, left: 25, right: 25),
                child: CustomButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => SelectSpentCurrencyScreen(
                              countryName: widget.countryName,
                              baseCurrency: selectedCurrency!,
                              countryFlag: widget.countryFlag, 
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
