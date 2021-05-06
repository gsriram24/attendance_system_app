import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth with ChangeNotifier {
  String _token;

  Future<void> login(String email, String password) async {
    var storage = FlutterSecureStorage();
    final response = await Dio().post(
        'https://attendancesystemadmin.herokuapp.com/api/teacher/login',
        data: {'email': email, 'password': password});
    final responseData = json.decode(response.toString());
    storage.write(key: 'token', value: responseData['token']);
    _token = responseData['token'];
    notifyListeners();
  }

  bool get isAuth {
    return _token != null;
  }

  String get token {
    return _token;
  }

  Future<bool> tryAutoLogin() async {
    var storage = FlutterSecureStorage();
    var value = await storage.read(key: "token");
    if (value == null) {
      return false;
    }
    _token = value;
    notifyListeners();
    return true;
  }

  void logout() async {
    _token = null;
    var storage = FlutterSecureStorage();
    await storage.delete(key: "token");
    notifyListeners();
  }
}
