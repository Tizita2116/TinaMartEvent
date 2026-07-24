import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {

  bool isDark = false;


  void toggleTheme(bool value){

    isDark = value;

    notifyListeners();

  }


  ThemeMode get themeMode {

    return isDark 
      ? ThemeMode.dark 
      : ThemeMode.light;

  }

}