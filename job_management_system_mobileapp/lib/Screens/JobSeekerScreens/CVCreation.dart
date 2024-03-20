import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/Chattings.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';

class CVCreation extends StatefulWidget {
  const CVCreation({Key? key}) : super(key: key);

  @override
  _CVCreationState createState() => _CVCreationState();
}

class _CVCreationState extends State<CVCreation> {
  // Define variables to hold CV information
 String name = '';
  String email = '';
  String mobileTel = '';
  String homeTel = '';
  String address = '';
  String district = '';
  String divisionalSecretariat = '';
  String gceOLYear = '';
  String gceOLIndexNo = '';
  String gceOLMedium = '';
  String gceOLSchool = '';
  String gceOLAttempt = '';
  bool gceOLPassedExam = false;
  String gceALYear = '';
  String gceALIndexNo = '';
  String gceALMedium = '';
  String gceALSchool = '';
  String gceALAttempt = '';
  bool gceALPassedExam = false;
  String professionalQualificationName = '';
  String professionalInstituteName = '';
  String professionalDuration = '';
    String selectedEducationalLevel = 'Below O/L';
  String selectedProfessionalLevel = 'NVQ1';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 136, 0),
          title: const Text('Create your CV'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Personal Info'),
              Tab(text: 'Educational'),
              Tab(text: 'Skills'),
              Tab(text: 'Job Expectation'),
            ],
          ),
        ), bottomNavigationBar: BottomAppBar(
        color: Colors.orange.shade800,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const JobSeekerPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings,
                    color: Color.fromARGB(
                        255, 255, 255, 255)), // Change the color here
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const NotificationsJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Chattings()));
                },
              ),
            ],
          ),
        ),
      ),
        body: TabBarView(
          children: [
            // Personal Info Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: 'Mr',
                      onChanged: (value) {},
                      items: <String>['Dr', 'Miss', 'Mr', 'Mrs', 'Prof']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    DropdownButtonFormField<String>(
                      value: 'Male',
                      onChanged: (value) {},
                      items: <String>['Male', 'Female']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(labelText: 'Gender'),
                    ),
                    DropdownButtonFormField<String>(
                      value: 'Full Time',
                      onChanged: (value) {},
                      items: <String>['Part Time', 'Full Time']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(labelText: 'Job Type'),
                    ),
                    DropdownButtonFormField<String>(
                      value: 'Government',
                      onChanged: (value) {},
                      items: <String>[
                        'Government',
                        'Private',
                        'Semi Government'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration:
                          const InputDecoration(labelText: 'Working Sector'),
                    ),
                    DropdownButtonFormField<String>(
                      value: 'Unmarried',
                      onChanged: (value) {},
                      items: <String>['Married', 'Unmarried']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration:
                          const InputDecoration(labelText: 'Marital Status'),
                    ),
                    DropdownButtonFormField<String>(
                      value: 'Employed',
                      onChanged: (value) {},
                      items: <String>['Employed', 'Not Employed']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                          labelText: 'Current Job Status'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Name With Initials *'),
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Full Name *'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Nationality (Eg: Srilanka)'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'NIC'),
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Driving License'),
                    ),
                    const SizedBox(height: 20),
                    const Text('Select Date of Birth:'), // Placeholder for Calendar
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Religion'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Age'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Email Address'),
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Tel (Mobile)'),
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Tel (Home)'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Address'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'District'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Divisional Secretariat'),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text('Are you a person with special needs?'),
                        Radio(value: true, groupValue: null, onChanged: null),
                        const Text('Yes'),
                        Radio(value: false, groupValue: null, onChanged: null),
                        const Text('No'),
                      ],
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Minimum Salary Expectation (LKR)'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
            // Educational Tab
SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Highest Qualification Levels Section
                    const Text(
                      'Highest Qualification Levels:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Educational Dropdown
                    DropdownButtonFormField<String>(
              value: selectedEducationalLevel,
              onChanged: (value) {
                setState(() {
                  selectedEducationalLevel = value!;
                });
              },
              items: <String>[
                'Below O/L',
                'Passed O/L',
                'Passed A/L',
                'Graduate',
                'Post Graduate Diploma'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Educational Qualification Level'),
            ),
            const SizedBox(height: 20),
            // Professional Qualification Dropdown
            DropdownButtonFormField<String>(
              value: selectedProfessionalLevel,
              onChanged: (value) {
                setState(() {
                  selectedProfessionalLevel = value!;
                });
              },
              items: <String>[
                'NVQ1',
                'NVQ2',
                'NVQ3',
                'NVQ4',
                'NVQ5',
                'NVQ6',
                'NVQ7'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Professional Qualification Level'),
            ),
                    const SizedBox(height: 20),
                    // Educational Qualification Section
                    const Text(
                      'Educational Qualification:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // GCE O/L Exam Section
                    const Text(
                      'GCE O/L Exam:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Year'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Index No'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Medium'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'School'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Attempt'),
                    ),
                    Row(
                      children: [
                        Text('Did you pass the Exam?'),
                        Checkbox(
                          value: gceOLPassedExam,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // GCE A/L Exam Section
                    const Text(
                      'GCE A/L Exam:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Year'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Index No'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Medium'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'School'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Attempt'),
                    ),
                    Row(
                      children: [
                        Text('Did you pass the Exam?'),
                        Checkbox(
                          value: gceALPassedExam,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Professional Qualifications Section
                    const Text(
                      'Professional Qualifications:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Qualification Name'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Institute Name'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Duration'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
            // Skills Tab
            Center(
              child: Text('Skills Tab Placeholder'),
            ),
            // Job Expectation Tab
            Center(
              child: Text('Job Expectation Tab Placeholder'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CVCreation(),
  ));
}
