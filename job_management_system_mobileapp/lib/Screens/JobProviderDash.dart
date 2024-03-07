import 'package:flutter/material.dart';

class JobProviderDash extends StatelessWidget {
  const JobProviderDash({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Provider Dashboard'),
      ),
      body: const Center(
        child: Text('Welcome to Job Provider Dashboard'),
      ),
    );
  }
}
