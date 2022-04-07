import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shop/widgets/httpException.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  late Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  get token {
    if (_expiryDate != null && _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  get uid {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyD-5IuY8NGM0rtq596ILG9w449TR9BFPhw');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final extractedData = json.decode(response.body);
      if (extractedData['error'] != null) {
        // print('hbhjhj');
        throw HttpException(extractedData['error']['message']);
      }
      _token = extractedData['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(extractedData['expiresIn'])));
      _userId = extractedData['localId'];
      notifyListeners();
      autoLogout();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'uid': _userId,
        'expiryDate': _expiryDate!.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (e) {
      print(e);
      throw e;
    }

    // print(json.decode(response.body));
  }

  Future<void> signUp(String email, String password) {
    return _authenticate(email, password, 'signUp');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userData = json.decode(prefs.getString('userData')!);
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = userData['token'];
    _userId = userData['uid'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> login(String email, String password) {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _expiryDate = null;
    _token = null;
    _userId = null;
    _authTimer.cancel();
    final prefs = await SharedPreferences.getInstance();

    prefs.remove('userData');
    notifyListeners();

    // print('hjh');
  }

  void autoLogout() {
    final expiryTime = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expiryTime), logout);
  }
}
