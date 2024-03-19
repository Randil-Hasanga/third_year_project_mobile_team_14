import 'package:flutter/material.dart';

class Chattings extends StatelessWidget {
  const Chattings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vacancies '), // Set the title of the app bar
      ),
      body: const Center(
        child: Text('Job providers can Publish job vacancies here'), // Placeholder content
      ),
    );
  }
}
