import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/FeedBack.dart';
import 'package:job_management_system_mobileapp/componets/interview_details_tile.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';

class FeedbackHome extends StatefulWidget {
  const FeedbackHome({super.key});

  @override
  State<FeedbackHome> createState() => _FeedbackHomeState();
}

class _FeedbackHomeState extends State<FeedbackHome> {
  FirebaseService? _firebaseService;
  String? vacancyId;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Interviews List',
          style: TextStyle(
            color: Colors.black,
            fontSize: screenWidth! * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildInterviewDetailsList(),
    );
  }

  Widget _buildInterviewDetailsList() {
    return StreamBuilder(
      stream: _firebaseService!.getInterviewDetails(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Text('Error');
        }

        //loading
        if (ConnectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }

        //data is null
        if (snapshot.data == null) {
          return const Text("No users found");
        }

        //return Listview
        return ListView(
          children: snapshot.data!
              .map<Widget>(
                  (userdata) => _buildInterviewListItems(userdata, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildInterviewListItems(
      Map<String, dynamic> userdata, BuildContext context) {
    vacancyId = userdata['vacancy_id'];
    return InterviewDetailsTile(
      text: userdata['topic'],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Feedback_page(vacancyId: vacancyId),
          ),
        );
      },
    );
  }
}
