import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password Page"),
      ),
      body: const Center(
        child: Text("Welcome to Forgot Password Page"),
      ),
    );
  }
}
