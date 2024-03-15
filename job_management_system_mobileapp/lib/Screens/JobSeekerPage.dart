import 'package:flutter/material.dart';

class JobSeekerPage extends StatelessWidget {
  const JobSeekerPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Seeker Page"),
      ),
      body: const Center(
        child: Text("Welcome to Job Seeker Page"),
      ),
    );
  }
}
