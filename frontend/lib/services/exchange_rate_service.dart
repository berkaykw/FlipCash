import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeRateService {
  final String apiKey = "b5126b4ce2295f061eec459d";

  /// Baz para (örnek: "USD") için tüm döviz kurlarını getirir
  Future<Map<String, double>?> getExchangeRates(String base) async {
    final url = Uri.parse("https://v6.exchangerate-api.com/v6/$apiKey/latest/$base");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["result"] == "success") {
        // Map<String, double> olarak dönüştür
        final Map<String, double> rates = Map<String, double>.from(
          data["conversion_rates"].map((key, value) => MapEntry(key, (value as num).toDouble())),
        );
        return rates;
      }
    }
    return null;
  }
}
