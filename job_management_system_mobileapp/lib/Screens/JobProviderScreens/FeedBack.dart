import 'package:flutter/material.dart';

class Feedback_page extends StatefulWidget {
  String? vacancyId;

  Feedback_page({super.key, required this.vacancyId});

  @override
  State<Feedback_page> createState() => _Feedback_pageState();
}

class _Feedback_pageState extends State<Feedback_page> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
<<<<<<< Updated upstream
        title: Text('Feedback Page'),
=======
        title: Text(
          'Applicants',
          style: TextStyle(
            color: Colors.black,
            fontSize: screenWidth! * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
>>>>>>> Stashed changes
      ),
      // body: _buildApplicantsList(),
    );
  }
}
