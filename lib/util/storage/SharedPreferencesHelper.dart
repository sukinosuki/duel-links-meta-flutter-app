import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  static SharedPreferences? _prefs;


  static get instance async{
    if (_prefs != null) {
      return _prefs;
    }

    return await SharedPreferences.getInstance();
  }
}