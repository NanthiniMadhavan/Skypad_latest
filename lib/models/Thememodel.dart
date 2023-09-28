import 'package:flutter/material.dart';

import '../Utilities/Theme.dart';

enum AppTheme { Light, Dark, Custom }

class ThemeProvider extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.Custom;

  ThemeData get currentTheme {
    switch (_currentTheme) {
      case AppTheme.Light:
        return lightTheme;
      case AppTheme.Dark:
        return darkTheme;
      case AppTheme.Custom:
      default:
        return customDefaultTheme;
    }
  }

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
