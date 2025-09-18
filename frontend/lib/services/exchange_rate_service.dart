import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeRateService {
  // Android emulator: 10.0.2.2, iOS: localhost, gerçek cihaz: bilgisayar IP'si
  final String baseUrl = "http://10.0.2.2:3000";

  Future<Map<String, double>?> getExchangeRates(String base) async {
    final url = Uri.parse("$baseUrl/rates/$base");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["rates"] != null) {
        final Map<String, double> rates = Map<String, double>.from(
          data["rates"].map((key, value) => MapEntry(key, (value as num).toDouble())),
        );
        return rates;
      }
    }
    return null;
  }
}
