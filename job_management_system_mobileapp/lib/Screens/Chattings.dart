import 'package:flutter/material.dart';

class Chattings extends StatelessWidget {
  const Chattings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chattings'), // Set the title of the app bar
      ),
      body: const Center(
        child: Text('Job Seeker and Job Provider Chatting here'), // Placeholder content
      ),
    );
  }
}
