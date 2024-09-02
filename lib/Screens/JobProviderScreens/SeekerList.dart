import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/colors/colors.dart';
import 'package:job_management_system_mobileapp/componets/job_seekers_tile.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';

class JobSeekerList extends StatefulWidget {
  const JobSeekerList({super.key});

  @override
  State<JobSeekerList> createState() => _JobSeekerListState();
}

class _JobSeekerListState extends State<JobSeekerList> {
  FirebaseService? _firebaseService;
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
          'Job Seeker List',
          style: TextStyle(
            color: Colors.black,
            fontSize: screenWidth! * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: appBarColor,
      ),
      body: _buildApplicantListByProvider(),
    );
  }

  Widget _buildJobSeekersList() {
    return StreamBuilder(
      stream: _firebaseService!.getJobSeekerStream(),
      builder: (context, snapshot) {
        // error
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

        return ListView(
          children: snapshot.data!
              .map<Widget>(
                  (userData) => _buildJobSeekerListItems(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildJobSeekerListItems(
      Map<String, dynamic> userData, BuildContext context) {
    String name = userData['fullname'];

    return JobSeekerTile(name: name);
  }

  Widget _buildApplicantListByProvider() {
    return FutureBuilder(
      future: _firebaseService!.getAllApplicantUidsByJobProvider(
          _firebaseService!.getCurrentUserUid()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("there is a error to view data"),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("no applicant found"),
          );
        }

        List<String> applicantUids = snapshot.data!;

        return _buildApplicantDetails(applicantUids);
      },
    );
  }

  Widget _buildApplicantDetails(List<String> applicantUids) {
    return FutureBuilder(
      future: _firebaseService!.getApplicantsDetails(applicantUids),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("there is a error to view data"),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("no applicant found"),
          );
        }
        List<DocumentSnapshot> applicantDetails = snapshot.data!;

        return _buildApplicantList(applicantDetails);
      },
    );
  }

  Widget _buildApplicantList(List<DocumentSnapshot> applicantDetails) {
    return ListView.builder(
      itemCount: applicantDetails.length,
      itemBuilder: (context, index) {
        var applicantData =
            applicantDetails[index].data() as Map<String, dynamic>;
        return JobSeekerTile(name: applicantData['fullname']);
      },
    );
  }
}
