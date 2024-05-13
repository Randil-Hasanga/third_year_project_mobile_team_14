import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_management_system_mobileapp/Screens/Chattings.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:job_management_system_mobileapp/widgets/alertBoxWidgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ProfileJobSeeker extends StatefulWidget {
  // ignore: use_super_parameters
  ProfileJobSeeker({super.key});

  @override
  _ProfileJobSeekerState createState() => _ProfileJobSeekerState();
}

class _ProfileJobSeekerState extends State<ProfileJobSeeker> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _selectedGender;
  final TextEditingController _nicController = TextEditingController();
  DateTime? _selectedDate;

  String? _selectedDistrict, _logo;
  XFile? selectedImage;

  final TextEditingController _contactNumberController =
      TextEditingController();

  late FirebaseService _firebaseService;
  AlertBoxWidgets _alertBoxWidgets = AlertBoxWidgets();

  double? _deviceWidth, _deviceHeight; // for the responsiveness of the device

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _getSeeker();
  }

  void _getSeeker() {
    _firebaseService.getCurrentSeekerData().then((data) {
      if (data != null) {
        // Load the user's data into the form fields
        setState(() {
          _fullNameController.text = data['fullname'];
          _addressController.text = data['address'];
          _emailController.text = data['email'];
          _nicController.text = data['nic'];
          _selectedDate = data['dateOfBirth'].toDate();
          _selectedDistrict = data['district'];
          _contactNumberController.text = data['contact'];

          _logo = data['profile_image'];
          // Set the selected gender based on the fetched data
          if (data['gender'] == 'Male') {
            _selectedGender = 'Male';
          } else if (data['gender'] == 'Female') {
            _selectedGender = 'Female';
          }
        });
      }
    });
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
    //responsiveness of the device
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    void showAlert() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      //bottom app bar
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
                          builder: (context) => ProfileJobSeeker()));
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

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey, // Provide a GlobalKey<FormState> for form validation
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _addProfilePicture(),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Full name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email address';
                  }
                  // Regular expression pattern for email validation
                  RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!regex.hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null; // Return null if the input is valid
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your gender';
                  }
                  return null;
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
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _nicController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your NIC';
                  }

                  // Remove any whitespaces
                  value = value.replaceAll(' ', '');

                  // Check if the input starts with digits
                  if (!RegExp(r'^[0-9]').hasMatch(value)) {
                    return 'Invalid NIC format';
                  }

                  // Check the length of the NIC
                  if (value.length != 12 && value.length != 10) {
                    return 'NIC must be 10 or 12 characters long';
                  }

                  // Check for old version NIC (9 digits + 'V' or 'X')
                  if (value.length == 10 &&
                      !RegExp(r'^[0-9]{9}[VX]$').hasMatch(value)) {
                    return 'Invalid NIC format';
                  }

                  // Check for new version NIC (12 digits)
                  if (value.length == 12 &&
                      !RegExp(r'^[0-9]{12}$').hasMatch(value)) {
                    return 'Invalid NIC format';
                  }

                  // Valid NIC
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'NIC',
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
                validator: (value) {
                  if (_selectedDate == null) {
                    return 'Please select your date of birth';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a district';
                  }
                  return null;
                },
                items: <String>[
                  'Matara',
                  'Galle',
                  'Kalutara',
                  'Colombo',
                  'Gampaha',
                  'Kandy',
                  'Matale',
                  'Nuwara Eliya',
                  'Hambantota',
                  'Jaffna',
                  'Kilinochchi',
                  'Mannar',
                  'Mullaitivu',
                  'Vavuniya',
                  'Batticaloa',
                  'Ampara',
                  'Trincomalee',
                  'Kurunegala',
                  'Puttalam',
                  'Anuradhapura',
                  'Polonnaruwa',
                  'Badulla',
                  'Moneragala',
                  'Ratnapura',
                  'Kegalle'
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
                  labelText: 'Tel (Mobile)',
                  hintText: 'EX: +94718524560',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // if (value == null || value.isEmpty) {
                  //   return 'Please enter your contact number';
                  // }
                  // // Regular expression pattern for Sri Lankan mobile number format
                  // RegExp regex =
                  //     RegExp(r'^[+94]{1}[7]{1}[01245678]{1}[0-9]{7}$');
                  // if (!regex.hasMatch(value)) {
                  //   return 'Invalid mobile format. Please enter a valid Sri Lankan mobile number with a "+" sign and 11 digits (e.g., +94718524560).';
                  // }
                  return null; // Return null if the input is valid
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (selectedImage == null && _logo == null) {
                          _alertBoxWidgets.showAlert(
                              context,
                              QuickAlertType.warning,
                              "Please select a profile picture");
                        } else {
                          await _firebaseService.addJobSeekerProfile(
                            selectedImage,
                            _logo,
                            _fullNameController.text,
                            _emailController.text,
                            _addressController.text,
                            _selectedGender!,
                            _nicController.text,
                            _selectedDate,
                            _selectedDistrict!,
                            _contactNumberController.text,
                          );

                          // Display success message
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            title: 'Success',
                            text: 'Successfully added',
                          );
                        }
                      } else {
                        // If the form is invalid, show an error message
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Error',
                          text: 'Please fill in all the required fields',
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.orange.shade800, // Background color
                      elevation: 4, // Elevation (shadow)
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32), // Button padding
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white, fontSize: 19), // Text color
                    ), // Background color
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addProfilePicture() {
    if (_logo != null && selectedImage == null) {
      return GestureDetector(
        onTap: () {
          _pickAndResizeImage();
        },
        child: Stack(
          children: [
            Container(
              child: CircleAvatar(
                radius: 64,
                backgroundImage: NetworkImage(_logo!),
              ),
            ),
            GestureDetector(
              onTap: () => _pickAndResizeImage(),
              child: const Icon(
                Icons.add_a_photo,
                size: 35,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    } else if (selectedImage != null && _logo == null) {
      return GestureDetector(
        onTap: () {
          _pickAndResizeImage();
        },
        child: Stack(
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(64),
                child: Image.file(
                  File(selectedImage!.path),
                  width: 128,
                  height: 128,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _pickAndResizeImage(),
              child: const Icon(
                Icons.add_a_photo,
                size: 35,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    } else if (selectedImage != null && _logo != null) {
      return GestureDetector(
        onTap: () {
          _pickAndResizeImage();
        },
        child: Stack(
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(64),
                child: Image.file(
                  File(selectedImage!.path),
                  width: 128,
                  height: 128,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _pickAndResizeImage(),
              child: const Icon(
                Icons.add_a_photo,
                size: 35,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          _pickAndResizeImage();
        },
        child: Stack(
          children: [
            Container(
                width: _deviceWidth! * 0.3,
                height: _deviceHeight! * 0.15,
                child: CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpmMLA8odEi8CaMK39yvrOg-EGJP6127PmCjqURn_ssg&s'),
                )),
            const Icon(Icons.add_a_photo),
          ],
        ),
      );
    }
  }

  Future<void> _pickAndResizeImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      XFile compressedImage = await _resizeImage(XFile(pickedFile.path));
      setState(() {
        selectedImage = compressedImage;
      });
    }
  }

  Future<XFile> _resizeImage(XFile imageFile) async {
    List<int> imageBytes = (await FlutterImageCompress.compressWithFile(
      imageFile.path,
      minWidth: 500,
      minHeight: 250,
      quality: 90,
    )) as List<int>;

    String fileName = imageFile.name;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String compressedImgPath = '$appDocPath/$fileName.jpg';
    await File(compressedImgPath).writeAsBytes(imageBytes);

    return XFile(compressedImgPath);
  }
}
