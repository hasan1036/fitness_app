import 'package:shared_preferences/shared_preferences.dart';

class WeightUnitService {
  WeightUnitService._();

  static const String _unitKey = 'weight_unit';
  static const String kilograms = 'kg';
  static const String pounds = 'lb';
  static const double poundsPerKilogram = 2.2046226218;

  static Future<String> getUnit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String unit = prefs.getString(_unitKey) ?? kilograms;
    return unit == pounds ? pounds : kilograms;
  }

  static Future<void> setUnit(String unit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_unitKey, unit == pounds ? pounds : kilograms);
  }

  static double fromKg(double kg, String unit) {
    return unit == pounds ? kg * poundsPerKilogram : kg;
  }

  static double toKg(double value, String unit) {
    return unit == pounds ? value / poundsPerKilogram : value;
  }

  static String label(String unit) => unit == pounds ? 'lb' : 'kg';

  static String formatKg(double? kg, String unit, {int decimals = 1}) {
    if (kg == null) return '-- ${label(unit)}';
    return '${fromKg(kg, unit).toStringAsFixed(decimals)} ${label(unit)}';
  }
}
