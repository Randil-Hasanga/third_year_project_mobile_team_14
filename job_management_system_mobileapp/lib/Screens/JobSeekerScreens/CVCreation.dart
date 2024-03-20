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
  String phone = '';
  String address = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CV Creation'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Personal Information'),
              Tab(text: 'Education & Experience'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // First tab content: Personal Information
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Full Name'),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Phone'),
                    onChanged: (value) {
                      setState(() {
                        phone = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Address'),
                    onChanged: (value) {
                      setState(() {
                        address = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Submit the CV data
                      // You can add logic here to save the CV data
                      // For example, send it to a server or store it locally
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),

            // Second tab content: Education & Experience
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add form fields for education and experience
                  Text('Education & Experience'),
                  // Add more form fields as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
