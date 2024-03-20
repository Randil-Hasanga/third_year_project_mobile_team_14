import 'package:flutter/material.dart';

class vacancies extends StatelessWidget {
  const vacancies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vacancy'), // Set the title of the app bar
      ),
      body: const Center(
        child: Text('Job Provider vacancy is here'), // Placeholder content
      ),
    );
  }
}
