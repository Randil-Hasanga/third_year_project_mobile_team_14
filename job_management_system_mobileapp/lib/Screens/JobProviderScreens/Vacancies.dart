import 'dart:ffi';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:job_management_system_mobileapp/localization/demo_localization.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:quickalert/quickalert.dart';

class vacancies extends StatefulWidget {
  vacancies({super.key});

  @override
  State<vacancies> createState() => _vacanciesState();
}

class _vacanciesState extends State<vacancies> {
  final _formKey = GlobalKey<FormState>();

  final _companyNameController = TextEditingController();

  final _jobPositionController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _salaryController = TextEditingController();

  final _locationController = TextEditingController();

  final _industrytypeController = TextEditingController();

  String? selectedLocation;

  FirebaseService? _firebaseSerice;

  String selectedJobPosition = '';

  String? _companyName;

  DateTime issuedDate = DateTime.now();

  DateTime expiryDate = DateTime.now();

  Map<String, dynamic>? _jobProviderDetails;
  String? orgType, _industry, _logo;

  String _gender = 'Male';

  String jobType = 'Full Time';

  String _educationLevel = 'O/L';

  double _minimumAge = 18;

  bool active = true;

  @override
  void initState() {
    super.initState();
    _firebaseSerice = GetIt.instance.get<FirebaseService>();
    _getProvider();
  }

  void _getProvider() async {
    _jobProviderDetails = await _firebaseSerice!.getCurrentProviderData();

    if (_jobProviderDetails != null) {
      setState(() {
        if (mounted) {
          _companyNameController.text =
              _jobProviderDetails!['company_name'] ?? '';
          orgType = _jobProviderDetails!['org_type'] ?? '';
          _companyName = _jobProviderDetails!['company_name'];
          _industry = _jobProviderDetails!['industry'];
          _logo = _jobProviderDetails!['logo'] ?? '';
        }
      });
      print(_companyName);
    }

    orgType = _jobProviderDetails!['org_type'];
  }

