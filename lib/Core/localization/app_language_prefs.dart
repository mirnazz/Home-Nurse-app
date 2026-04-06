import 'package:shared_preferences/shared_preferences.dart';

class AppLanguagePrefs {
  static const String _key = 'app_language';
  static const String defaultCode = 'en';

  static Future<void> saveLanguage(String code) async {
    if (code != 'en' && code != 'ar') return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code == 'ar' || code == 'en') return code!;
    return defaultCode;
  }
}
