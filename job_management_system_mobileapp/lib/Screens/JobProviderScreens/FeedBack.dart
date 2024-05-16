import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/componets/user_title.dart';

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
        title: Text(
          'Applicants',
          style: TextStyle(
            color: Colors.black,
            fontSize: screenWidth! * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildApplicantsList(),
    );
  }

  Widget _buildApplicantsList() {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          firebaseService.vacancyCollection.doc(widget.vacancyId).snapshots(),
      builder: (Context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }
        if (snapshot.data == null) {
          return const Text('No data found');
        }
        var applicants = snapshot.data!.data() as Map<String, dynamic>?;

        if (applicants == null || !applicants.containsKey('applied_by')) {
          return const Text('No applicants found');
        }
        List<dynamic> applicantsList = applicants['applied_by'];

        return ListView.builder(
          itemCount: applicantsList.length,
          itemBuilder: (context, index) {
            String applicantId = applicantsList[index].toString();
            return UserTile(text: applicantId);
          },
        );
      },
    );
  }
}
