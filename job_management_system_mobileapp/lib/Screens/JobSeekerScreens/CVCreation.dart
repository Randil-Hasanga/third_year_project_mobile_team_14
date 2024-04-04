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
  backgroundColor: Colors.orange.shade800,
  title: const Text(
    'Create your CV Here',
    style: TextStyle(color: Colors.white),
  ),
  bottom: const TabBar(
    labelColor: Colors.white, // Set the tab text color here
    tabs: [
      Tab(text: 'Personal Info'),
      Tab(text: 'Educational'),
      Tab(text: 'Skills'),
      Tab(text: 'Job Expectation'),
    ],
  ),
),

        bottomNavigationBar: BottomAppBar(
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
                          builder: (context) =>ProfileJobSeeker()));
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
                    const Row(
                      children: [
                        Text('Are you a person with special needs?'),
                        Radio(value: true, groupValue: null, onChanged: null),
                        Text('Yes'),
                        Radio(value: false, groupValue: null, onChanged: null),
                        Text('No'),
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

            





    // Educational Tab************************************************************************************

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
                        const Text('Did you pass the Exam?'),
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
                        const Text('Did you pass the Exam?'),
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
 // Skills Tab***************************************************************************************
            
 SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Job Experience:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Job Experience fields
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Year of job experience'),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Current Job Position'),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Date of join'),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Current Employee Name'),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Responsibilities'),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Special Skills'),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Basic Skills:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Basic Skills fields
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Computer Skills'),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Other Special Skills'),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Achievements'),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Extra Curricular Achieves'),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Fields of Training Requirements'),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Area preferred to start Employment'),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Career Guidance Requirements'),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Language Skills:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Language Skills fields
                        _buildLanguageSkillsField('English'),
                        _buildLanguageSkillsField('Tamil'),
                        _buildLanguageSkillsField('Sinhala'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Save'),
                        ),
                        
                      ],
                    ),
                  ),
                ),
 ),

// Job Expectation Tab**************************************************************************
            SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Objectives and References:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Objectives and References fields
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Career Objective'),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Referee [1]'),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Referee [2]'),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Preferred Jobs:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Preferred Jobs fields
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Enter Preferred Jobs'),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Select Preferred Districts to Work:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Select Preferred Districts to Work field
                        DropdownButtonFormField<String>(
                          items: <String>[
                            'Matara',
                            'Galle',
                            'Kaluthara',
                            // Add all districts
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {},
                          decoration: const InputDecoration(labelText: 'Select District'),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Save'),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('CV'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),],
        ),
      ),
    );
  }
  
 Widget _buildLanguageSkillsField(String language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: 'Basic',
                onChanged: (value) {},
                items: <String>['Basic', 'Good', 'Fluent']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Speaking'),
              ),
            ),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: 'Basic',
                onChanged: (value) {},
                items: <String>['Basic', 'Good', 'Fluent']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Reading'),
              ),
            ),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: 'Basic',
                onChanged: (value) {},
                items: <String>['Basic', 'Good', 'Fluent']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Writing'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: CVCreation(),
  ));
}
