import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  Image backgroundImage = Image.asset('assets/images/dark.jpg');

  bool get isDarkMode => _isDarkMode;

  // for initialing the theme
  ThemeProvider() {
     _loadThemePreference();
    backgroundImage = _isDarkMode
        ? Image.asset('assets/images/dark.jpg')
        : Image.asset('assets/images/dark.jpg');
  }

  // Toggles theme mode
  void toggleTheme(bool isDark) async {
    _isDarkMode = isDark;
    await _saveThemePreference(isDark);
    notifyListeners();
  }

  // for checking and retrieving the saved theme
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners(); // Ensure UI updates after loading
  }

  // for saving the theme so that it does not get resetted each time when entering the app
  Future<void> _saveThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  // Returns the current theme mode
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
}
