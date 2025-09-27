import 'package:flip_cash/screens/MyExpensesScreen.dart';
import 'package:flip_cash/screens/SelectCountryScreen.dart';
import 'package:flip_cash/widgets/Custom_HeaderText.dart';
import 'package:flip_cash/widgets/NumberPad.dart';
import 'package:flutter/material.dart';
import 'package:flip_cash/services/exchange_rate_service.dart';
import 'package:provider/provider.dart';
import '../utils/theme_provider.dart';
import 'package:flip_cash/models/expense.dart';
import 'package:flip_cash/utils/expense_storage.dart';

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
  List<Expense> expensesList = [];

  late String _spentCurrency;
  late String _baseCurrency;
  late String _spentFlag;
  late String _baseFlag;

  final Map<String, String> currencyToCountryCode = {
    'USD': 'US', 'EUR': 'EU', 'GBP': 'GB', 'JPY': 'JP', 'TRY': 'TR',
    'AUD': 'AU', 'CAD': 'CA', 'CHF': 'CH', 'CNY': 'CN', 'HKD': 'HK',
    'NZD': 'NZ', 'SEK': 'SE', 'NOK': 'NO', 'SGD': 'SG', 'MXN': 'MX',
    'ZAR': 'ZA', 'KRW': 'KR', 'INR': 'IN', 'BRL': 'BR', 'RUB': 'RU',
  };

  String getFlagFromCurrency(String currency) {
    final countryCode = currencyToCountryCode[currency];
    if (countryCode != null) {
      return countryCode.toUpperCase()
          .codeUnits.map((c) => String.fromCharCode(c + 127397)).join();
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

    _loadExpenses(); // Storage’dan yükle
    _loadCurrencies();
  }

  // ------------------ EXPENSES ------------------
  void _loadExpenses() async {
    final loaded = await ExpenseStorage.loadExpenses(widget.countryName, _spentCurrency);
    setState(() {
      expensesList = loaded;
    });
  }

  void addExpense(double amount, String description) async {
  final newExpense = Expense(
    amount: amount,
    description: description,
    currency: _spentCurrency,
  );

  // Storage’dan güncel listeyi al
  List<Expense> current = await ExpenseStorage.loadExpenses(widget.countryName, _spentCurrency);
  current.add(newExpense);

  // Storage’a kaydet
  await ExpenseStorage.saveExpenses(widget.countryName, _spentCurrency, current);

  // UI güncelle
  setState(() {
    expensesList = current;
  });
}
  void _showAddExpenseDialog() {
    TextEditingController _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add Description",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: "Enter description",
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white12
                        : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Cancel",
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_descriptionController.text.isNotEmpty) {
                          addExpense(convertedAmount ?? 0.0, _descriptionController.text);
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text("Save",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------ CURRENCY ------------------
  void _swapCurrencies() {
    setState(() {
      final oldBase = _baseCurrency;
      final oldFlag = _baseFlag;
      _baseCurrency = _spentCurrency;
      _baseFlag = _spentFlag;
      _spentCurrency = oldBase;
      _spentFlag = oldFlag;

      _loadCurrencies();
      _loadExpenses(); // Swap sonrası doğru expense listesi
    });
  }

  void _loadCurrencies() async {
    final fetchedRates = await ExchangeRateService().getExchangeRates(_spentCurrency);
    setState(() {
      rates = fetchedRates;
      _updateConvertedAmount();
    });
  }

  void _onNumberEntered(String number) {
    setState(() {
      if (enteredAmount == "0") enteredAmount = number;
      else enteredAmount += number;
      _updateConvertedAmount();
    });
  }

  void _onDelete() {
    setState(() {
      enteredAmount = "0";
      convertedAmount = null;
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

  // ------------------ UI ------------------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(backgroundColor: Colors.transparent),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 50),
            ListTile(
              leading: Icon(Icons.wallet),
              title: Text("My Expenses", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyExpensesScreen(
                      countryName: widget.countryName,
                      baseCurrency: _spentCurrency,
                      expensesList: expensesList,
                    ),
                  ),
                );
              },
            ),
             ListTile(
              leading: Icon(Icons.location_city_rounded),
              title: Text("Select a new country", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectCountryScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Dark Mode & Light Mode", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              trailing: Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (value) => themeProvider.toggleTheme(value),
                inactiveTrackColor: Colors.grey[350],
                activeColor: Colors.black87,
                inactiveThumbColor: Colors.white,
                activeTrackColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeaderText(text: "Convert", fontSize: 42, fontWeight: FontWeight.bold),
              CustomHeaderText(
                  text: "Destination Country : ${widget.countryFlag} ${widget.countryName}",
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              const SizedBox(height: 15),
              _currencyBox(context, _spentFlag, _spentCurrency, isDark),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: IconButton(
                    onPressed: _swapCurrencies,
                    icon: Icon(Icons.swap_vert_outlined, color: Colors.white, size: 25),
                  ),
                ),
              ),
              _currencyBox(context, _baseFlag, _baseCurrency, isDark),
              const SizedBox(height: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white12 : Colors.black45,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(enteredAmount, style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)))),
                          const SizedBox(width: 10),
                          Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 24),
                          const SizedBox(width: 10),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(convertedAmount != null ? "${convertedAmount!.toStringAsFixed(2)} $_baseCurrency" : "0.00 $_baseCurrency",
                                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "1 $_spentCurrency = ${(rates != null ? (rates![_baseCurrency]?.toStringAsFixed(4) ?? '...') : '...')} $_baseCurrency",
                          style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: _showAddExpenseDialog,
                          icon: Icon(Icons.add, color: Colors.white),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(const CircleBorder()),
                            backgroundColor: MaterialStateProperty.all(Colors.green),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      child: SimpleNumberPad(
                        amount: enteredAmount,
                        onNumberEntered: _onNumberEntered,
                        onDelete: _onDelete,
                        currencyAmount: convertedAmount != null ? "${convertedAmount!.toStringAsFixed(2)} $_baseCurrency" : "0.00 $_baseCurrency",
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                  child: Text("Change Selections", style: TextStyle(color: Colors.grey[500], fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _currencyBox(BuildContext context, String flag, String code, bool isDark) {
  final boxColor = isDark ? Colors.white : Colors.black87;
  final textColor = isDark ? Colors.black : Colors.white;
  final shadowColor = isDark ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.3);

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    decoration: BoxDecoration(
      color: boxColor,
      boxShadow: [BoxShadow(color: shadowColor, spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Text(flag, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 12),
        Text(code, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
