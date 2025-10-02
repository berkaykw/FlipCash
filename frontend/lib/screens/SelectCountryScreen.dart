import 'package:flip_cash/screens/SelectCurrencyScreen.dart';
import 'package:flip_cash/widgets/Custom_Button.dart';
import 'package:flip_cash/widgets/Custom_HeaderText.dart';
import 'package:flip_cash/widgets/Custom_Textfield.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

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
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double availableHeight = screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;
    
    // Dinamik yükseklik hesaplaması
    final double headerHeight = 120; // Header text + padding
    final double searchFieldHeight = 80; // Search field + padding
    final double buttonHeight = 105; // Button + padding
    final double listViewHeight = availableHeight - headerHeight - searchFieldHeight - buttonHeight;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header - Sabit yükseklik
              SizedBox(
                height: headerHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomHeaderText(
                      text: "Which country are you traveling to?",
                      fontSize: screenSize.width < 360 ? 32 : 35,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              
              // Search Field - Sabit yükseklik
              SizedBox(
                height: searchFieldHeight,
                child: Column(
                  children: [
                    CustomTextfield(
                      controller: _searchController,
                      prefix_icon: const Icon(Icons.search),
                      hint_text: "Search Country",
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              
              // Country List - Dinamik yükseklik
              Expanded(
                child: Container(
                  height: listViewHeight > 200 ? listViewHeight : 200, // Minimum 200 yükseklik
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
              ),
              
              // Button - Sabit yükseklik (her zaman altta görünür)
              const SizedBox(height: 20),
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
    );
  }
}