  void _chooseExpiryDate() async {
    final picked = await showBoardDateTimePicker(
      context: context,
      pickerType: DateTimePickerType.datetime,
      initialDate: expiryDate,
      options: BoardDateTimeOptions(
        languages: const BoardPickerLanguages(
          today: 'Today',
          tomorrow: 'Tomorrow',
          now: 'Now',
        ),
        startDayOfWeek: DateTime.monday,
        pickerFormat: PickerFormat.ymd,
        activeColor: Colors.blue.shade200,
        backgroundDecoration: const BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
    if (picked != null && picked != expiryDate) {
      setState(() {
        expiryDate = picked;
      });
    }
  }

  final List<String> items = [
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

  List<String> jobPositions = [
    'Junior Software Engineer',
    'Software Engineer',
    'Product Manager',
    'Data Scientist',
    'UX Designer',
    'QA Engineer',
    'Marketing Manager',
    'Librarian',
    'Receptionist',
    'Bookkeeper',
    'Account Executive',
    'Branch Manager',
    'Secretary',
    'Office Clerk',
    'Supervisor',
    'Administrator',
    'Sales Manager',
    'Cashier',
    'Area Sales Manager',
    'Plumber',
    'Supervisors',
    'Marketing Staff',
    'Customer Service Manager',
    'Business Analyst',
    'Project Manager',
    'Quality Assurance Manager',
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    void showAlert() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Localization.of(context).getTranslatedValue('create_vacancy')!,
          style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth! * 0.04,
              fontWeight: FontWeight.bold),
        ), // Set the title of the app bar
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
                      builder: (context) => ProfileJobSeeker(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>const ));
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat),
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>const ));
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if ((_companyName != null) && (_industry != null)) ...{
                    SizedBox(
                      height: screenHeight * 0.08,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _companyName!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(_industry!),
                        ],
                      ),
                    ),
                  },

                  SizedBox(height: screenHeight * 0.02),

                  //Input for Job Position
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue _JobEditiingValue) {
                      if (_JobEditiingValue.text == '') {
                        return const Iterable<String>.empty();
                      }

                      return jobPositions.where(
                        (String option) {
                          return option
                              .contains(_JobEditiingValue.text.toLowerCase());
                        },
                      );
                    },
                    onSelected: (String value) {
                      if (value != null && jobPositions.contains(value)) {
                        _jobPositionController.text = value;
                        debugPrint('You selected $value');
                      }
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController controller,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return Localization.of(context).getTranslatedValue(
                                'please_enter_job_position')!;
                          }
                          return null;
                        },
                        controller: controller,
                        focusNode: focusNode,
                        onFieldSubmitted: (_) => onFieldSubmitted,
                        decoration: InputDecoration(
                          labelText: Localization.of(context)
                              .getTranslatedValue('job_position')!,
                          hintText: Localization.of(context)
                              .getTranslatedValue('job_position')!,
                          border: OutlineInputBorder(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Localization.of(context).getTranslatedValue(
                            'please_enter_job_description')!;
                      }
                      return null;
                    },
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        labelText: Localization.of(context)
                            .getTranslatedValue('job_description')!,
                        hintText: Localization.of(context)
                            .getTranslatedValue('job_description')!,
                        border: OutlineInputBorder()),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Localization.of(context)
                            .getTranslatedValue('please_enter_job_type')!;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: Localization.of(context)
                          .getTranslatedValue('job_type')!,
                      hintText: Localization.of(context)
                          .getTranslatedValue('job_type')!,
                      border: OutlineInputBorder(),
                    ),
                    value: jobType,
                    items:
                        <String>['Full Time', 'Part Time'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        jobType = newValue!;
                      });
                    },
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please select required gender";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: Localization.of(context)
                          .getTranslatedValue('gender')!,
                      hintText: 'Male',
                      border: OutlineInputBorder(),
                    ),
                    value: _gender,
                    items:
                        <String>['Male', 'Female', 'Any'].map((String value) {
                      return DropdownMenuItem<String>(
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

                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            Localization.of(context)
                                .getTranslatedValue('select_min_age')!,
                          ),
                        ],
                      ),
                    ],
                  ),

                  Slider(
                    min: 18,
                    max: 30,
                    value: _minimumAge,
                    onChanged: (value) {
                      setState(() {
                        _minimumAge = value;
                      });
                    },
                    divisions: 6,
                    label: "$_minimumAge",
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: Localization.of(context)
                          .getTranslatedValue('requied_education')!,
                      hintText: 'O/L',
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Localization.of(context)
                            .getTranslatedValue('please_select_edu_level')!;
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Localization.of(context)
                            .getTranslatedValue('please_enter_salary')!;
                      }
                      return null;
                    },
                    controller: _salaryController,
                    decoration: InputDecoration(
                        labelText: Localization.of(context)
                            .getTranslatedValue('min_salary')!,
                        hintText: Localization.of(context)
                            .getTranslatedValue('min_salary')!,
                        border: OutlineInputBorder()),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  //dropdown for location
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        labelText: Localization.of(context)
                            .getTranslatedValue('location')!,
                        hintText: Localization.of(context)
                            .getTranslatedValue('location')!,
                        border: OutlineInputBorder()),
                    value: selectedLocation,
                    onChanged: (String? value) {
                      selectedLocation = value;
                      _locationController.text = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Localization.of(context)
                            .getTranslatedValue('please_select_location')!;
                      }
                      return null;
                    },
                    items: items.map<DropdownMenuItem<String>>((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  //Date picker for expiry date
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _chooseExpiryDate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            Localization.of(context)
                                .getTranslatedValue('select_expire_date')!,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          Localization.of(context)
                              .getTranslatedValue('selected_expire_date')!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(expiryDate.toString()),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 143, 255, 120),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _firebaseSerice!.addVacancy(
                                _companyName!,
                                _industry!,
                                _jobPositionController.text,
                                _descriptionController.text,
                                _gender,
                                jobType,
                                _minimumAge.toInt(),
                                _educationLevel,
                                double.tryParse(_salaryController.text) ?? 0.0,
                                _locationController.text,
                                issuedDate,
                                expiryDate,
                                orgType!,
                                _logo!);

                            _companyNameController.clear();
                            selectedJobPosition = '';
                            _jobPositionController.clear();
                            _descriptionController.clear();
                            _salaryController.clear();
                            _locationController.clear();
                            expiryDate = DateTime.now();
                            showAlert();
                          }
                        },
                        child: Text(
                          Localization.of(context)
                              .getTranslatedValue('add_vacancy')!,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
