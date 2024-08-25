import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
      ),
      body: _buildJobSeekersList(),
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
    String eduStatus = userData['EduQalification'];

    return JobSeekerTile(name: name, eduStatus: eduStatus);
  }
}
