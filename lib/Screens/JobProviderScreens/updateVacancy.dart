import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/ProfileJobProvider.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';

class VacancyUpdaterUI extends StatefulWidget {
  final String vacancyId;
  const VacancyUpdaterUI({super.key, required this.vacancyId});

  @override
  State<VacancyUpdaterUI> createState() => _VacancyUpdaterUIState();
}

class _VacancyUpdaterUIState extends State<VacancyUpdaterUI> {
  FirebaseService? _firebaseService;
  bool isLoading = true;

  String? _companyName, _industryType;

  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic>? _jobProviderDetails;
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _industryTypeController = TextEditingController();
  final TextEditingController _jobPositionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _eduLevelController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? selectedLocation;
  String selectedJobPosition = '';
  DateTime issuedDate = DateTime.now();
  String _gender = 'Male';
  String _educationLevel = 'O/L';
  String _jobType = 'Full Time';
  String _location = 'matara';
  double _minimumAge = 18;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    fetchVacancyDetails();
  }

  void _getProvider() async {
    _jobProviderDetails = await _firebaseService!.getCurrentProviderData();

    if (_jobProviderDetails != null) {
      setState(() {
        _companyNameController.text = _jobProviderDetails!['company_name'];
        _industryTypeController.text = _jobProviderDetails!['industry'];
      });
    }
    _companyName = _jobProviderDetails?['company_name'];
    _industryType = _jobProviderDetails?['industry'];
  }

  void fetchVacancyDetails() async {
    DocumentSnapshot snapshot =
        await _firebaseService!.vacancyCollection.doc(widget.vacancyId).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    setState(() {
      _jobPositionController.text = data['job_position'];
      _descriptionController.text = data['description'];
      _jobType = data['job_type'];
      _gender = data['gender'];
      _ageController.text = data['minimum_age'].toString();
      _eduLevelController.text = data['max_education'] ?? '';
      _educationLevel = data['max_education'];
      _salaryController.text = data['minimum_salary'].toString();
      _location = data['location'];
      isLoading = false;
    });
  }

  void updateVacancy() {
    if (_formKey.currentState!.validate()) {
      _firebaseService!
          .updateVacancy(
              widget.vacancyId,
              _jobPositionController.text,
              _descriptionController.text,
              _jobType,
              _gender,
              _minimumAge,
              _educationLevel,
              double.parse(_salaryController.text),
              _location,
              issuedDate)
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Vacancy updated successfully')));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update vacancy: $error')));
      });
    }
  }

  final List<String> locations = [
    'Akkaraipattu',
    'Ampara',
    'anuradhapura',
    'Badulla',
    'Balangoda',
    'Bandarawela',
    'Batticaloa',
    'Beruwala',
    'Chavakachcheri',
    'Chilaw',
    'Colombo',
    'Dambulla',
    'Dehiwala-Mount Lavinia',
    'Eravur',
    'Galle',
    'Gampola',
    'Hambantota',
    'Happutale',
    'Homagama',
    'Jaffna',
    'Kalmunai',
    'Kalutara',
    'Kandy',
    'Kattankudy',
    'Kegalle',
    'Kelaniya',
    'Kilinochchi',
    'Kolonnawa',
    'Kurunegala',
    'Mannar',
    'Matale',
    'Matara',
    'Minuwangoda',
    'Monaragala',
    'Moratuwa',
    'Mullaitivu',
    'Negombo',
    'Nuwara Eliya',
    'Panadura',
    'Peliyagoda',
    'Point Pedro',
    'Puttalam',
    'Ratnapura',
    'Sri Jayawardenepura Kotte',
    'Tangalle',
    'Trincomalee',
    'Valvettithurai',
    'Vavuniya',
    'Wattala',
    'Wattegama',
    'Weligama',
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Vacancy',
          style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth! * 0.04,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 136, 0),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 255, 136, 0),
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobProviderPage(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobProviderProfile(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.chat),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _jobPositionController,
                        decoration: const InputDecoration(
                          labelText: 'Job Position',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18.0),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        minLines: 3,
                        maxLines: null,
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18.0),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Job Type',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18.0),
                            hintText: _jobType,
                            border: OutlineInputBorder(),
                          ),
                          value: _jobType.isNotEmpty ? _jobType : 'Part Time',
                          items: <String>[
                            'Full Time',
                            'Part Time',
                            'Remote',
                            'Hybrid'
                          ].map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _jobType = newValue!;
                            });
                          }),
                      SizedBox(height: screenHeight * 0.02),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18.0),
                          hintText: _gender,
                          border: OutlineInputBorder(),
                        ),
                        value: _gender,
                        items: <String>['Male', 'Female', 'Any']
                            .map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _gender = newValue!;
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _ageController,
                        decoration: const InputDecoration(
                          labelText: 'Age',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18.0),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Required Education Level',
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18.0),
                          hintText: _educationLevel,
                          border: OutlineInputBorder(),
                        ),
                        value: _educationLevel,
                        items: <String>[
                          'Below O/L',
                          'O/L',
                          'A/L',
                          'Undergraduate',
                          'Graduate',
                          'PostGraduate'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _educationLevel = newValue!;
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _salaryController,
                        decoration: const InputDecoration(
                          labelText: 'minimum salary',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18.0),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: 'Location',
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18.0),
                          hintText: _location,
                          border: OutlineInputBorder(),
                        ),
                        value: locations.contains(_location) ? _location : null,
                        items: locations.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newvalue) {
                          setState(() {
                            _location = newvalue!;
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 143, 255, 120),
                        ),
                        onPressed: updateVacancy,
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
