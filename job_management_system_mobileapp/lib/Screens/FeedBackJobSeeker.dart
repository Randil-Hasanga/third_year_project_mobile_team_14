import 'package:flutter/material.dart';

class FeedBackJobSeeker extends StatelessWidget {
  const FeedBackJobSeeker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FeedBack-Job Seeker'), // Set the title of the app bar
      ),
      body: const Center(
        child: Text('Welcome to the Feedback-Job Seeker!'), // Placeholder content
      ),
    );
  }
}
