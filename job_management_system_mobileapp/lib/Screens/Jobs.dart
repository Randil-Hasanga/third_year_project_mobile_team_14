import 'package:flutter/material.dart';

class Jobs extends StatelessWidget {
  const Jobs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'), // Set the title of the app bar
      ),
      body: const Center(
        child: Text('Welcome to the Jobs Page!'), // Placeholder content
      ),
    );
  }
}
