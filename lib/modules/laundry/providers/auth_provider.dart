import 'package:flutter/material.dart';
import 'package:mksc_mobile/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenProvider with ChangeNotifier {
  String _token = '';

  String get token => _token;

  set token(String value) {
    _token = value;
    notifyListeners();
  }

  Future<bool> isTokenExpired() async {
    const tokenExpiryDuration = Duration(hours: 4);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.laundrytoken);
    final savedTimeString = prefs.getString(Constants.laundryTokenTimestamp);

    if (token == null || savedTimeString == null) {
      return true;
    }

    final savedTime = DateTime.tryParse(savedTimeString);
    if (savedTime == null) {
      return true;
    }

    final currentTime = DateTime.now();
    final difference = currentTime.difference(savedTime);

    return difference > tokenExpiryDuration;
  }
}
