import 'package:flip_cash/screens/CurrencyConvertScreen.dart';
import 'package:flip_cash/widgets/Custom_Button.dart';
import 'package:flutter/material.dart';

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
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    top: 20.0,
                    bottom: 20.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400]!.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.countryFlag,
                                  style: TextStyle(fontSize: 50),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    widget.countryName,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 75.0,
                              bottom: 10,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  widget.spentCurrency,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Icon(Icons.arrow_right_alt, size: 30),
                                Text(
                                  widget.baseCurrency,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Your base currency: ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      widget.baseCurrency,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        "The currency you will spend in ${widget.countryName} : ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    Text(
                      widget.spentCurrency,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CurrencyConvertScreen(
                              countryName: widget.countryName, 
                              countryFlag: widget.countryFlag, 
                              baseCurrency: widget.baseCurrency, 
                              spentCurrency: widget.spentCurrency,
                        ),
                      ),
                    );
                    },
                    text: "Confirm Selection",
                    backgroundColor: Colors.black87,
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
