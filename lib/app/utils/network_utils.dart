import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'auth_utils.dart';

class NetworkUtils {
  static final String host = productionHost;
  static final String productionHost = 'https://authflow.herokuapp.com';
  static final String developmentHost = 'http://192.168.31.110:3000';

  static dynamic authenticateUser(String email, String password) async {
    final uri = Uri.parse(host + AuthUtils.endPoint);
    try {
      final response = await http.post(
        uri,
        body: {'email': email, 'password': password},
      );
      return json.decode(response.body);
    } catch (exception) {
      print(exception);
      return exception.toString().contains('SocketException') ? 'NetworkError' : null;
    }
  }

  static void logoutUser(BuildContext? context, SharedPreferences? prefs) {
    prefs?.remove(AuthUtils.authTokenKey);
    prefs?.remove(AuthUtils.userIdKey);
    prefs?.remove(AuthUtils.nameKey);
    if (context != null) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  static void showSnackBar(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'You are offline')),
    );
  }

  static dynamic fetch(dynamic authToken, dynamic endPoint) async {
    final uri = Uri.parse(host + endPoint);
    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': authToken},
      );
      return json.decode(response.body);
    } catch (exception) {
      print(exception);
      return exception.toString().contains('SocketException') ? 'NetworkError' : null;
    }
  }
}
