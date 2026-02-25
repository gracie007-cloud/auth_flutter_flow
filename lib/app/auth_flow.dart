import 'package:auth_flow/app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:auth_flow/app/pages/login_page.dart';

class AuthFlow extends StatelessWidget {
  const AuthFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Flow',
      theme: ThemeData(
        primaryColor: Colors.green.shade500,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green.shade500,
          primary: Colors.green.shade500,
        ),
      ),
      home: const LoginPage(),
      routes: {
        HomePage.routeName: (BuildContext context) => const HomePage(),
      },
    );
  }
}
