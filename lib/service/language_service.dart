import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  LanguageService._();

  static const String _languageKey = 'app_language_code';

  static final ValueNotifier<Locale> localeNotifier =
      ValueNotifier<Locale>(const Locale('en'));

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('bn'),
    Locale('hi'),
    Locale('ar'),
    Locale('ja'),
    Locale('es'),
  ];

  static Future<void> initialize() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();
    final String code = prefs.getString(_languageKey) ?? 'en';
    localeNotifier.value = _localeForCode(code);
  }

  static Future<void> setLanguage(String code) async {
    final Locale locale = _localeForCode(code);
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
    localeNotifier.value = locale;
  }

  static String get currentCode =>
      localeNotifier.value.languageCode;

  static Locale _localeForCode(String code) {
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == code,
      orElse: () => const Locale('en'),
    );
  }
}
