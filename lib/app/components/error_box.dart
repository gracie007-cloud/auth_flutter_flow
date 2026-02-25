import 'package:flutter/material.dart';

class ErrorBox extends StatelessWidget {
  final bool? isError;
  final String? errorText;
  const ErrorBox({super.key, this.isError, this.errorText});

  @override
  Widget build(BuildContext context) {
    if (isError == true) {
      return Container(
        child: Column(
          children: <Widget>[
            Image.asset('lib/app/assets/logo.png'),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: const Color(0xFFFF3F3F)),
                borderRadius: BorderRadius.circular(32.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              margin: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: Text(
                  errorText ?? '',
                  style: TextStyle(color: Colors.red.shade500),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Image.asset('lib/app/assets/logo.png'),
      );
    }
  }
}
