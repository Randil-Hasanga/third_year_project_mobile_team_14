import 'package:flutter/material.dart';

class ProfileJobSeeker extends StatelessWidget {
  const ProfileJobSeeker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotificationsJobSeeker-Job Seeker'), // Set the title of the app bar
      ),
      body: const Center(
        child: Text('NotificationsJobSeeker-Job Seeker!'), // Placeholder content
      ),
    );
  }
}
