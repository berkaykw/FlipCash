import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/expense.dart';

class ExpenseStorage {
  /// Harcamaları kaydet
  static Future<void> saveExpenses(
      String countryName, String currency, List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${countryName}_$currency'; // Ülke ve para birimi kombinasyonu
    final encoded = expenses.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(key, encoded);
  }

  /// Harcamaları yükle
  static Future<List<Expense>> loadExpenses(
      String countryName, String currency) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${countryName}_$currency';
    final saved = prefs.getStringList(key);
    if (saved == null) return [];
    return saved.map((e) => Expense.fromMap(jsonDecode(e))).toList();
  }

  /// Belirli ülke ve para birimi için tüm harcamaları temizle
  static Future<void> clearExpenses(
      String countryName, String currency) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${countryName}_$currency';
    await prefs.remove(key);
  }

  /// Belirli harcamayı kaldır
  static Future<void> removeExpense(
      String countryName, String currency, Expense expense) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${countryName}_$currency';
    final saved = prefs.getStringList(key);
    if (saved == null) return;

    List<String> updated = saved.where((item) {
      final e = Expense.fromMap(jsonDecode(item));
      return !(e.amount == expense.amount &&
          e.description == expense.description &&
          e.currency == expense.currency);
    }).toList();

    await prefs.setStringList(key, updated);
  }
}
