import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/water_history_model.dart';

class WaterHistoryService {
  static const String _historyKey = "water_history";

  static Future<List<WaterHistoryModel>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();

    final String? jsonString = prefs.getString(_historyKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List decoded = jsonDecode(jsonString);

    return decoded
        .map(
          (e) => WaterHistoryModel.fromJson(e),
    )
        .toList();
  }

  static Future<void> saveToday({
    required int glasses,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final List<WaterHistoryModel> history =
    await loadHistory();

    final String today = _today();

    history.removeWhere(
          (e) => e.date == today,
    );

    history.add(
      WaterHistoryModel(
        date: today,
        glasses: glasses,
        milliliters: glasses * 250,
      ),
    );

    history.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    final String jsonString = jsonEncode(
      history
          .map((e) => e.toJson())
          .toList(),
    );

    await prefs.setString(
      _historyKey,
      jsonString,
    );
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_historyKey);
  }

  static String _today() {
    final now = DateTime.now();

    return "${now.year}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.day.toString().padLeft(2, '0')}";
  }
}