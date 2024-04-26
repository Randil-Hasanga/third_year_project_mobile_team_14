import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/Screens/Chattings.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
// ignore: depend_on_referenced_packages
import 'package:printing/printing.dart';

class CVCreation extends StatefulWidget {
  CVCreation({super.key});

  final FirebaseService firebaseService = FirebaseService();

  @override
  _CVCreationState createState() => _CVCreationState();
}

class _CVCreationState extends State<CVCreation> {
  FirebaseService? _firebaseService;

  final _formKey = GlobalKey<FormState>();
  //Tab 01: personal informations
  String? _selectedtitle;
  String? _selectedgender;
  String? _selectedjobType;
  String? _selectedworkingSection;
  String? _selectedmaritalStatus;
  String? _selectedcurrentJobStatus;
  final TextEditingController _nameWithIniController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _drivingLicenceController =
      TextEditingController();
  DateTime? _selectedDate;
  String? _selectReligion;
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactMobileController =
      TextEditingController();
  final TextEditingController _contactHomeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _selecteddistrict;
  final TextEditingController _divisionalSecController =
      TextEditingController();

  final TextEditingController _salaryController = TextEditingController();

  //Tab 02: Educational
  String? _selectEduQalification;
  String? _selectProfQualification;
  final TextEditingController _OLYearController = TextEditingController();
  final TextEditingController _OLIndexController = TextEditingController();
  final TextEditingController _OLMediumController = TextEditingController();
  final TextEditingController _OLSchoolController = TextEditingController();
  final TextEditingController _OLAttemptController = TextEditingController();
  String? _selectOLStatus;

  final TextEditingController _ALYearController = TextEditingController();
  final TextEditingController _ALIndexController = TextEditingController();
  final TextEditingController _ALMediumController = TextEditingController();
  final TextEditingController _ALSchoolController = TextEditingController();
  final TextEditingController _ALAttemptController = TextEditingController();
  String? _selectALStatus;
  final TextEditingController _sec01NameController = TextEditingController();
  final TextEditingController _sec01InstituteController =
      TextEditingController();
  final TextEditingController _sec01durationController =
      TextEditingController();
  final TextEditingController _sec02NameController = TextEditingController();
  final TextEditingController _sec02InstituteController =
      TextEditingController();
  final TextEditingController _sec02durationController =
      TextEditingController();

  //Tab 03:Skill

  final TextEditingController _yearOfExperienceController =
      TextEditingController();
  final TextEditingController _currentJobPositionController =
      TextEditingController();
  final TextEditingController _dateOfJoinController = TextEditingController();
  final TextEditingController _currentEmployeeController =
      TextEditingController();
  final TextEditingController _responsibilitiesController =
      TextEditingController();
  final TextEditingController _specialSkillController = TextEditingController();
  final TextEditingController _computerSkillController =
      TextEditingController();
  final TextEditingController _otherSkillController = TextEditingController();
  final TextEditingController _achievementsController = TextEditingController();
  final TextEditingController _extraCurricularController =
      TextEditingController();
  final TextEditingController _trainingReqController = TextEditingController();
  // final TextEditingController _prefferedAreaController =
  //     TextEditingController();
  final TextEditingController _careerGuidanceController =
      TextEditingController();
  String? sinhalaSpeaking;
  String? sinhalaReading;
  String? sinhalaWriting;

  String? englishSpeaking;
  String? englishReading;
  String? englishWriting;

  String? tamilSpeaking;
  String? tamilReading;
  String? tamilWriting;

  List<String> proficiencyLevels = [
    'Basic',
    'Good',
    'Fluent',
    'None'
  ]; // language skill

  //Tab 04:Job Expectation
  final TextEditingController _careerObjectiveController =
      TextEditingController();
  final TextEditingController _refeeOneController = TextEditingController();
  final TextEditingController _refeeTwoController = TextEditingController();
  String? selectPrefIndustry;
  String? selectPrefAreaToWork;

  double? _deviceWidth, _deviceHeight;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
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

