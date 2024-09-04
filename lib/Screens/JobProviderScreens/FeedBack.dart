import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/feedback_stepper.dart';
import 'package:job_management_system_mobileapp/colors/colors.dart';
import 'package:job_management_system_mobileapp/componets/user_title_feedback.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';

class Feedback_page extends StatefulWidget {
  String? vacancyId;

  Feedback_page({super.key, required this.vacancyId});

  @override
  State<Feedback_page> createState() => _Feedback_pageState();
}

class _Feedback_pageState extends State<Feedback_page> {
  FirebaseService? firebaseService;

  @override
  void initState() {
    super.initState();
    firebaseService = GetIt.instance.get<FirebaseService>();
  }

  Future<String> getApplicantName(String applicantId) async {
    DocumentSnapshot snapshot =
        await firebaseService!.cvDetailsCollection.doc(applicantId).get();

    if (snapshot.exists) {
      return snapshot['fullname'] ?? 'no name found';
    }
    return 'no document found';
  }

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
        backgroundColor: appBarColor,
      ),
      body: _buildApplicantsList(),
    );
  }

  Widget _buildApplicantsList() {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          firebaseService!.vacancyCollection.doc(widget.vacancyId).snapshots(),
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
            String applicantId = applicantsList[index];

            return FutureBuilder<String>(
                future: getApplicantName(applicantId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return UserTitleFeedback(text: 'Error');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return UserTitleFeedback(text: 'Loading');
                  } else {
                    return UserTitleFeedback(
                      text: snapshot.data ?? 'No name Found',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeedbackStepper(
                                applicantId: applicantId,
                                vacancyId: widget.vacancyId!),
                          ),
                        );
                      },
                    );
                  }
                });
          },
        );
      },
    );
  }
}
