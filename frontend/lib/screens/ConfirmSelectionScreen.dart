import 'package:flip_cash/screens/CurrencyConvertScreen.dart';
import 'package:flip_cash/widgets/Custom_Button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmSelectionScreen extends StatefulWidget {
  final String countryName;
  final String countryFlag;
  final String baseCurrency;
  final String spentCurrency;

  const ConfirmSelectionScreen({
    super.key,
    required this.countryName,
    required this.countryFlag,
    required this.baseCurrency,
    required this.spentCurrency,
  });

  @override
  State<ConfirmSelectionScreen> createState() => _ConfirmSelectionScreenState();
}

class _ConfirmSelectionScreenState extends State<ConfirmSelectionScreen> {
  Future<void> _confirmSelection() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('countryName', widget.countryName);
    await prefs.setString('countryFlag', widget.countryFlag);
    await prefs.setString('baseCurrency', widget.baseCurrency);
    await prefs.setString('spentCurrency', widget.spentCurrency);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CurrencyConvertScreen(
          countryName: widget.countryName,
          countryFlag: widget.countryFlag,
          baseCurrency: widget.baseCurrency,
          spentCurrency: widget.spentCurrency,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : Colors.black87;
    final textSecondaryColor = isDark ? Colors.white70 : Colors.black54;
    final iconColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 20, color: iconColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 10),

              // Country / Currency Card
              Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
  child: Container(
    decoration: BoxDecoration(
      color: isDark ? Colors.white : Colors.black, // ters tema
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      borderRadius: BorderRadius.circular(20),
    ),
    height: 150,
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.countryFlag, style: const TextStyle(fontSize: 50)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.countryName,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.black : Colors.white, // metin kontrastı
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 75.0, bottom: 10),
            child: Row(
              children: [
                Text(
                  widget.spentCurrency,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.black : Colors.white),
                ),
                Icon(Icons.arrow_right_alt, size: 30, color: isDark ? Colors.black87 : Colors.white70),
                Text(
                  widget.baseCurrency,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.black : Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
),


              // Info Rows
              Row(
                children: [
                  Text(
                    "Your base currency: ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textSecondaryColor),
                  ),
                  Text(
                    widget.baseCurrency,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      "The currency you will spend in ${widget.countryName} : ",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textSecondaryColor),
                    ),
                  ),
                  Text(
                    widget.spentCurrency,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Confirm Button
              Center(
                child: CustomButton(
                  onPressed: _confirmSelection,
                  text: "Confirm Selection",
                  backgroundColor: isDark ? Colors.white : Colors.black87,
                  textColor: isDark ? Colors.black : Colors.white,
                  borderRadius: 12,
                  width: double.infinity,
                  height: 45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
