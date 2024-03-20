import 'package:flutter/material.dart';

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
                    Text('Select Date of Birth:'), // Placeholder for Calendar
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
            Center(
              child: Text('Educational Tab Placeholder'),
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
