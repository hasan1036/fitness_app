import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String _nameKey = "profile_name";
  static const String _imageKey = "profile_image_path";

  static Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey) ?? "Code For Any";
  }

  static Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }

  static Future<String?> getImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_imageKey);
  }

  static Future<void> saveImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imageKey, path);
  }
}