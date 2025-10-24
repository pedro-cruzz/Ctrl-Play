import 'package:flutter/material.dart';
import 'package:project/views/login/widgets/login_form.dart'; // 👈 importa o widget do formulário

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 80),
              const SizedBox(height: 32),
              const LoginForm(), // 👈 formulário separado
            ],
          ),
        ),
      ),
    );
  }
}
