import 'package:flutter/material.dart';
import 'package:grocery/utils/colors.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String id = 'register-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: olive,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Hero(
                tag: 'logo',
                child: Image.asset('assets/images/logo.png'),
              ),
              const TextField(),
              const TextField(),
              const TextField(),
              const TextField(),
            ],
          ),
        ),
      ),
    );
  }
}
