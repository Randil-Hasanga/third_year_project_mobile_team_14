import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/colors/colors.dart';
import 'package:job_management_system_mobileapp/componets/user_title_feedback.dart';
import 'package:job_management_system_mobileapp/componets/vacancy_tile.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';

class MyVacanices extends StatefulWidget {
  const MyVacanices({super.key});

  @override
  State<MyVacanices> createState() => _MyVacanicesState();
}

class _MyVacanicesState extends State<MyVacanices> {
  FirebaseService? _firebaseService;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'My Vacancies',
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth! * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: appBarColor,
      ),
      body: _jobVacancyList(),
    );
  }

  Widget _jobVacancyList() {
    return StreamBuilder(
        stream: _firebaseService!.getVacancyDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('Loading...'),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userdata) => _buildVacancyListItems(userdata, context))
                .toList(),
          );
        });
  }

  Widget _buildVacancyListItems(
      Map<String, dynamic> userData, BuildContext context) {
    String jobPosition = userData['job_position'];
    String jobType = userData['job_type'];
    String location = userData['location'];
    double salary = userData['minimum_salary'];

    return VacancyTile(
        jobPosition: jobPosition,
        jobType: jobType,
        location: location,
        salary: salary);
  }
}
