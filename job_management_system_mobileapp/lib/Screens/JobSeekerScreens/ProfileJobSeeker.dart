
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_management_system_mobileapp/Screens/Chattings.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  late FirebaseService _firebaseService;
  DateTime? _dateOfBirth;
  String? _gender;
  String? _religion;
  String? _maritalStatus;
  String? _nationality;
  bool? _specialNeed;
  String? _district;
  String? _divisionalSecretariat;


  

@override
  void initState() {
    super.initState();
    _firebaseService = widget.firebaseService; // Initialize _firebaseService
  }

  @override
  void dispose() {
    // Dispose the controllers to avoid memory leaks
    _usernameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _nicController.dispose();
    super.dispose();
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: const Text("Profile",style: TextStyle(color: Colors.white,),),
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
      bottomNavigationBar: BottomAppBar(
        color:Colors.orange.shade800,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home,color: Colors.white,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const JobSeekerPage()));
                },
              ),
             IconButton(
                icon: const Icon(Icons.settings,color: Colors.white,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications,color: Colors.white,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const NotificationsJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat,color: Colors.white,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const Chattings()));
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            // Editable profile photo
            GestureDetector(
              onTap: () {
                // Add your logic to change the profile photo
                // For example:
                // _selectImage();
              },
              child: const CircleAvatar(
                radius: 70,
                // Use _selectedImage here if it's selected, otherwise use a placeholder
                // backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : AssetImage('assets/Default.png'),
                backgroundImage: AssetImage('assets/LogInAvater.png'),
              ),
            ),
            const SizedBox(height: 20),
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
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Address',
                 border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Gender',
                hintText: 'Gender',
                border: OutlineInputBorder(),
              ),
              value: _gender,
              onChanged: (String? value) {
                setState(() {
                  _gender = value;
                });
              },
              items: ['Male', 'Female']
                  .map((gender) => DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
            ),

              const SizedBox(height: 20),
            TextFormField(
              controller: _nicController,
              decoration: const InputDecoration(
                labelText: 'NIC',
                hintText: 'NIC',
                border: OutlineInputBorder(),
              ),
            ),
              const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dateOfBirth = pickedDate;
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  hintText: 'Date of Birth',
                  border:OutlineInputBorder(),
                ),
                child: _dateOfBirth == null
                    ? const Text('Select date')
                    : Text(
                        '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'),
              ),
            ),
              const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Religion',
                hintText: 'Religion',
                border: OutlineInputBorder(),
              ),
              value: _religion,
              onChanged: (String? value) {
                setState(() {
                  _religion = value;
                });
              },
              items: ['Buddhist', 'Christian', 'Hindu', 'Islam']
                  .map((religion) => DropdownMenuItem<String>(
                        value: religion,
                        child: Text(religion),
                      ))
                  .toList(),
            ),
              const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Marital Status',
                hintText: 'Marital Status',
                border: OutlineInputBorder(),
              ),
              value: _maritalStatus,
              onChanged: (String? value) {
                setState(() {
                  _maritalStatus = value;
                });
              },
              items: ['Single', 'Married', 'Divorced', 'Widowed']
                  .map((status) => DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
            ),
              const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Nationality',
                hintText: 'Nationality',
                border: OutlineInputBorder(),
              ),
              value: _nationality,
              onChanged: (String? value) {
                setState(() {
                  _nationality = value;
                });
              },
              items: ['Sri Lankan']
                  .map((nationality) => DropdownMenuItem<String>(
                        value: nationality,
                        child: Text(nationality),
                      ))
                  .toList(),
            ),
              const SizedBox(height: 20),
            Row(
              children: [
                const Text('Are you a person with special need?'),
                Radio<bool>(
                  value: true,
                  groupValue: _specialNeed,
                  onChanged: (bool? value) {
                    setState(() {
                      _specialNeed = value;
                    });
                  },
                ),
                const Text('Yes'),
                Radio<bool>(
                  value: false,
                  groupValue: _specialNeed,
                  onChanged: (bool? value) {
                    setState(() {
                      _specialNeed = value;
                    });
                  },
                ),
                const Text('No'),
              ],
            ),

              const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'District',
                hintText: 'District',
                border: OutlineInputBorder(),
              ),
              value: _district,
              onChanged: (String? value){
                setState(() {
                  _district = value;
                });
              },
              items: ['Matara', 'Galle', 'Kaluthara']
                  .map((district) => DropdownMenuItem<String>(
                        value: district,
                        child: Text(district),
                      ))
                  .toList(),
            ),
              const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail Add',
                hintText: 'E-mail Add',
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
                    _usernameController.clear();
                    _emailController.clear();
                    _phoneNumberController.clear();
                    _passwordController.clear();
                    _fullNameController.clear();
                    _addressController.clear();
                    _nicController.clear();
                    _dateOfBirth = null;
                    _gender = null;
                    _religion = null;
                    _maritalStatus = null;
                    _nationality = null;
                    _specialNeed = null;
                    _district = null;
                  },
                  child: const Text('Clear'),
                ),
                ElevatedButton(
  onPressed: () {
    FirebaseService().submitProfileData(
      fullName: _fullNameController.text,
      address: _addressController.text,
      gender: _gender!,
      nic: _nicController.text,
      dateOfBirth: _dateOfBirth!,
      religion: _religion!,
      maritalStatus: _maritalStatus!,
      nationality: _nationality!,
      specialNeed: _specialNeed!,
      district: _district!,
      email: _emailController.text,
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

// ignore: camel_case_types
class _firebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitProfileData({
    required String fullName,
    required String address,
    required String gender,
    required String nic,
    required DateTime dateOfBirth,
    required String religion,
    required String maritalStatus,
    required String nationality,
    required bool specialNeed,
    required String district,
    required String email,
  }) async {
    try {
      await _firestore.collection('profiles').add({
        'fullName': fullName,
        'address': address,
        'gender': gender,
        'nic': nic,
        'dateOfBirth': dateOfBirth,
        'religion': religion,
        'maritalStatus': maritalStatus,
        'nationality': nationality,
        'specialNeed': specialNeed,
        'district': district,
        'email': email,
      });
      // Profile data submitted successfully
    } catch (e) {
      // Error occurred while submitting profile data
      print('Error: $e');
    }
  }
}