import 'dart:ffi';
//import 'dart:js';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:quickalert/quickalert.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(vacancies());
}

class vacancies extends StatelessWidget {
  vacancies({super.key});

  final FirebaseService firebaseService = FirebaseService();

  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _jobPositionController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _salaryController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void showAlert() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
      );
    }

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
                            builder: (context) => JobProviderPage()));
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
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _companyNameController,
                      decoration: const InputDecoration(
                          labelText: 'Company Name',
                          hintText: 'Company Name',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _jobPositionController,
                      decoration: const InputDecoration(
                          labelText: 'Job Position',
                          hintText: 'Job Position',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Description',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _salaryController,
                      decoration: const InputDecoration(
                          labelText: 'Salary',
                          hintText: 'Salary',
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                          labelText: 'Location',
                          hintText: 'Location',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter location';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseService().addVacancy(
                            _companyNameController.text,
                            _jobPositionController.text,
                            _descriptionController.text,
                            _salaryController.text,
                            _locationController.text);

                        _companyNameController.clear();
                        _jobPositionController.clear();
                        _descriptionController.clear();
                        _salaryController.clear();
                        _locationController.clear();
                        showAlert();
                      },
                      child: const Text('Add Vacancy'),
                    )
                  ]),
            ),
          ),
        ));
  }
}