  Future<void> generatePdfFromFirebase() async {
    final pdf = pw.Document();

    // Create an instance of FirebaseService
    final firebaseService = FirebaseService();

    // Fetch user details from Firestore
    final userDetails = await firebaseService.getCVDetails('CVDetails');
    if (userDetails != null) {
      // Add a page to the PDF document
      final page = pw.Page(
        build: (pw.Context context) {
          return pw.Row(
            children: [
              // First Column: Personal Information
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  color: PdfColors
                      .blueGrey, // Color for personal information section
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Header(
                        level: 1,
                        text: 'Personal Information',
                        textStyle: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white, // Text color
                        ),
                      ),
                      // Personal information fields
                      pw.Paragraph(
                          text: 'Full Name: ${userDetails['fullname']}'),
                      pw.Paragraph(text: 'Age: ${userDetails['age']}'),
                      pw.Paragraph(text: 'Gender: ${userDetails['gender']}'),
                      // Add more personal information fields here
                    ],
                  ),
                ),
              ),

              // Second Column: Educational, Skills, and Job Prospects
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  color: PdfColors
                      .orangeAccent, // Color for educational, skills, and job prospects section
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Educational Details
                      pw.Header(
                        level: 1,
                        text: 'Educational Details',
                        textStyle: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white, // Text color
                        ),
                      ),
                      // Educational details fields
                      pw.Paragraph(
                          text: 'Education: ${userDetails['EduQalification']}'),
                      // Add more educational details fields here

