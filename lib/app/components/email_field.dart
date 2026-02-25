import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController? emailController;
  final String? emailError;
  const EmailField({super.key, this.emailController, this.emailError});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
          errorText: emailError,
          labelText: 'Email',
        ),
      ),
    );
  }
}
