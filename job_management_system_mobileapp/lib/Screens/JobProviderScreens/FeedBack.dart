import 'package:flutter/material.dart';

class Feedback_page extends StatefulWidget {
  const Feedback_page({super.key});

  @override
  State<Feedback_page> createState() => _Feedback_pageState();
}

class _Feedback_pageState extends State<Feedback_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applicants'),
      ),
    );
  }
}
