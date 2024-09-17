import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/CVUpload.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
// ignore: depend_on_referenced_packages
import 'package:printing/printing.dart';

import '../../localization/demo_localization.dart';

class CVCreation extends StatefulWidget {
  CVCreation({super.key});

  final FirebaseService firebaseService = FirebaseService();

  @override
  _CVCreationState createState() => _CVCreationState();
}

class _CVCreationState extends State<CVCreation> {
  //variables
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
  String? _selectedExperience;
  final TextEditingController _yearOfExperienceController =
      TextEditingController();
  final TextEditingController _currentJobPositionController =
      TextEditingController();
  final TextEditingController _dateOfJoinController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
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

  // ignore: non_constant_identifier_names
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> prefered_industries = [];
  String? _userDocId;
  List<String> allIndustries = [
    'Transportation and Storage',
    'Extra Territorial Organizations',
    'Private Household with Employed Personals',
    'Other Community, Social and Personal Services',
    'Health and Social Services',
    'Public Administration and Defence',
    'Research and Development Services',
    'Computer Related Services',
    'Real Estate Services',
    'Financial Services',
    'Hotel and Restaurant',
    'Wholesale and Retail Trade',
    'Construction',
    'Electricity, Gas and Water Supply',
    'Manufacturing',
    'Mining and Quarrying',
    'Fishing',
    'Agriculture, Animal Husbandry and Forestry'
  ];
  String? selectPrefferedDistrict;
  double? _deviceWidth, _deviceHeight;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _editCVDetails();
    _userDocId = _auth.currentUser?.uid; // Get the UID of the current user
    fetchPreferredIndustries(); // Load preferred industries from Firebase
  }

  Future<void> fetchPreferredIndustries() async {
    if (_userDocId == null) return;

    try {
      DocumentSnapshot doc =
          await _firestore.collection('CVDetails').doc(_userDocId).get();
      if (doc.exists) {
        List<dynamic> industries = doc['prefered_industries'] ?? [];
        setState(() {
          prefered_industries = List<String>.from(industries);
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

//date picker

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
        _calculateAge(); // Update age when a new date is selected
      });
    }
  }

  void _calculateAge() {
    if (_selectedDate != null) {
      final DateTime today = DateTime.now();
      int age = today.year - _selectedDate!.year;
      if (today.month < _selectedDate!.month ||
          (today.month == _selectedDate!.month &&
              today.day < _selectedDate!.day)) {
        age--;
      }
      _ageController.text = age.toString();
    } else {
      _ageController.text = '';
    }
  }

  void _editCVDetails() async {
    try {
      final data = await _firebaseService?.editCVDetails();
      if (mounted && data != null) {
        setState(() {
          // Update dropdown selections
          _selectedtitle = data['title'] ?? _selectedtitle;
          _selectedgender = data['gender'] ?? _selectedgender;
          _selectedjobType = data['jobType'] ?? _selectedjobType;
          _selectedworkingSection =
              data['workingSection'] ?? _selectedworkingSection;
          _selectedmaritalStatus =
              data['maritalStatus'] ?? _selectedmaritalStatus;
          _selectedcurrentJobStatus =
              data['currentJobStatus'] ?? _selectedcurrentJobStatus;
          _selectReligion = data['religion'] ?? _selectReligion;
          _selecteddistrict = data['district'] ?? _selecteddistrict;
          _selectEduQalification =
              data['EduQalification'] ?? _selectEduQalification;
          _selectProfQualification =
              data['ProfQualification'] ?? _selectProfQualification;
          _selectOLStatus = data['OLStatus'] ?? _selectOLStatus;
          _selectALStatus = data['ALStatus'] ?? _selectALStatus;

          // Update text controllers
          _nameWithIniController.text = data['nameWithIni'] ?? '';
          _fullNameController.text = data['fullname'] ?? '';
          _nationalityController.text = data['nationality'] ?? '';
          _nicController.text = data['nic'] ?? '';
          _drivingLicenceController.text = data['drivingLicence'] ?? '';
          _ageController.text = data['age'] ?? '';
          _emailController.text = data['cv_email'] ?? '';
          _contactMobileController.text = data['contactMobile'] ?? '';
          _contactHomeController.text = data['ContactHome'] ?? '';
          _addressController.text = data['address'] ?? '';
          _divisionalSecController.text = data['divisionalSecretariat'] ?? '';
          _salaryController.text = data['salary'] ?? '';
          _OLYearController.text = data['OLYear'] ?? '';
          _OLIndexController.text = data['OLIndex'] ?? '';
          _OLMediumController.text = data['OLMedium'] ?? '';
          _OLSchoolController.text = data['OLSchool'] ?? '';
          _OLAttemptController.text = data['OLAttempt'] ?? '';
          _ALYearController.text = data['ALYear'] ?? '';
          _ALIndexController.text = data['ALIndex'] ?? '';
          _ALMediumController.text = data['ALMedium'] ?? '';
          _ALSchoolController.text = data['ALSchool'] ?? '';
          _ALAttemptController.text = data['ALAttempt'] ?? '';
          _sec01NameController.text = data['sec01Ins'] ?? '';
          _sec01InstituteController.text = data['sec01Name'] ?? '';
          _sec01durationController.text = data['sec01duration'] ?? '';
          _sec02NameController.text = data['sec01Ins'] ?? '';
          _sec02InstituteController.text = data['sec01Name'] ?? '';
          _sec02durationController.text = data['sec01duration'] ?? '';
          _yearOfExperienceController.text = data['yearOfExperience'] ?? '';
          _currentJobPositionController.text = data['currentJobPosition'] ?? '';
          _dateOfJoinController.text = data['dateOfJoin'] ?? '';
          _companyController.text = data['currentEmployee'] ?? '';
          _responsibilitiesController.text = data['responsibilities'] ?? '';
          _specialSkillController.text = data['specialSkill'] ?? '';
          _computerSkillController.text = data['computerSkill'] ?? '';
          _otherSkillController.text = data['otherSkill'] ?? '';
          _achievementsController.text = data['achievements'] ?? '';
          _extraCurricularController.text = data['extraCurricular'] ?? '';
          _trainingReqController.text = data['trainingReq'] ?? '';
          _careerGuidanceController.text = data['careerGuidance'] ?? '';
          _careerObjectiveController.text = data['careerObjective'] ?? '';
          _refeeOneController.text = data['refeeOne'] ?? '';
          _refeeTwoController.text = data['refeeTwo'] ?? '';

          // Update language skills
          sinhalaSpeaking = data['sinhalaSpeaking'] ?? sinhalaSpeaking;
          sinhalaReading = data['sinhalaReading'] ?? sinhalaReading;
          sinhalaWriting = data['sinhalaWriting'] ?? sinhalaWriting;
          englishSpeaking = data['englishSpeaking'] ?? englishSpeaking;
          englishReading = data['englishReading'] ?? englishReading;
          englishWriting = data['englishWriting'] ?? englishWriting;
          tamilSpeaking = data['tamilSpeaking'] ?? tamilSpeaking;
          tamilReading = data['tamilReading'] ?? tamilReading;
          tamilWriting = data['tamilWriting'] ?? tamilWriting;

          // Update preferred industries
          if (data['preferredIndustries'] != null) {
            List<dynamic> industry = data['preferredIndustries'];
            prefered_industries = List<String>.from(industry);
          }

          // Update preferred districts
          selectPrefferedDistrict =
              data['prefferedDistrict'] ?? selectPrefferedDistrict;

          // Handle the date conversion if needed
          if (data['selectedDate'] != null) {
            _selectedDate = data['selectedDate'].toDate();
          }
        });
      }
    } catch (e) {
      print('Error editing CV details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    //responsiveness of the device
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        //top App bar
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
                  icon: const Icon(Icons.event,
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
                    Navigator.popAndPushNamed(context, "seeker_chats");
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
                      const Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Follow text hints for a better CV of you',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a title';
                          }
                          return null;
                        },
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
                        items: <String>['Male', 'Female', 'Other']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                            labelText: 'Gender', border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a gender';
                          }
                          return null;
                        },
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
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a job type';
                          }
                          return null;
                        },
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
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a working sector';
                          }
                          return null;
                        },
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
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a marital status';
                          }
                          return null;
                        },
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
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a current job status';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nameWithIniController,
                              decoration: InputDecoration(
                                labelText: Localization.of(context)
                                        .getTranslatedValue('nameWithIni') ??
                                    'Name With Initials *',
                                hintText: Localization.of(context)
                                        .getTranslatedValue('nameWithIni') ??
                                    'Name With Initials *',
                                border: const OutlineInputBorder(),
                                errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {
                                    // Show a tooltip or dialog with information about the input
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Input Information'),
                                          content: const Text(
                                            'Please enter your name with initials. Only letters, spaces, and dots are allowed.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  tooltip:
                                      'Text only. Letters, spaces, and dots are allowed.',
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                final RegExp regex = RegExp(r'^[a-zA-Z\s.]+$');
                                if (value == null || value.isEmpty) {
                                  return Localization.of(context)
                                          .getTranslatedValue(
                                              'please enter name with initials') ??
                                      'Please enter full name';
                                } else if (!regex.hasMatch(value)) {
                                  return 'Only letters, spaces, and dots are allowed';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _fullNameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name *',
                                hintText: 'Enter your full name',
                                border: const OutlineInputBorder(),
                                errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {
                                    // Show a dialog with information about the input
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Input Information'),
                                          content: const Text(
                                            'Please enter your full name. Only letters and spaces are allowed.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  tooltip:
                                      'Text only. Letters and spaces are allowed.',
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Full Name is required';
                                } else if (!RegExp(r'^[a-zA-Z\s.]+$')
                                    .hasMatch(value)) {
                                  return 'Full Name must only contain letters and spaces';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _nationalityController,
                        decoration: const InputDecoration(
                          labelText: 'Nationality (Eg: Srilankan)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nicController,
                              decoration: InputDecoration(
                                labelText: 'NIC*',
                                hintText: 'Enter your NIC',
                                border: const OutlineInputBorder(),
                                errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {
                                    // Show a dialog with information about the NIC format
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'NIC Format Information'),
                                          content: const Text(
                                            'Please enter your NIC in the correct format:\n'
                                            '- Old NIC: 9 digits followed by "V" or "X" (e.g., 123456789V)\n'
                                            '- New NIC: 12 digits (e.g., 123456789123)\n'
                                            '- Spaces are not allowed.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  tooltip: 'NIC format information',
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'NIC is required';
                                }

                                // Remove any whitespaces (if applicable)
                                value = value.replaceAll(' ', '');

                                // Check if the input starts with digits
                                if (!RegExp(r'^[0-9]').hasMatch(value)) {
                                  return 'Invalid NIC format';
                                }

                                // Check the length of the NIC
                                if (value.length != 10 && value.length != 12) {
                                  return 'NIC must be 10 (Old NIC) or 12 (New NIC) characters long';
                                }

                                // Check for old version NIC (9 digits + 'V' or 'X')
                                if (value.length == 10 &&
                                    !RegExp(r'^[0-9]{9}[VX]$')
                                        .hasMatch(value)) {
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
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _drivingLicenceController,
                              decoration: InputDecoration(
                                labelText: 'Driving License',
                                border: const OutlineInputBorder(),
                                errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Driving License Format Information'),
                                          content: const Text(
                                            'If you provide a driving license number, it must follow the Sri Lankan format:\n'
                                            '- Format: Two uppercase letters followed by 9 digits (e.g., AB123456789).\n'
                                            'Spaces are not allowed.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  tooltip: 'Driving license format information',
                                ),
                              ),
                              autovalidateMode: AutovalidateMode
                                  .onUserInteraction, // Enable validation only during user interaction
                              validator: (value) {
                                // Regular expression pattern for Sri Lankan driving license
                                RegExp regex = RegExp(
                                    r'^[A-Z]{2}\d{9}$'); // Example pattern: AB123456789

                                // Only validate if the field is not empty
                                if (value != null &&
                                    value.isNotEmpty &&
                                    !regex.hasMatch(value)) {
                                  return 'Invalid driving license format';
                                }

                                // Return null if the input is valid or if the field is empty
                                return null;
                              },
                            ),
                          ),
                        ],
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
                          labelText: 'Select Date of Birth*',
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
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'Age*',
                          border: const OutlineInputBorder(),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.info_outline),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Age Field Information'),
                                    content: const Text(
                                      'Please enter your age as an integer.\n'
                                      'Only numbers are allowed.\n'
                                      'The age should be between 1 and 99.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            tooltip: 'Age input information',
                          ),
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
                            return 'Invalid age: Only numbers are allowed';
                          }
                          // Check if age is within the range of 1 to 99
                          if (age < 1 || age > 99) {
                            return 'Age must be between 1 and 99';
                          }

                          return null; // Return null if the input is valid
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address*',
                          hintText: 'Enter your email address',
                          border: const OutlineInputBorder(),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.info_outline),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title:
                                        const Text('Email Format Information'),
                                    content: const Text(
                                      '-Please enter a valid email address.\n'
                                      '-Format: example@domain.com\n'
                                      '-Ensure there are no spaces and the domain has at least two characters.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            tooltip: 'Email format information',
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email Address is required';
                          }

                          // Regular expression pattern for email validation
                          RegExp regex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[a-zA-Z]{2,}$');
                          if (!regex.hasMatch(value)) {
                            return 'Enter a valid email address';
                          }

                          return null; // Return null if the input is valid
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _contactMobileController,
                              decoration: InputDecoration(
                                labelText: 'Tel (Mobile)*',
                                hintText: 'EX: +94718524560/ 0718524560',
                                border: const OutlineInputBorder(),
                                errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Mobile Number Format Information'),
                                          content: const Text(
                                            '-Please enter a valid Sri Lankan mobile number.\n'
                                            '-Format: +94xxxxxxxxx or 0xxxxxxxxx\n'
                                            '-Example: +9471272009 or 0712752009\n'
                                            '-Ensure the number starts with +94 or 0',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  tooltip: 'Mobile number format information',
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Mobile number is required';
                                }

                                // Regular expression pattern for Sri Lankan mobile number format
                                RegExp regex = RegExp(
                                    r'^(?:\+94|0)?[1-9][0-9]{8}$'); // +94 or 0 followed by 9 digits

                                if (!regex.hasMatch(value)) {
                                  return 'Invalid mobile number format';
                                }

                                return null; // Return null if the input is valid
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _contactHomeController,
                              decoration: InputDecoration(
                                labelText: 'Tel (Home)',
                                hintText: 'EX: +94718524560',
                                border: const OutlineInputBorder(),
                                errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Contact Number Format Information'),
                                          content: const Text(
                                            'If you provide a home contact number, it must follow the Sri Lankan format:\n'
                                            'Format: +94xxxxxxxxx or 0xxxxxxxxx\n'
                                            'Example: +94718524560 or 0718524560\n'
                                            'Ensure the number starts with +94 or 0, followed by 9 digits.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  tooltip: 'Contact number format information',
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                // Only validate if a value is provided
                                if (value != null && value.isNotEmpty) {
                                  // Regular expression pattern for Sri Lankan home contact number format
                                  RegExp regex =
                                      RegExp(r'^(?:\+94|0)[1-9][0-9]{8}$');
                                  if (!regex.hasMatch(value)) {
                                    return 'Enter a valid Sri Lankan home contact number';
                                  }
                                }
                                // Return null if the input is valid or if the field is empty
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _addressController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                labelText: 'Address*',
                                border: const OutlineInputBorder(),
                                errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Address Information'),
                                          content: const Text(
                                            'Please enter your address.\n'
                                            'The address is required and must not be empty.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  tooltip: 'Address information',
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Address is required';
                                }
                                return null; // Return null if the input is valid
                              },
                            ),
                          ),
                        ],
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
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _salaryController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                labelText: 'Minimum Salary Expectation (LKR)*',
                                hintText: '25000',
                                border: const OutlineInputBorder(),
                                errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Salary Information'),
                                          content: const Text(
                                            '-Please enter your minimum salary expectation in Sri Lankan Rupees (LKR).\n'
                                            '-The amount should be an integer value only (e.g: 25000).\n',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  tooltip: 'Salary expectation information',
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Minimum Salary Expectation is required';
                                }
                                int salary;
                                try {
                                  salary = int.parse(value);
                                } catch (e) {
                                  return 'Enter a valid salary amount (e.g., 25000)';
                                }
                                // Check if the salary meets the minimum expectation

                                return null; // Return null if the input is valid
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons
                                .swap_horizontal_circle, // You can choose any icon you like
                            color:
                                Color.fromARGB(255, 231, 75, 75), // Icon color
                            size: 20.0, // Icon size
                          ),
                          SizedBox(
                              width: 8.0), // Space between the icon and text
                          Text(
                            "Swap to go to Educational section",
                            style: TextStyle(
                              color: Color.fromARGB(
                                  255, 231, 75, 75), // Text color
                              fontSize: 16.0, // Font size
                              fontWeight: FontWeight.bold, // Font weight
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
                          'Undergraduate',
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

                      // Conditionally display NVQ Level Dropdown
                      if (_selectEduQalification != 'Below O/L') ...[
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
                            labelText: 'NVQ Level',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Conditionally display GCE O/L Exam Section
                      if (_selectEduQalification != 'Below O/L') ...[
                        const Text(
                          'GCE O/L Exam:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _OLYearController,
                          decoration: InputDecoration(
                            labelText: 'Year*',
                            hintText: 'Ex: 2016',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _selectEduQalification != 'Below O/L' &&
                                        _OLYearController.text.isNotEmpty &&
                                        !RegExp(r'^\d{4}$')
                                            .hasMatch(_OLYearController.text)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _selectEduQalification != 'Below O/L' &&
                                        _OLYearController.text.isNotEmpty &&
                                        !RegExp(r'^\d{4}$')
                                            .hasMatch(_OLYearController.text)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            errorText: _selectEduQalification != 'Below O/L' &&
                                    _OLYearController.text.isNotEmpty &&
                                    !RegExp(r'^\d{4}$')
                                        .hasMatch(_OLYearController.text)
                                ? 'Enter a valid 4-digit year'
                                : null,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed: () {
                                // Show a tooltip or dialog with information about the input
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Input Information'),
                                      content: const Text(
                                        'Please enter a 4-digit year. For example, 2016.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              tooltip: 'Enter a 4-digit year',
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (_selectEduQalification != 'Below O/L') {
                              if (value == null || value.isEmpty) {
                                return 'Year is required';
                              }
                              if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                                return 'Enter a valid 4-digit year';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _OLIndexController,
                          decoration: InputDecoration(
                            labelText: 'Index No',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _selectEduQalification != 'Below O/L' &&
                                        _OLIndexController.text.isNotEmpty &&
                                        !RegExp(r'^[a-zA-Z0-9]+$')
                                            .hasMatch(_OLIndexController.text)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _selectEduQalification != 'Below O/L' &&
                                        _OLIndexController.text.isNotEmpty &&
                                        !RegExp(r'^[a-zA-Z0-9]+$')
                                            .hasMatch(_OLIndexController.text)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (_selectEduQalification != 'Below O/L') {
                              if (value == null || value.isEmpty) {
                                return 'Index No is required';
                              }
                              if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                                return 'Enter a valid index number (letters and/or numbers only)';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _OLMediumController,
                          decoration: InputDecoration(
                            labelText: 'Medium',
                            hintText: 'Ex: Sinhala',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _selectEduQalification != 'Below O/L' &&
                                        _OLMediumController.text.isNotEmpty &&
                                        !RegExp(r'^[a-zA-Z]+$')
                                            .hasMatch(_OLMediumController.text)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _selectEduQalification != 'Below O/L' &&
                                        _OLMediumController.text.isNotEmpty &&
                                        !RegExp(r'^[a-zA-Z]+$')
                                            .hasMatch(_OLMediumController.text)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (_selectEduQalification != 'Below O/L') {
                              if (value == null || value.isEmpty) {
                                return 'Medium is required';
                              }
                              if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                                return 'Enter a valid medium (letters only)';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _OLSchoolController,
                          decoration: InputDecoration(
                            labelText: 'School',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _selectEduQalification != 'Below O/L' &&
                                        _OLSchoolController.text.isNotEmpty &&
                                        !RegExp(r'^[a-zA-Z\s./]+$')
                                            .hasMatch(_OLSchoolController.text)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _selectEduQalification != 'Below O/L' &&
                                        _OLSchoolController.text.isNotEmpty &&
                                        !RegExp(r'^[a-zA-Z\s./]+$')
                                            .hasMatch(_OLSchoolController.text)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (_selectEduQalification != 'Below O/L') {
                              if (value == null || value.isEmpty) {
                                return 'School is required';
                              }
                              if (!RegExp(r'^[a-zA-Z\s./]+$').hasMatch(value)) {
                                return 'Enter a valid school name (letters,spaces, . /  only)';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _OLAttemptController,
                          decoration: InputDecoration(
                            labelText: 'Attempt',
                            hintText: 'Ex: 1',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _selectEduQalification != 'Below O/L' &&
                                        _OLAttemptController.text.isNotEmpty &&
                                        !RegExp(r'^[1-9]$')
                                            .hasMatch(_OLAttemptController.text)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _selectEduQalification != 'Below O/L' &&
                                        _OLAttemptController.text.isNotEmpty &&
                                        !RegExp(r'^[1-9]$')
                                            .hasMatch(_OLAttemptController.text)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (_selectEduQalification != 'Below O/L') {
                              if (value == null || value.isEmpty) {
                                return 'Attempt is required';
                              }
                              if (!RegExp(r'^[1-9]$').hasMatch(value)) {
                                return 'Enter a valid attempt (single number only)';
                              }
                            }
                            return null;
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
                      ],

                      // Conditionally display GCE A/L Exam Section
                      if (_selectEduQalification == 'Passed A/L' ||
                          _selectEduQalification == 'Undergraduate' ||
                          _selectEduQalification == 'Graduate' ||
                          _selectEduQalification ==
                              'Post Graduate Diploma') ...[
                        const Text(
                          'GCE A/L Exam:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _ALYearController,
                          decoration: InputDecoration(
                            labelText: 'Year',
                            hintText: 'Ex: 2016',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _selectEduQalification != 'Below O/L' &&
                                        _ALYearController.text.isNotEmpty &&
                                        !RegExp(r'^\d{4}$')
                                            .hasMatch(_ALYearController.text)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _selectEduQalification != 'Below O/L' &&
                                        _ALYearController.text.isNotEmpty &&
                                        !RegExp(r'^\d{4}$')
                                            .hasMatch(_ALYearController.text)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (_selectEduQalification != 'Below O/L') {
                              if (value == null || value.isEmpty) {
                                return 'Year is required';
                              }
                              if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                                return 'Enter a valid year (4 digits only)';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _ALIndexController,
                          decoration: InputDecoration(
                            labelText: 'Index No',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: (_selectEduQalification ==
                                                'Passed A/L' ||
                                            _selectEduQalification ==
                                                'Undergraduate' ||
                                            _selectEduQalification ==
                                                'Graduate' ||
                                            _selectEduQalification ==
                                                'Post Graduate Diploma') &&
                                        _ALIndexController.text.isNotEmpty &&
                                        !RegExp(r'^[0-9]+$')
                                            .hasMatch(_ALIndexController.text)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: (_selectEduQalification ==
                                                'Passed A/L' ||
                                            _selectEduQalification ==
                                                'Undergraduate' ||
                                            _selectEduQalification ==
                                                'Graduate' ||
                                            _selectEduQalification ==
                                                'Post Graduate Diploma') &&
                                        _ALIndexController.text.isNotEmpty &&
                                        !RegExp(r'^[0-9]+$')
                                            .hasMatch(_ALIndexController.text)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (_selectEduQalification == 'Passed A/L' ||
                                _selectEduQalification == 'Undergraduate' ||
                                _selectEduQalification == 'Graduate' ||
                                _selectEduQalification ==
                                    'Post Graduate Diploma') {
                              if (value == null || value.isEmpty) {
                                return 'Index No is required';
                              }
                              if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                                return 'Enter a valid index number (numbers only)';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _ALMediumController,
                          decoration: InputDecoration(
                            labelText: 'Medium',
                            hintText: 'Ex: Sinhala',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: (_selectEduQalification ==
                                                'Passed A/L' ||
                                            _selectEduQalification ==
                                                'Undergraduate' ||
                                            _selectEduQalification ==
                                                'Graduate' ||
                                            _selectEduQalification ==
                                                'Post Graduate Diploma') &&
                                        _ALMediumController.text.isNotEmpty &&
                                        !RegExp(r'^[a-zA-Z\s]+$')
                                            .hasMatch(_ALMediumController.text)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: (_selectEduQalification ==
                                                'Passed A/L' ||
                                            _selectEduQalification ==
                                                'Undergraduate' ||
                                            _selectEduQalification ==
                                                'Graduate' ||
                                            _selectEduQalification ==
                                                'Post Graduate Diploma') &&
                                        _ALMediumController.text.isNotEmpty &&
                                        !RegExp(r'^[a-zA-Z\s]+$')
                                            .hasMatch(_ALMediumController.text)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (_selectEduQalification == 'Passed A/L' ||
                                _selectEduQalification == 'Undergraduate' ||
                                _selectEduQalification == 'Graduate' ||
                                _selectEduQalification ==
                                    'Post Graduate Diploma') {
                              if (value == null || value.isEmpty) {
                                return 'Medium is required';
                              }
                              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                                return 'Enter a valid medium (letters only)';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _ALSchoolController,
                          decoration: const InputDecoration(
                            labelText: 'School',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _ALAttemptController,
                          decoration: const InputDecoration(
                            labelText: 'Attempt',
                            hintText: 'Ex: 1',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            }
                            RegExp regex = RegExp(r'^[0-9]+$./');
                            if (!regex.hasMatch(value)) {
                              return 'Enter a valid attempt (numbers only)';
                            }
                            return null;
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
                      ],

                      // Conditionally display Professional Qualifications Section
                      if (_selectEduQalification == 'Undergraduate' ||
                          _selectEduQalification == 'Graduate' ||
                          _selectEduQalification ==
                              'Post Graduate Diploma') ...[
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
                            labelText: 'Name of Qualification',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _sec01InstituteController,
                          decoration: const InputDecoration(
                            labelText: 'Institute/Organization',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _sec01durationController,
                          decoration: const InputDecoration(
                            labelText: 'Completion Year',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
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
                            labelText: 'Name of Qualification',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _sec02InstituteController,
                          decoration: const InputDecoration(
                            labelText: 'Institute/Organization',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _sec02durationController,
                          decoration: const InputDecoration(
                            labelText: 'Completion Year',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons
                                  .swap_horizontal_circle, // You can choose any icon you like
                              color: Color.fromARGB(
                                  255, 231, 75, 75), // Icon color
                              size: 20.0, // Icon size
                            ),
                            SizedBox(
                                width: 8.0), // Space between the icon and text
                            Text(
                              "Swap to go to Persomal information Tab \n or Skill Tab",
                              style: TextStyle(
                                color: Color.fromARGB(
                                    255, 231, 75, 75), // Text color
                                fontSize: 16.0, // Font size
                                fontWeight: FontWeight.bold, // Font weight
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
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
                        const SizedBox(height: 10),
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
                          controller: _specialSkillController,
                          decoration: const InputDecoration(
                            labelText: 'Special Skills',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
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
                        const Text(
                          'Job Experience:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        SizedBox(height: 20),

                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: _selectedExperience,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedExperience = newValue;
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
                            labelText: 'Do you have job experience?',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Conditionally display Job Experience fields
                        if (_selectedExperience == 'Yes') ...[
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
                              labelText: 'Job Position',
                              hintText: 'HR Manager',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Job position is required';
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
                            controller: _companyController,
                            decoration: const InputDecoration(
                              labelText: 'Company Name',
                              hintText: 'Ex: MAS company',
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
                          const SizedBox(height: 20),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons
                                    .swap_horizontal_circle, // You can choose any icon you like
                                color: Color.fromARGB(
                                    255, 231, 75, 75), // Icon color
                                size: 20.0, // Icon size
                              ),
                              SizedBox(
                                  width:
                                      8.0), // Space between the icon and text
                              Text(
                                "Swap to go to  Education Tab \n or Job Experience Tab",
                                style: TextStyle(
                                  color: Color.fromARGB(
                                      255, 231, 75, 75), // Text color
                                  fontSize: 16.0, // Font size
                                  fontWeight: FontWeight.bold, // Font weight
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
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
                          maxLines: 3,
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
                          'preferred Jobs:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Preferred Jobs fields
                        Column(
                          children: <Widget>[
                            const Text(
                              'Select Preferred Industries',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Column(
                              children: <Widget>[
                                ...allIndustries.map<Widget>((industry) {
                                  return CheckboxListTile(
                                    checkColor:
                                        const Color.fromARGB(255, 255, 183, 0),
                                    activeColor: Colors.white,
                                    value:
                                        prefered_industries.contains(industry),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          prefered_industries.add(industry);
                                        } else {
                                          prefered_industries.remove(industry);
                                        }
                                        _updatePreferredIndustries();
                                      });
                                    },
                                    title: Text(industry),
                                  );
                                }).toList(),
                              ],
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
                              value: selectPrefferedDistrict,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectPrefferedDistrict = newValue;
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

                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons
                                      .warning, // You can choose any icon you like
                                  color: Color.fromARGB(
                                      255, 231, 75, 75), // Icon color
                                  size: 20.0, // Icon size
                                ),
                                SizedBox(
                                    width:
                                        8.0), // Space between the icon and text
                                Flexible(
                                  child: Text(
                                    "Kindly review all your details before getting your own CV",
                                    style: TextStyle(
                                      color: Color.fromARGB(
                                          255, 231, 75, 75), // Text color
                                      fontSize: 16.0, // Font size
                                      fontWeight:
                                          FontWeight.bold, // Font weight
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 30),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Combined button that handles form submission and PDF generation
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      // Call the function to add job seeker profile
                                      await _firebaseService!.addCVdetails(
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
                                        _selectProfQualification,
                                        _OLYearController.text,
                                        _OLIndexController.text,
                                        _OLMediumController.text,
                                        _OLSchoolController.text,
                                        _OLAttemptController.text,
                                        _selectOLStatus,
                                        _ALYearController.text,
                                        _ALIndexController.text,
                                        _ALMediumController.text,
                                        _ALSchoolController.text,
                                        _ALAttemptController.text,
                                        _selectALStatus,
                                        _sec01NameController.text,
                                        _sec01InstituteController.text,
                                        _sec01durationController.text,
                                        _sec02NameController.text,
                                        _sec02InstituteController.text,
                                        _sec02durationController.text,
                                        _yearOfExperienceController.text,
                                        _currentJobPositionController.text,
                                        _dateOfJoinController.text,
                                        _companyController.text,
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
                                        prefered_industries,
                                        selectPrefferedDistrict!,
                                      );

                                      // Show success message
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.success,
                                        title: 'Data confirmation Success',
                                        text: 'Now generating your CV PDF...',
                                      );

                                      // Generate the PDF
                                      generatePdfFromFirebase();
                                    } else {
                                      // If the form is invalid, show an error message
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.error,
                                        title: 'Error',
                                        text:
                                            'Please fill in all the required fields',
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 9, 116, 41),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 32),
                                  ),
                                  child: Text(
                                    Localization.of(context)
                                            .getTranslatedValue('Get CV') ??
                                        'Get CV',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 19), // Text color
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CVUpload(
                                          userId: '',
                                        ), // Navigate to CVUpload page
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 9, 116, 41),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 32),
                                  ),
                                  child: Text(
                                    'Upload CV',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 19),
                                  ),
                                ),
                              ],
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

  Future<void> _updatePreferredIndustries() async {
    if (_userDocId == null) return;

    try {
      await _firestore.collection('CVDetails').doc(_userDocId).update({
        'prefered_industries': prefered_industries,
      });
    } catch (e) {
      print('Error updating data: $e');
    }
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

//PDF generating unction
Future<void> generatePdfFromFirebase() async {
  final pdf = pw.Document();

  // Create an instance of FirebaseService
  final firebaseService = FirebaseService();

  // Fetch user details from Firestore
  final user = FirebaseAuth.instance.currentUser;
  final uid = user?.uid;
  final userDetails = await firebaseService.getCVDetails(uid!);
  if (userDetails != null) {
    // Add a page to the PDF document
    final page1 = pw.Page(
      build: (pw.Context context) {
        // Check if there is any qualification data
        bool hasProfessionalQualifications =
            (userDetails['sec01Name'] != null &&
                    userDetails['sec01Ins'] != null &&
                    userDetails['sec01duration'] != null &&
                    userDetails['sec01Name'].isNotEmpty &&
                    userDetails['sec01Ins'].isNotEmpty &&
                    userDetails['sec01duration'].isNotEmpty) ||
                (userDetails['sec02Name'] != null &&
                    userDetails['sec02Ins'] != null &&
                    userDetails['sec02duration'] != null &&
                    userDetails['sec02Name'].isNotEmpty &&
                    userDetails['sec02Ins'].isNotEmpty &&
                    userDetails['sec02duration'].isNotEmpty);

        // Check if GCE A/L details are present
        bool hasALDetails = (userDetails['ALYear'] != null &&
            userDetails['ALIndex'] != null &&
            userDetails['ALMedium'] != null &&
            userDetails['ALSchool'] != null &&
            userDetails['ALAttempt'] != null &&
            (userDetails['ALYear'].isNotEmpty ||
                userDetails['ALIndex'].isNotEmpty ||
                userDetails['ALMedium'].isNotEmpty ||
                userDetails['ALSchool'].isNotEmpty ||
                userDetails['ALAttempt'].isNotEmpty));

        // Check if GCE O/L details are present
        bool hasOLDetails = (userDetails['OLYear'] != null &&
            userDetails['OLIndex'] != null &&
            userDetails['OLMedium'] != null &&
            userDetails['OLSchool'] != null &&
            userDetails['OLAttempt'] != null &&
            (userDetails['OLYear'].isNotEmpty ||
                userDetails['OLIndex'].isNotEmpty ||
                userDetails['OLMedium'].isNotEmpty ||
                userDetails['OLSchool'].isNotEmpty ||
                userDetails['OLAttempt'].isNotEmpty));

        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Title and Name
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              color: PdfColors.white, // Color for the title row
              child: pw.Header(
                level: 1,
                text: '${userDetails['title']} ${userDetails['fullname']}',
                textStyle: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue600, // Text color
                ),
              ),
            ),

            // Personal Information
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              color: PdfColors.white, // Color for personal information section
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Paragraph(
                    text: '${userDetails['cv_email']}',
                  ),
                  pw.Paragraph(
                    text: '${userDetails['contactMobile']}',
                  ),
                  pw.Paragraph(
                    text: '${userDetails['address']}',
                  ),
                ],
              ),
            ),

            // Career Objectives
            if (userDetails['careerObjective'] != null &&
                userDetails['careerObjective'].isNotEmpty) ...[
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                color: PdfColors.white, // Color for the section
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Header(
                      level: 1,
                      text: 'Career Objectives',
                      textStyle: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black, // Text color
                      ),
                    ),
                    pw.Paragraph(
                      text: userDetails['careerObjective'],
                    ),
                  ],
                ),
              ),
            ],

            // Educational Details
            if (userDetails['OLYear'] != null ||
                userDetails['ALYear'] != null ||
                userDetails['sec01Name'] != null ||
                userDetails['sec02Name'] != null) ...[
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                color: PdfColors.white, // Color for educational details section
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Header(
                      level: 1,
                      text: 'Educational Details',
                      textStyle: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black, // Text color
                      ),
                    ),

                    // GCE O/L Exam details
                    if (hasOLDetails) ...[
                      pw.Paragraph(
                        text: 'GCE O/L Exam:',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (userDetails['OLYear'] != null &&
                                  userDetails['OLYear'].isNotEmpty)
                                pw.Paragraph(
                                    text: 'Year: ${userDetails['OLYear']}'),
                              if (userDetails['OLIndex'] != null &&
                                  userDetails['OLIndex'].isNotEmpty)
                                pw.Paragraph(
                                    text:
                                        'Index Number: ${userDetails['OLIndex']}'),
                            ],
                          ),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (userDetails['OLMedium'] != null &&
                                  userDetails['OLMedium'].isNotEmpty)
                                pw.Paragraph(
                                    text: 'Medium: ${userDetails['OLMedium']}'),
                              if (userDetails['OLSchool'] != null &&
                                  userDetails['OLSchool'].isNotEmpty)
                                pw.Paragraph(
                                    text: 'School: ${userDetails['OLSchool']}'),
                            ],
                          ),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (userDetails['OLAttempt'] != null &&
                                  userDetails['OLAttempt'].isNotEmpty)
                                pw.Paragraph(
                                    text:
                                        'Attempt: ${userDetails['OLAttempt']}'),
                            ],
                          ),
                        ],
                      ),
                    ],

                    // GCE A/L Exam details
                    if (hasALDetails) ...[
                      pw.Paragraph(
                        text: 'GCE A/L Exam:',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (userDetails['ALYear'] != null &&
                                  userDetails['ALYear'].isNotEmpty)
                                pw.Paragraph(
                                    text: 'Year: ${userDetails['ALYear']}'),
                              if (userDetails['ALIndex'] != null &&
                                  userDetails['ALIndex'].isNotEmpty)
                                pw.Paragraph(
                                    text:
                                        'Index Number: ${userDetails['ALIndex']}'),
                            ],
                          ),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (userDetails['ALMedium'] != null &&
                                  userDetails['ALMedium'].isNotEmpty)
                                pw.Paragraph(
                                    text: 'Medium: ${userDetails['ALMedium']}'),
                              if (userDetails['ALSchool'] != null &&
                                  userDetails['ALSchool'].isNotEmpty)
                                pw.Paragraph(
                                    text: 'School: ${userDetails['ALSchool']}'),
                            ],
                          ),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (userDetails['ALAttempt'] != null &&
                                  userDetails['ALAttempt'].isNotEmpty)
                                pw.Paragraph(
                                    text:
                                        'Attempt: ${userDetails['ALAttempt']}'),
                            ],
                          ),
                        ],
                      ),
                    ],

                    // Professional Qualifications
                    if (hasProfessionalQualifications) ...[
                      pw.Paragraph(
                        text: 'Professional Qualification:',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (userDetails['sec01Name'] != null &&
                                  userDetails['sec01Ins'] != null &&
                                  userDetails['sec01duration'] != null &&
                                  userDetails['sec01Name'].isNotEmpty &&
                                  userDetails['sec01Ins'].isNotEmpty &&
                                  userDetails['sec01duration'].isNotEmpty)
                                pw.Paragraph(
                                  text:
                                      '*  ${userDetails['sec01Name']}, ${userDetails['sec01Ins']} (${userDetails['sec01duration']})',
                                ),
                              if (userDetails['sec02Name'] != null &&
                                  userDetails['sec02Ins'] != null &&
                                  userDetails['sec02duration'] != null &&
                                  userDetails['sec02Name'].isNotEmpty &&
                                  userDetails['sec02Ins'].isNotEmpty &&
                                  userDetails['sec02duration'].isNotEmpty)
                                pw.Paragraph(
                                  text:
                                      '*  ${userDetails['sec02Name']}, ${userDetails['sec02Ins']} (${userDetails['sec02duration']})',
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );

    final page2 = pw.Page(
      build: (pw.Context context) {
        // Check if all required fields are present and not empty
        bool hasExperienceData = userDetails['yearOfExperience'] != null &&
            userDetails['yearOfExperience'].isNotEmpty &&
            userDetails['currentEmployee'] != null &&
            userDetails['currentEmployee'].isNotEmpty &&
            userDetails['currentJobPosition'] != null &&
            userDetails['currentJobPosition'].isNotEmpty &&
            userDetails['dateOfJoin'] != null &&
            userDetails['dateOfJoin'].isNotEmpty;

        // Check if any honors or achievements data is available
        bool hasHonorsAchievements = (userDetails['achievements'] != null &&
                userDetails['achievements'].isNotEmpty) ||
            (userDetails['extraCurricular'] != null &&
                userDetails['extraCurricular'].isNotEmpty);
        bool hasSkillsData = userDetails['computerSkill'] != null &&
                userDetails['computerSkill'].isNotEmpty ||
            userDetails['specialSkill'] != null &&
                userDetails['specialSkill'].isNotEmpty;

        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (hasSkillsData)
              // Skills
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                color: PdfColors.white, // Color for skills section
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Header(
                      level: 1,
                      text: 'Skills',
                      textStyle: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black, // Text color
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(10),
                      color:
                          PdfColors.white, // Color for skills content section
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    if (userDetails['computerSkill'] != null &&
                                        userDetails['computerSkill'].isNotEmpty)
                                      pw.Paragraph(
                                        text:
                                            'Computer Skills: ${userDetails['computerSkill']}',
                                      ),
                                    if (userDetails['specialSkill'] != null &&
                                        userDetails['specialSkill'].isNotEmpty)
                                      pw.Paragraph(
                                        text:
                                            'Special Skills: ${userDetails['specialSkill']}',
                                      ),
                                  ],
                                ),
                              ),
                              pw.SizedBox(
                                  width:
                                      20), // Add some space between the columns
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(10),
                      color:
                          PdfColors.white, // Color for language skills section
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Header(
                            level: 1,
                            text: 'Language Skills',
                            textStyle: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.black, // Text color
                            ),
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  if (userDetails['sinhalaSpeaking'] != null)
                                    pw.Paragraph(
                                      text:
                                          'Sinhala Speaking: ${userDetails['sinhalaSpeaking']}',
                                    ),
                                  if (userDetails['sinhalaReading'] != null)
                                    pw.Paragraph(
                                      text:
                                          'Sinhala Reading: ${userDetails['sinhalaReading']}',
                                    ),
                                  if (userDetails['sinhalaWriting'] != null)
                                    pw.Paragraph(
                                      text:
                                          'Sinhala Writing: ${userDetails['sinhalaWriting']}',
                                    ),
                                ],
                              ),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  if (userDetails['englishSpeaking'] != null)
                                    pw.Paragraph(
                                      text:
                                          'English Speaking: ${userDetails['englishSpeaking']}',
                                    ),
                                  if (userDetails['englishReading'] != null)
                                    pw.Paragraph(
                                      text:
                                          'English Reading: ${userDetails['englishReading']}',
                                    ),
                                  if (userDetails['englishWriting'] != null)
                                    pw.Paragraph(
                                      text:
                                          'English Writing: ${userDetails['englishWriting']}',
                                    ),
                                ],
                              ),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  if (userDetails['tamilSpeaking'] != null)
                                    pw.Paragraph(
                                      text:
                                          'Tamil Speaking: ${userDetails['tamilSpeaking']}',
                                    ),
                                  if (userDetails['tamilReading'] != null)
                                    pw.Paragraph(
                                      text:
                                          'Tamil Reading: ${userDetails['tamilReading']}',
                                    ),
                                  if (userDetails['tamilWriting'] != null)
                                    pw.Paragraph(
                                      text:
                                          'Tamil Writing: ${userDetails['tamilWriting']}',
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            // Honors and Achievements
            if (hasHonorsAchievements)
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                color: PdfColors
                    .white, // Color for honors and achievements section
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Header(
                      level: 1,
                      text: 'Honors and Achievements',
                      textStyle: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black, // Text color
                      ),
                    ),
                    pw.Row(
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            if (userDetails['achievements'] != null &&
                                userDetails['achievements'].isNotEmpty)
                              pw.Text('*. ${userDetails['achievements']}'),
                            if (userDetails['extraCurricular'] != null &&
                                userDetails['extraCurricular'].isNotEmpty)
                              pw.Text('*. ${userDetails['extraCurricular']}'),
                          ],
                        ),
                        pw.SizedBox(
                            width: 20), // Add some space between the columns
                      ],
                    ),
                  ],
                ),
              ),
            // Experience
            if (hasExperienceData)
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                color: PdfColors.white, // Color for experience section
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Header(
                      level: 1,
                      text: 'Experience',
                      textStyle: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black, // Text color
                      ),
                    ),
                    pw.Row(
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Year of Job Experience: ${userDetails['yearOfExperience']} at ${userDetails['currentEmployee']} in ${userDetails['currentJobPosition']} (${userDetails['dateOfJoin']})',
                            ),
                          ],
                        ),
                        pw.SizedBox(
                            width: 20), // Add some space between the columns
                      ],
                    ),
                  ],
                ),
              ),
            // References
            if ((userDetails['refeeOne'] != null &&
                    userDetails['refeeOne'].isNotEmpty) ||
                (userDetails['refeeTwo'] != null &&
                    userDetails['refeeTwo'].isNotEmpty))
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                color: PdfColors.white, // Color for references section
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Header(
                      level: 1,
                      text: 'References',
                      textStyle: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black, // Text color
                      ),
                    ),
                    pw.Row(
                      children: [
                        if (userDetails['refeeOne'] != null &&
                            userDetails['refeeOne'].isNotEmpty)
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Paragraph(
                                  text: '${userDetails['refeeOne']}',
                                  style: pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (userDetails['refeeTwo'] != null &&
                            userDetails['refeeTwo'].isNotEmpty)
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Paragraph(
                                  text: '${userDetails['refeeTwo']}',
                                  style: pw.TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );

    pdf.addPage(page1);
    pdf.addPage(page2);

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