                      // Skills
                      pw.Header(
                        level: 1,
                        text: 'Skills',
                        textStyle: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white, // Text color
                        ),
                      ),
                      // Skills fields
                      pw.Paragraph(
                          text:
                              'Year of Experience: ${userDetails['yearOfExperience']}'),
                      // Add more skills fields here

                      // Job Prospects
                      pw.Header(
                        level: 1,
                        text: 'Job Prospects',
                        textStyle: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white, // Text color
                        ),
                      ),
                      // Job prospects fields
                      pw.Paragraph(
                          text:
                              'Career Objective: ${userDetails['careerObjective']}'),
                      // Add more job prospects fields here
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );

      pdf.addPage(page);

      // Save the PDF file
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/cv_from_firebase.pdf');
      await file.writeAsBytes(await pdf.save());

      // Print the PDF
      final bytes = await file.readAsBytes();
      await Printing.sharePdf(bytes: bytes, filename: 'cv_from_firebase.pdf');
    } else {
      print('User details not found');
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
        title: 'Your CV is already created\nPress "Create CV" ',
      );
    }

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
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: [
              // Personal Info Tab
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedtitle,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedtitle = newValue;
                          });
                        },
                        items: <String>['Dr', 'Miss', 'Mr', 'Mrs', 'Prof']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                            labelText: 'Title', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedgender,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedgender = newValue;
                          });
                        },
                        items: <String>['Male', 'Female']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedjobType,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedjobType = newValue;
                          });
                        },
                        items: <String>['Part Time', 'Full Time']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Job Type',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedworkingSection,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedworkingSection = newValue;
                          });
                        },
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
                        decoration: const InputDecoration(
                          labelText: 'Working Sector',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedmaritalStatus,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedmaritalStatus = newValue;
                          });
                        },
                        items: <String>['Married', 'Unmarried']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Marital Status',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedcurrentJobStatus,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedcurrentJobStatus = newValue;
                          });
                        },
                        items: <String>['Employed', 'Not Employed']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Current Job Status',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _nameWithIniController,
                        decoration: const InputDecoration(
                          labelText: 'Name With Initials *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name With Initials is required';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Full Name is required';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _nationalityController,
                        decoration: const InputDecoration(
                          labelText: 'Nationality (Eg: Srilanka)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _nicController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'NIC cannot be empty';
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _drivingLicenceController,
                        decoration: const InputDecoration(
                          labelText: 'Driving License',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          // Regular expression pattern for Sri Lankan driving license
                          RegExp regex = RegExp(
                              r'^[A-Z]{2}\d{9}$'); // Example pattern: AB123456789

                          if (value == null || value.isEmpty) {
                            // Return null if the field is empty (validation passed)
                            return null;
                          } else if (!regex.hasMatch(value)) {
                            // Return an error message if the value doesn't match the pattern
                            return 'Invalid driving license format';
                          }
                          // Return null if the input is valid
                          return null;
                        },
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
                        value: _selectReligion,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectReligion = newValue;
                          });
                        },
                        items: <String>[
                          'Buddhism',
                          'Hinduism',
                          'Islam',
                          'Christianity',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Religion',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _ageController,
                        decoration: const InputDecoration(
                          labelText: 'Age',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Age is required';
                          }
                          // Convert the input value to an integer
                          int age;
                          try {
                            age = int.parse(value);
                          } catch (e) {
                            return 'Invalid age';
                          }
                          // Check if age is a positive integer
                          if (age <= 0) {
                            return 'Age must be a positive integer';
                          }
                          // Additional validation if needed
                          // ...

                          return null; // Return null if the input is valid
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email Address is required';
                          }
                          // Regular expression pattern for email validation
                          RegExp regex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!regex.hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _contactMobileController,
                        decoration: const InputDecoration(
                          labelText: 'Tel (Mobile)',
                          hintText: 'EX: +947185245600',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mobile number is required';
                          }
                          // Regular expression pattern for Sri Lankan mobile number format
                          RegExp regex = RegExp(
                              r'^(?:\+?94)?0?(7(?:[0125678]\d|9[0-4])\d{7})$');
                          if (!regex.hasMatch(value)) {
                            return 'invalid mobile format';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _contactHomeController,
                        decoration: const InputDecoration(
                          labelText: 'Tel (Home)',
                          hintText: 'EX: +947185245600',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'invalid mobile format';
                          }
                          // Regular expression pattern for Sri Lankan home contact number format
                          RegExp regex = RegExp(r'^(?:\+?94)?0?([1-9]\d{8})$');
                          if (!regex.hasMatch(value)) {
                            return 'Enter a valid Sri Lankan home contact number';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Address is required';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'District',
                          border: OutlineInputBorder(),
                        ),
                        value: _selecteddistrict,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selecteddistrict = newValue;
                          });
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _divisionalSecController,
                        decoration: const InputDecoration(
                          labelText: 'Divisional Secretariat',
                          hintText: 'Ex: Pelgama',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Divisional Secretariat is required';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _salaryController,
                        decoration: const InputDecoration(
                          labelText: 'Minimum Salary Expectation (LKR)',
                          hintText: '25,000/=',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Minimum Salary Expectation is required';
                          }
                          // Regular expression pattern to validate Sri Lankan salary format
                          RegExp regex =
                              RegExp(r'^\d{1,3}(,\d{3})*(\.\d+)?/=?$');
                          if (!regex.hasMatch(value)) {
                            return 'Enter a valid salary amount(e.g., 25,000/=)';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text("Swap to go to Educational section"),
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
                        value: _selectEduQalification,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectEduQalification = newValue;
                          });
                        },
                        items: <String>[
                          'Below O/L',
                          'Passed O/L',
                          'Passed A/L',
                          'undergraduate',
                          'Graduate',
                          'Post Graduate Diploma'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Educational Qualification Level',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Professional Qualification Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectProfQualification,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectProfQualification = newValue;
                          });
                        },
                        items: <String>[
                          'NVQ01',
                          'NVQ02',
                          'NVQ03',
                          'NVQ04',
                          'NVQ05',
                          'NVQ06',
                          'NVQ07',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Educational Qualification Level',
                          border: OutlineInputBorder(),
                        ),
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
                        controller: _OLYearController,
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          hintText: 'Ex: 2016',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Year is required';
                          }
                          // Regular expression pattern to match only numbers
                          RegExp regex = RegExp(r'^[0-9]+$');
                          if (!regex.hasMatch(value)) {
                            return 'Enter a valid year (numbers only)';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),

                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _OLIndexController,
                        decoration: const InputDecoration(
                          labelText: 'Index No',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Index No is required';
                          }
                          // Regular expression pattern to match only numbers
                          RegExp regex = RegExp(r'^[0-9]+$');
                          if (!regex.hasMatch(value)) {
                            return 'Enter a valid index number (numbers only)';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),

                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _OLMediumController,
                        decoration: const InputDecoration(
                          labelText: 'Medium',
                          hintText: 'Ex: Sinhala',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Medium is required';
                          }
                          // Regular expression pattern to match only letters
                          RegExp regex = RegExp(r'^[a-zA-Z]+$');
                          if (!regex.hasMatch(value)) {
                            return 'Enter a valid medium (letters only)';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),

                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _OLSchoolController,
                        decoration: const InputDecoration(
                          labelText: 'School',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'School is required';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),

                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _OLAttemptController,
                        decoration: const InputDecoration(
                          labelText: 'Attempt',
                          hintText: 'Ex: 1',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Attempt is required';
                          }
                          // Regular expression pattern to match only numbers
                          RegExp regex = RegExp(r'^[0-9]+$');
                          if (!regex.hasMatch(value)) {
                            return 'Enter a valid attempt (numbers only)';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),

                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectOLStatus,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectOLStatus = newValue;
                          });
                        },
                        items: <String>[
                          'Yes',
                          'No',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Do you pass the O/L exam?',
                          border: OutlineInputBorder(),
                        ),
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
                        controller: _ALYearController,
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          hintText: 'Ex: 2016',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Year is required';
                          }
                          // You can add additional validation rules here if needed
                          return null; // Return null if the input is valid
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _ALIndexController,
                        decoration: const InputDecoration(
                          labelText: 'Index No',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Index No is required';
                          }
                          // You can add additional validation rules here if needed
                          return null; // Return null if the input is valid
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _ALMediumController,
                        decoration: const InputDecoration(
                          labelText: 'Medium',
                          hintText: 'Ex: Sinhala',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Medium is required';
                          }
                          // You can add additional validation rules here if needed
                          return null; // Return null if the input is valid
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _ALSchoolController,
                        decoration: const InputDecoration(
                          labelText: 'School',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'School is required';
                          }
                          // You can add additional validation rules here if needed
                          return null; // Return null if the input is valid
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _ALAttemptController,
                        decoration: const InputDecoration(
                          labelText: 'Attempt',
                          hintText: 'Ex: 1',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Attempt is required';
                          }
                          // Regular expression pattern to match only numbers
                          RegExp regex = RegExp(r'^[0-9]+$');
                          if (!regex.hasMatch(value)) {
                            return 'Enter a valid attempt (numbers only)';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),

                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectALStatus,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectALStatus = newValue;
                          });
                        },
                        items: <String>[
                          'Yes',
                          'No',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Did you pass the A/L?',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Professional Qualifications Section
                      const Text(
                        'Professional Qualifications: section 01',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _sec01NameController,
                        decoration: const InputDecoration(
                          labelText: 'Qualification Name',
                          hintText: 'Ex: BICT(hons)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Qualification Name is required';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _sec01InstituteController,
                        decoration: const InputDecoration(
                          labelText: 'Institute Name',
                          hintText: '',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Institute Name is required';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _sec01durationController,
                        decoration: const InputDecoration(
                          labelText: 'Duration',
                          hintText: 'Ex: 2 months',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Duration is required';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Professional Qualifications: section 02',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _sec02NameController,
                        decoration: const InputDecoration(
                          labelText: 'Qualification Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _sec02InstituteController,
                        decoration: const InputDecoration(
                          labelText: 'Institute Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _sec02durationController,
                        decoration: const InputDecoration(
                          labelText: 'Duration',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),

                      const Text("Swap to go to Skills section"),
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
                          controller: _yearOfExperienceController,
                          decoration: const InputDecoration(
                            labelText: 'Year of job experience',
                            hintText: 'Ex: 2 years',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Year of job experience is required';
                            }
                            // Regular expression to match the pattern "<number> years"
                            RegExp regExp = RegExp(r'^\d+ years$');
                            if (!regExp.hasMatch(value)) {
                              return 'Please enter a valid year of job experience in the format: <number> years';
                            }
                            return null; // Return null if the input is valid
                          },
                        ),

                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _currentJobPositionController,
                          decoration: const InputDecoration(
                            labelText: 'Current Job Position',
                            hintText: 'HR Manager',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Current job position is required';
                            }
                            return null; // Return null if the input is valid
                          },
                        ),

                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _dateOfJoinController,
                          decoration: const InputDecoration(
                            labelText: 'Date of join',
                            hintText: 'xxxx-xx-xx',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Date of join is required';
                            }
                            // Regular expression to match the pattern "xxxx-xx-xx"
                            RegExp regExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                            if (!regExp.hasMatch(value)) {
                              return 'Please enter a valid date in the format: xxxx-xx-xx';
                            }
                            return null; // Return null if the input is valid
                          },
                        ),

                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _currentEmployeeController,
                          decoration: const InputDecoration(
                            labelText: 'Current Employee Name',
                            hintText: ' Ex: HR Manager',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _responsibilitiesController,
                          decoration: const InputDecoration(
                            labelText: 'Responsibilities',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _specialSkillController,
                          decoration: const InputDecoration(
                            labelText: 'Special Skills',
                            border: OutlineInputBorder(),
                          ),
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
                          controller: _computerSkillController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Computer Skills',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _otherSkillController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Other  Skills',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _achievementsController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Achievements',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _extraCurricularController,
                          decoration: const InputDecoration(
                            labelText: 'Extra Curricular Achieves',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _trainingReqController,
                          decoration: const InputDecoration(
                            labelText: 'Fields of Training Requirements',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // TextFormField(
                        //   controller: _prefferedAreaController,
                        //   decoration: const InputDecoration(
                        //     labelText: 'Area preferred to start Employment',
                        //     border: OutlineInputBorder(),
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _careerGuidanceController,
                          decoration: const InputDecoration(
                            labelText: 'Career Guidance Requirements',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Language Skills',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildLanguageSkillsDropdown('Sinhala'),
                            const SizedBox(height: 10),
                            _buildLanguageSkillsDropdown('English'),
                            const SizedBox(height: 10),
                            _buildLanguageSkillsDropdown('Tamil'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text("Swap to go to Job Expectation Tab"),
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
                          controller: _careerObjectiveController,
                          decoration: const InputDecoration(
                            labelText: 'Career Objective',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _refeeOneController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Referee [1]',
                            hintText:
                                'Ex: MR. Bandara\n lecturer\n +94 xxxxxxxxx',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _refeeTwoController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Referee [2]',
                            hintText:
                                'Ex: Ms. Bandara\n lecturer\n +94 xxxxxxxxx',
                            border: OutlineInputBorder(),
                          ),
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
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            hintMaxLines: 2,
                            labelText: 'preffered Industry',
                            border: OutlineInputBorder(),
                          ),
                          value: selectPrefIndustry,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectPrefIndustry = newValue;
                            });
                          },
                          items: <String>[
                            '1. Agriculture Animal Husbandry\nand Forestry',
                            '2. Fishing',
                            '3. Mining and Quarrying',
                            '4. Manufacturing',
                            '5. Electricity Gas and Water Supply',
                            '6. Construction',
                            '7. Wholesale and Retail Trade',
                            '8. Hotel and Restaurant',
                            '9. Financial Services',
                            '10.Real Estate Services',
                            '11.Computer Related Services',
                            '12.Research and Development Services',
                            '13.Public Administration and Defence',
                            '14.Health and Social Services',
                            '15.Other Community,Social and Personal\nServices',
                            '16.Private Householdwith Employed\nPersonals',
                            '17.Extra Territorial Organizations',
                            '18.Transportation and Storage',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.trim()),
                            );
                          }).toList(),
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
                          decoration: const InputDecoration(
                            labelText: 'District',
                            border: OutlineInputBorder(),
                          ),
                          value: selectPrefAreaToWork,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectPrefAreaToWork = newValue;
                            });
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Format the date as a string
                                  String formattedDate = _selectedDate != null
                                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                      : '';

                                  // Call the function to add job seeker profile
                                  _firebaseService!.addCVdetails(
                                    _selectedtitle!,
                                    _selectedgender!,
                                    _selectedjobType!,
                                    _selectedworkingSection!,
                                    _selectedmaritalStatus!,
                                    _selectedcurrentJobStatus!,
                                    _nameWithIniController.text,
                                    _fullNameController.text,
                                    _nationalityController.text,
                                    _nicController.text,
                                    _drivingLicenceController.text,
                                    _selectedDate,
                                    _selectReligion!,
                                    _ageController.text,
                                    _emailController.text,
                                    _contactMobileController.text,
                                    _contactHomeController.text,
                                    _addressController.text,
                                    _selecteddistrict!,
                                    _divisionalSecController.text,
                                    _salaryController.text,
                                    _selectEduQalification!,
                                    _selectProfQualification!,
                                    _OLYearController.text,
                                    _OLIndexController.text,
                                    _OLMediumController.text,
                                    _OLSchoolController.text,
                                    _OLAttemptController.text,
                                    _selectOLStatus!,
                                    _ALYearController.text,
                                    _ALIndexController.text,
                                    _ALMediumController.text,
                                    _ALSchoolController.text,
                                    _ALAttemptController.text,
                                    _selectALStatus!,
                                    _sec01NameController.text,
                                    _sec01InstituteController.text,
                                    _sec01durationController.text,
                                    _sec02NameController.text,
                                    _sec02InstituteController.text,
                                    _sec02durationController.text,
                                    _yearOfExperienceController.text,
                                    _currentJobPositionController.text,
                                    _dateOfJoinController.text,
                                    _currentEmployeeController.text,
                                    _responsibilitiesController.text,
                                    _specialSkillController.text,
                                    _computerSkillController.text,
                                    _otherSkillController.text,
                                    _achievementsController.text,
                                    _extraCurricularController.text,
                                    _trainingReqController.text,
                                    //_prefferedAreaController.text,
                                    _careerGuidanceController.text,
                                    sinhalaWriting!,
                                    sinhalaReading!,
                                    sinhalaWriting!,
                                    englishSpeaking!,
                                    englishReading!,
                                    englishWriting!,
                                    tamilSpeaking!,
                                    tamilReading!,
                                    tamilWriting!,
                                    _careerObjectiveController.text,
                                    _refeeOneController.text,
                                    _refeeTwoController.text,
                                    selectPrefIndustry!,
                                    selectPrefAreaToWork!,
                                  );
                                  // _selectedtitle!.clear();
                                  //_selectedgender.clear();
                                  // _selectedjobType!,
                                  // _selectedworkingSection!,
                                  //_selectedmaritalStatus!,
                                  //_selectedcurrentJobStatus!,
                                  // _nameWithIniController.clear();
                                  // _fullNameController.clear();
                                  // _nationalityController.clear();
                                  // _nicController.clear();
                                  // _drivingLicenceController.clear();
                                  // //_selectedDate!,
                                  // _selectReligion!,
                                  // _ageController.clear();
                                  // _emailController.clear();
                                  // _contactMobileController.clear();
                                  // _contactHomeController.clear();
                                  // _addressController.clear();
                                  // //_selecteddistrict!,
                                  // _divisionalSecController.clear();
                                  // _salaryController.clear();
                                  // //_selectEduQalification!,
                                  // //_selectProfQualification!,
                                  // _OLYearController.clear();
                                  // _OLIndexController.clear();
                                  // _OLMediumController.clear();
                                  // _OLSchoolController.clear();
                                  // _OLAttemptController.clear();
                                  // //_selectOLStatus!,
                                  // _ALYearController.clear();
                                  // _ALIndexController.clear();
                                  // _ALMediumController.clear();
                                  // _ALSchoolController.clear();
                                  // _ALAttemptController.clear();
                                  // //_selectALStatus!,
                                  // _sec01NameController.clear();
                                  // _sec01InstituteController.clear();
                                  // _sec01durationController.clear();
                                  // _sec02NameController.clear();
                                  // _sec02InstituteController.clear();
                                  // _sec02durationController.clear();
                                  // _yearOfExperienceController.clear();
                                  // _currentJobPositionController.clear();
                                  // _dateOfJoinController.clear();
                                  // _currentEmployeeController.clear();
                                  // _responsibilitiesController.clear();
                                  // _specialSkillController.clear();
                                  // _computerSkillController.clear();
                                  // _otherSkillController.clear();
                                  // _achievementsController.clear();
                                  // _extraCurricularController.clear();
                                  // _trainingReqController.clear();
                                  // _prefferedAreaController.clear();
                                  // _careerGuidanceController.clear();
                                  // //sinhalaWriting!,
                                  // //sinhalaReading!,
                                  // //sinhalaWriting!,
                                  // //englishSpeaking!,
                                  // // englishReading!,
                                  // //englishWriting!,
                                  // //tamilSpeaking!,
                                  // // tamilReading!,
                                  // //tamilWriting!,
                                  // _careerObjectiveController.clear();
                                  // _refeeOneController.clear();
                                  // _refeeTwoController.clear();
                                  // _preferredJobsController.clear();
                                  //selectPrefAreaToWork!,
                                  showAlert();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.orange.shade800, // Background color
                                elevation: 4, // Elevation (shadow)
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Rounded corners
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 32), // Button padding
                              ),
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19), // Text color
                              ), // Background color
                            ),
                            ElevatedButton(
                              onPressed: () {
                                generatePdfFromFirebase();
                              },
                              child: const Text('Create CV'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSkillsDropdown(String language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: language == 'Sinhala'
                      ? sinhalaSpeaking
                      : language == 'English'
                          ? englishSpeaking
                          : tamilSpeaking,
                  onChanged: (String? newValue) {
                    setState(() {
                      if (language == 'Sinhala') {
                        sinhalaSpeaking = newValue;
                      } else if (language == 'English') {
                        englishSpeaking = newValue;
                      } else {
                        tamilSpeaking = newValue;
                      }
                    });
                  },
                  items: proficiencyLevels
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Speaking',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: language == 'Sinhala'
                      ? sinhalaReading
                      : language == 'English'
                          ? englishReading
                          : tamilReading,
                  onChanged: (String? newValue) {
                    setState(() {
                      if (language == 'Sinhala') {
                        sinhalaReading = newValue;
                      } else if (language == 'English') {
                        englishReading = newValue;
                      } else {
                        tamilReading = newValue;
                      }
                    });
                  },
                  items: proficiencyLevels
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Reading',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: language == 'Sinhala'
                      ? sinhalaWriting
                      : language == 'English'
                          ? englishWriting
                          : tamilWriting,
                  onChanged: (String? newValue) {
                    setState(() {
                      if (language == 'Sinhala') {
                        sinhalaWriting = newValue;
                      } else if (language == 'English') {
                        englishWriting = newValue;
                      } else {
                        tamilWriting = newValue;
                      }
                    });
                  },
                  items: proficiencyLevels
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Writing',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

//create cv pdf format
Future<void> generatePdfFromFirebase() async {
  final pdf = pw.Document();

  // Create an instance of FirebaseService
  final firebaseService = FirebaseService();

  // Fetch user details from Firestore
  final userDetails = await firebaseService.getCVDetails('CVDetails');
  if (userDetails != null) {
    // Add a page to the PDF document
   final page = pw.Page(
  build: (pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Row for "Curriculum Vitae" title
        pw.Container(
          padding: pw.EdgeInsets.all(10),
          color: PdfColors.blue, // Color for the title row
          child: pw.Header(
            level: 1,
            text: 'Curriculum Vitae',
            textStyle: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white, // Text color
            ),
          ),
        ),
        // Column for Personal Information, Educational, Skills, and Job Prospects
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Personal Information
            pw.Container(
              padding: pw.EdgeInsets.all(10),
              color: PdfColors.blueGrey, // Color for personal information section
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Header(
                    level: 1,
                    text: 'Personal Information',
                    textStyle: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white, // Text color
                    ),
                  ),
                  // Personal information fields
                  pw.Paragraph(
                    text: 'Full Name: ${userDetails['fullname']}',
                  ),
                  pw.Paragraph(
                    text: 'Age: ${userDetails['age']}',
                  ),
                  pw.Paragraph(
                    text: 'Gender: ${userDetails['gender']}',
                  ),
                  // Add more personal information fields here
                ],
              ),
            ),

            // Educational, Skills, and Job Prospects
            pw.Container(
              padding: pw.EdgeInsets.all(10),
              color: PdfColors.orangeAccent, // Color for other sections
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Educational Details
                  pw.Header(
                    level: 1,
                    text: 'Educational Details',
                    textStyle: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white, // Text color
                    ),
                  ),
                  // Educational details fields
                  pw.Paragraph(
                    text: 'Education: ${userDetails['EduQalification']}',
                  ),
                  // Add more educational details fields here

                  // Skills
                  pw.Header(
                    level: 1,
                    text: 'Skills',
                    textStyle: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white, // Text color
                    ),
                  ),
                  // Skills fields
                  pw.Paragraph(
                    text: 'Year of Experience: ${userDetails['yearOfExperience']}',
                  ),
                  // Add more skills fields here

                  // Job Prospects
                  pw.Header(
                    level: 1,
                    text: 'Job Prospects',
                    textStyle: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white, // Text color
                    ),
                  ),
                  // Job prospects fields
                  pw.Paragraph(
                    text: 'Career Objective: ${userDetails['careerObjective']}',
                  ),
                  // Add more job prospects fields here
                ],
              ),
            ),
          ],
        ),
      ],
    );
  },
);

    pdf.addPage(page);

    // Save the PDF file
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/cv_from_firebase.pdf');
    await file.writeAsBytes(await pdf.save());

    // Print the PDF
    final bytes = await file.readAsBytes();
    await Printing.sharePdf(bytes: bytes, filename: 'cv_from_firebase.pdf');
  } else {
    print('User details not found');
  }
}
