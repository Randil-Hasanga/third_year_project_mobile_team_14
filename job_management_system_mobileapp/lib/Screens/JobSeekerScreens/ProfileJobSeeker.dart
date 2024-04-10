import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProfileJobSeeker());
}

class ProfileJobSeeker extends StatefulWidget {
  // ignore: use_super_parameters
  ProfileJobSeeker({Key? key}) : super(key: key);

  final FirebaseService firebaseService = FirebaseService();

  @override
  _ProfileJobSeekerState createState() => _ProfileJobSeekerState();
}

class _ProfileJobSeekerState extends State<ProfileJobSeeker> {
  String? _selectedGender;
  String? _selectedMaritalStatus;
  String? _selectedNationality;
  String? _selectedDistrict;
  String? _selectedDivisionalSecretariat;
  String? _specialNeeds;
  DateTime? _selectedDate;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  late FirebaseService _firebaseService;

  @override
  void initState() {
    super.initState();
    _firebaseService = widget.firebaseService;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String language) {
              // Handle language selection here
              switch (language) {
                case 'English':
                  // Change app language to English
                  break;
                case 'සිංහල':
                  // Change app language to Sinhala
                  break;
                case 'தமிழ்':
                  // Change app language to Tamil
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'English',
                child: Text('English'),
              ),
              const PopupMenuItem<String>(
                value: 'සිංහල',
                child: Text('සිංහල'),
              ),
              const PopupMenuItem<String>(
                value: 'தமிழ்',
                child: Text('தமிழ்'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'Full name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                hintText: 'Email address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _addressController,
              maxLines:
                  2, // Set to null or any number greater than 1 for multiple lines
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              value: _selectedGender,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
              items: <String>['Male', 'Female']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nicController,
              maxLines:
                  1, // Set to null or any number greater than 1 for multiple lines
              decoration: const InputDecoration(
                labelText: 'NIC',
                hintText: 'NIC',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : '',
              ),
              onTap: () => _selectDate(context),
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                hintText: 'Date of Birth',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Nationality',
                border: OutlineInputBorder(),
              ),
              value: _selectedNationality,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedNationality = newValue;
                });
              },
              items: <String>['Nationality A', 'Nationality B']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Are you with special need?'),
                const SizedBox(width: 10),
                Radio(
                  value: true,
                  groupValue: _specialNeeds != null,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        _specialNeeds = '';
                      } else {
                        _specialNeeds = null;
                      }
                    });
                  },
                ),
                const Text('Yes'),
                const SizedBox(width: 10),
                Radio(
                  value: false,
                  groupValue: _specialNeeds == null,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        _specialNeeds = null;
                      } else {
                        _specialNeeds = '';
                      }
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (_specialNeeds != null)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Special Needs',
                  hintText: 'Special Needs',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'District',
                border: OutlineInputBorder(),
              ),
              value: _selectedDistrict,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDistrict = newValue;
                });
              },
              items: <String>['District A', 'District B']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Divisional Secretariat',
                border: OutlineInputBorder(),
              ),
              value: _selectedDivisionalSecretariat,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDivisionalSecretariat = newValue;
                });
              },
              items: <String>[
                'Divisional Secretariat A',
                'Divisional Secretariat B'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _contactNumberController,
              decoration: const InputDecoration(
                labelText: 'Contact Number',
                hintText: 'Contact Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Clear all text fields
                    _fullNameController.clear();
                    _emailController.clear();
                    _addressController.clear();
                    _nicController.clear();
                    _selectedGender;
                    _selectedDate;
                    _selectedMaritalStatus;
                    _selectedNationality;
                    _selectedDistrict;
                    _selectedDivisionalSecretariat;
                    _specialNeeds;
                    _contactNumberController;

                    setState(() {
                      _selectedGender = null;
                    });
                  },
                  child: const Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: () {
  // Format the date as a string
  String formattedDate = _selectedDate != null
      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
      : '';

  // Call the function to add job seeker profile
  _firebaseService.addJobSeekerProfile(
    fullName: _fullNameController.text,
    email: _emailController.text,
    address: _addressController.text,
    gender: _selectedGender,
    nic: _nicController.text,
    dateOfBirth:_selectedDate ,
    maritalStatus:_selectedMaritalStatus,
    nationality:_selectedNationality,
    district:_selectedDistrict,
    divisionalsecretariat: _selectedDivisionalSecretariat,
    specialNeeds:_specialNeeds,
    contact: _contactNumberController      
                
  );
},

                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
