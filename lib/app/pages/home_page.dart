import 'dart:async';
import 'package:auth_flow/app/utils/auth_utils.dart';
import 'package:auth_flow/app/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static final String routeName = 'home';
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SharedPreferences? _sharedPreferences;
  dynamic _authToken, _id, _name, _homeResponse;

  @override
  void initState() {
    super.initState();
    _fetchSessionAndNavigate();
  }

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    final authToken = AuthUtils.getToken(_sharedPreferences!);
    final id = _sharedPreferences!.getInt(AuthUtils.userIdKey);
    final name = _sharedPreferences!.getString(AuthUtils.nameKey);
    print(authToken);
    _fetchHome(authToken);
    setState(() {
      _authToken = authToken;
      _id = id;
      _name = name;
    });
    if (_authToken == null) _logout();
  }

  _fetchHome(String? authToken) async {
    final responseJson = await NetworkUtils.fetch(authToken, '/api/v1/home');
    if (responseJson == null) {
      NetworkUtils.showSnackBar(context, 'Something went wrong!');
    } else if (responseJson == 'NetworkError') {
      NetworkUtils.showSnackBar(context, null);
    } else if (responseJson['errors'] != null) {
      _logout();
    }
    setState(() { _homeResponse = responseJson.toString(); });
  }

  _logout() {
    NetworkUtils.logoutUser(context, _sharedPreferences);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('Home')),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'USER_ID: $_id\nUSER_NAME: $_name\nHOME_RESPONSE: $_homeResponse',
                style: TextStyle(fontSize: 24.0, color: Colors.grey.shade700),
              ),
            ),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              onPressed: _logout,
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
