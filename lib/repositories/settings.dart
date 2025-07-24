import 'package:shared_preferences/shared_preferences.dart';


class Settings{

  static const _darkModeKey = 'dark_mode';

  //salva a preferencia do modo escuro

  static Future<void> setDarkMode(bool value) async {

   final prefs = await SharedPreferences.getInstance();
   await prefs.setBool(_darkModeKey, value);

  }

  //Recupera a preferencia do modo escuro

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }
  

}