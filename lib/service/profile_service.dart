import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String _nameKey = "profile_name";
  static const String _imageKey = "profile_image_path";

  static Future<String> getName() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    final String savedName =
        prefs.getString(_nameKey)?.trim() ?? "";

    if (savedName.isEmpty ||
        savedName == "Code For Any" ||
        savedName == "Code For Jannat") {
      return "Name";
    }

    return savedName;
  }

  static Future<void> saveName(String name) async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    final String cleanName = name.trim();

    await prefs.setString(
      _nameKey,
      cleanName.isEmpty ? "Name" : cleanName,
    );
  }

  static Future<String?> getImagePath() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();
    return prefs.getString(_imageKey);
  }

  static Future<void> saveImagePath(String path) async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();
    await prefs.setString(_imageKey, path);
  }
}
