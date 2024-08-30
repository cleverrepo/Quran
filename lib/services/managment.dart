import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier{
  bool isToggle=false;
  bool get _isToggle=>isToggle;
  late SharedPreferences preferences;
// passing custom light theme themeData
  final lightTheme=ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
  );
// passing custom dark theme themeData
  final darkTheme=ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
  );

  changeTheme() async {
    // if true, set it to false and if false, set to true
    isToggle = !isToggle;
    // storing the theme
    await preferences.setBool("_isToggle", isToggle);
    // updating the ui
    notifyListeners();
  }
  initTheme()async{
    preferences=await  SharedPreferences.getInstance();
    // getting the current theme
    isToggle=preferences.getBool("_isToggle")??false;
    notifyListeners();
  }
}