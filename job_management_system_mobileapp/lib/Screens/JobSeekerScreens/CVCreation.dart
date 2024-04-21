import 'dart:ffi';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:job_management_system_mobileapp/Screens/Chattings.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CVCreation extends StatefulWidget {
  CVCreation({super.key});

  final FirebaseService firebaseService = FirebaseService();

  @override
  _CVCreationState createState() => _CVCreationState();
}

class _CVCreationState extends State<CVCreation> {
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
  final TextEditingController _religionController = TextEditingController();
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
  final TextEditingController _prefferedAreaController =
      TextEditingController();
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

  List<String> proficiencyLevels = ['Basic', 'Good', 'Fluent'];

  //Tab 04:Job Expectation
  final TextEditingController _careerObjectiveController =
      TextEditingController();
  final TextEditingController _refeeOneController = TextEditingController();
  final TextEditingController _refeeTwoController = TextEditingController();
  final TextEditingController _preferredJobsController =
      TextEditingController();
  String? selectPrefAreaToWork;

  double? _deviceWidth, _deviceHeight;

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
    //responsiveness of the device
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    void showAlert() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
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
                    TextFormField(
                      controller: _religionController,
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
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _contactMobileController,
                      decoration: const InputDecoration(
                        labelText: 'Tel (Mobile)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _contactHomeController,
                      decoration: const InputDecoration(
                        labelText: 'Tel (Home)',
                        border: OutlineInputBorder(),
                      ),
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
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _salaryController,
                      decoration: const InputDecoration(
                        labelText: 'Minimum Salary Expectation (LKR)',
                        border: OutlineInputBorder(),
                      ),
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
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _OLIndexController,
                      decoration: const InputDecoration(
                        labelText: 'Index No',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _OLMediumController,
                      decoration: const InputDecoration(
                        labelText: 'Medium',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _OLSchoolController,
                      decoration: const InputDecoration(
                        labelText: 'School',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _OLAttemptController,
                      decoration: const InputDecoration(
                        labelText: 'Attempt',
                        border: OutlineInputBorder(),
                      ),
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
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _ALIndexController,
                      decoration: const InputDecoration(
                        labelText: 'Index No',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _ALMediumController,
                      decoration: const InputDecoration(
                        labelText: 'Medium',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _ALSchoolController,
                      decoration: const InputDecoration(
                        labelText: 'School',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _ALAttemptController,
                      decoration: const InputDecoration(
                        labelText: 'Attempt',
                        border: OutlineInputBorder(),
                      ),
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
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _sec01InstituteController,
                      decoration: const InputDecoration(
                        labelText: 'Institute Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _sec01durationController,
                      decoration: const InputDecoration(
                        labelText: 'Duration',
                        border: OutlineInputBorder(),
                      ),
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
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _currentJobPositionController,
                        decoration: const InputDecoration(
                          labelText: 'Current Job Position',
                          hintText: 'HR Manager',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _dateOfJoinController,
                        decoration: const InputDecoration(
                          labelText: 'Date of join',
                          hintText: 'xxxx-xx-xx',
                          border: OutlineInputBorder(),
                        ),
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
                      TextFormField(
                        controller: _prefferedAreaController,
                        decoration: const InputDecoration(
                          labelText: 'Area preferred to start Employment',
                          border: OutlineInputBorder(),
                        ),
                      ),
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
                        decoration: const InputDecoration(
                          labelText: 'Referee [1]',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _refeeTwoController,
                        decoration: const InputDecoration(
                          labelText: 'Referee [2]',
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
                      TextFormField(
                        controller: _preferredJobsController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Enter Preferred Jobs',
                          border: OutlineInputBorder(),
                        ),
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
                              // Format the date as a string
                              String formattedDate = _selectedDate != null
                                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                  : '';

                              // Call the function to add job seeker profile
                              FirebaseService().addCVdetails(
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
                                _religionController.text,
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
                                _prefferedAreaController.text,
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
                                _preferredJobsController.text,
                                selectPrefAreaToWork!,
                              );
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
                            onPressed: () {},
                            child: const Text('Create my CV'),
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
