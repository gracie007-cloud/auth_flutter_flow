import 'dart:async';
import 'package:auth_flow/app/pages/home_page.dart';
import 'package:auth_flow/app/utils/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_flow/app/utils/network_utils.dart';
import 'package:auth_flow/app/validators/email_validator.dart';
import 'package:auth_flow/app/components/error_box.dart';
import 'package:auth_flow/app/components/email_field.dart';
import 'package:auth_flow/app/components/password_field.dart';
import 'package:auth_flow/app/components/login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SharedPreferences? _sharedPreferences;
  bool _isError = false;
  bool _obscureText = true;
  bool _isLoading = false;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  String? _errorText, _emailError, _passwordError;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _fetchSessionAndNavigate();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    final authToken = AuthUtils.getToken(_sharedPreferences!);
    if (authToken != null && mounted) {
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }
  }

  void _showLoading() => setState(() => _isLoading = true);
  void _hideLoading() => setState(() => _isLoading = false);

  _authenticateUser() async {
    _showLoading();
    if (_valid()) {
      final responseJson = await NetworkUtils.authenticateUser(
        _emailController.text,
        _passwordController.text,
      );
      print(responseJson);
      if (!mounted) return;
      if (responseJson == null) {
        NetworkUtils.showSnackBar(context, 'Something went wrong!');
      } else if (responseJson == 'NetworkError') {
        NetworkUtils.showSnackBar(context, null);
      } else if (responseJson['errors'] != null) {
        NetworkUtils.showSnackBar(context, 'Invalid Email/Password');
      } else {
        AuthUtils.insertDetails(_sharedPreferences!, responseJson);
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      }
      _hideLoading();
    } else {
      setState(() => _isLoading = false);
    }
  }

  bool _valid() {
    bool valid = true;
    _emailError = null;
    _passwordError = null;
    if (_emailController.text.isEmpty) {
      valid = false;
      _emailError = "Email can't be blank!";
    } else if (!_emailController.text.contains(EmailValidator.regex)) {
      valid = false;
      _emailError = "Enter valid email!";
    }
    if (_passwordController.text.isEmpty) {
      valid = false;
      _passwordError = "Password can't be blank!";
    } else if (_passwordController.text.length < 6) {
      valid = false;
      _passwordError = "Password is invalid!";
    }
    return valid;
  }

  Widget _loginScreen() {
    return ListView(
      padding: const EdgeInsets.only(top: 100.0, left: 16.0, right: 16.0),
      children: <Widget>[
        ErrorBox(isError: _isError, errorText: _errorText),
        EmailField(emailController: _emailController, emailError: _emailError),
        PasswordField(
          passwordController: _passwordController,
          obscureText: _obscureText,
          passwordError: _passwordError,
          togglePassword: _togglePassword,
        ),
        LoginButton(onPressed: _authenticateUser),
      ],
    );
  }

  void _togglePassword() => setState(() => _obscureText = !_obscureText);

  Widget _loadingScreen() {
    return Container(
      margin: const EdgeInsets.only(top: 100.0),
      child: Center(
        child: Column(
          children: <Widget>[
            const CircularProgressIndicator(strokeWidth: 4.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Please Wait',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? _loadingScreen() : _loginScreen(),
    );
  }
}
