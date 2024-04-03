
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/Screens/Chattings.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';

class ProfileJobSeeker extends StatefulWidget {
  // ignore: use_super_parameters
  const ProfileJobSeeker({Key? key}) : super(key: key);

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
  DateTime? _dateOfBirth;
  String? _gender;
  String? _religion;
  String? _maritalStatus;
  String? _nationality;
  bool? _specialNeed;
  String? _district;
  String? _divisionalSecretariat;

  @override
  void initState(){
    super.initState();
    //_firebaseService = GetIt.instance.get<FirebaseService>();
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfileJobSeeker()));
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
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Address',
                 border: OutlineInputBorder(),
              ),
            ),
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
            TextFormField(
              controller: _nicController,
              decoration: const InputDecoration(
                labelText: 'NIC',
                hintText: 'NIC',
                border: OutlineInputBorder(),
              ),
            ),
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
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Nationality',
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
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'District',
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
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail Add',
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
                    // Submit the profile data
                    // You can access the data using the controller's text properties
                    // For example: _usernameController.text, _emailController.text, etc.
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