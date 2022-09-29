import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenProvider with ChangeNotifier{
  String? tokenData='';
  getToken()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    tokenData = sharedPreferences.getString('token');
    notifyListeners();
  }
}