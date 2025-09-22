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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 21, 52),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeaderText(
                  text: "Which country are you traveling to?",
                  color: Colors.white,
                  fontSize: 37,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 20),
                CustomTextfield(
                  controller: _searchController,
                  prefix_icon: Icon(Icons.search),
                  hint_text: "Search Country",
                  prefixIcon_color: Colors.white,
                  hintText_color: Colors.white,
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 340,
                  child: ListView.builder(
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = filteredCountries[index];
                      final isSelected = country == selectedCountry;

                      return ListTile(
                        onTap: () {
                          setState(() {
                            selectedCountry = country;
                          });
                        },
                        leading: Text(
                          country.flagEmoji,
                          style: TextStyle(fontSize: 32),
                        ),
                        title: Text(
                          country.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.white,
                          ),
                        ),
                        trailing:
                            isSelected
                                ? Icon(Icons.check, color: Colors.white,size: 26,)
                                : null,
                      );
                    },
                  ),
                ),
                SizedBox(height: 60),
                CustomButton(
                  onPressed: () {
                    if (selectedCountry != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectCurrencyScreen(
                            countryName: selectedCountry!.name,
                            countryFlag: selectedCountry!.flagEmoji,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lütfen bir ülke seçin.')),
                      );
                    }
                  },
                  text: "Continue",
                  backgroundColor: Colors.white,
                  borderRadius: 12,
                  width: double.infinity,
                  height: 45,
                  textColor: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
