import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';

class vacancies extends StatelessWidget {
  const vacancies({Key? key}) : super(key: key);

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
        body: const SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Company Name', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Job Position', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Description', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Salary', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Location', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: null,
                    child: Text('Submit'),
                  )
                ]),
          ),
        ));
  }
}
