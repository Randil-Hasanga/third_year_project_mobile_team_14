import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(vacancies());
}

class vacancies extends StatelessWidget {
  vacancies({super.key});

  final _companyNameController = TextEditingController();
  final _jobPositionController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _salaryController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Vacancy'), // Set the title of the app bar
          backgroundColor: const Color.fromARGB(255, 255, 136, 0),
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color.fromARGB(255, 255, 136, 0),
          shape: const CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const JobProviderPage()));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileJobSeeker()));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>const ));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chat),
                  onPressed: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>const ));
                  },
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _companyNameController,
                    decoration: InputDecoration(
                        labelText: 'Company Name',
                        hintText: 'Company Name',
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _jobPositionController,
                    decoration: InputDecoration(
                        labelText: 'Job Position',
                        hintText: 'Job Position',
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Description',
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _salaryController,
                    decoration: InputDecoration(
                        labelText: 'Salary',
                        hintText: 'Salary',
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                        labelText: 'Location',
                        hintText: 'Location',
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      CollectionReference vacancies =
                          FirebaseFirestore.instance.collection('vacancy');
                      vacancies.add({
                        'company_name': _companyNameController.text,
                        'job_position': _jobPositionController.text,
                        'description': _descriptionController.text,
                        'salary': _salaryController.text,
                        'location': _locationController.text,
                      });
                    },
                    child: Text('Add Vacancy'),
                  )
                ]),
          ),
        ));
  }
}
