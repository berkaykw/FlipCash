import 'package:flip_cash/screens/SelectCurrencyScreen.dart';
import 'package:flip_cash/widgets/Custom_Button.dart';
import 'package:flip_cash/widgets/Custom_HeaderText.dart';
import 'package:flip_cash/widgets/Custom_Textfield.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';
import '../utils/theme_provider.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key});

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Country> allCountries = [];
  List<Country> filteredCountries = [];
  Country? selectedCountry;

  @override
  void initState() {
    super.initState();
    allCountries = CountryService().getAll();
    filteredCountries = List.from(allCountries);

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredCountries =
            allCountries
                .where((c) => c.name.toLowerCase().contains(query))
                .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Switch(
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
            activeColor: Colors.white,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeaderText(
                  text: "Which country are you traveling to?",
                  fontSize: 37,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 20),
                CustomTextfield(
                  controller: _searchController,
                  prefix_icon: const Icon(Icons.search),
                  hint_text: "Search Country",
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 340,
                  child: ListView.builder(
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = filteredCountries[index];
                      final isSelected = country == selectedCountry;

                      final isDark =
                          Theme.of(context).brightness == Brightness.dark;
                      final textColor = isDark ? Colors.white : Colors.black;
                      final selectedColor = isDark ? Colors.lightGreenAccent[400] : Colors.lightGreenAccent[400];

                      return ListTile(
                        onTap: () {
                          setState(() {
                            selectedCountry = country;
                          });
                        },
                        leading: Text(
                          country.flagEmoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                        title: Text(
                          country.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                isSelected ? FontWeight.w900 : FontWeight.w600,
                            color: isSelected ? selectedColor : textColor,
                          ),
                        ),
                        trailing:
                            isSelected
                                ? Icon(
                                  Icons.check,
                                  color: selectedColor,
                                  size: 26,
                                )
                                : null,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 60),
                CustomButton(
                  onPressed: () {
                    if (selectedCountry != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => SelectCurrencyScreen(
                                countryName: selectedCountry!.name,
                                countryFlag: selectedCountry!.flagEmoji,
                              ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lütfen bir ülke seçin.')),
                      );
                    }
                  },
                  text: "Continue",
                  borderRadius: 12,
                  width: double.infinity,
                  height: 45,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
