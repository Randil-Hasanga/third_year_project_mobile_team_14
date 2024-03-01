import 'package:flutter/material.dart';

class JobSeekerDash extends StatelessWidget {
  const JobSeekerDash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Seeker Dashboard'),
      ),
      body: const Center(
        child: Text('Welcome to Job Seeker Dashboard!'),
      ),
    );
  }
}
