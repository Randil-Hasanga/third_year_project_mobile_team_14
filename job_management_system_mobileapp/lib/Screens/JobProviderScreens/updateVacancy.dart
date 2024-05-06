import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
  double _minimumAge = 18;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    fetchVacancyDetails();
  }

  void _getProvider() async {
    _jobProviderDetails = await _firebaseService!.getCurrentProviderData();
    print(_jobProviderDetails);

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
      _genderController.text = data['gender'];
      _ageController.text = data['minimum_age'].toString();
      _eduLevelController.text = data['education_level'] ?? '';
      _salaryController.text = data['salary'].toString();
      _locationController.text = data['location'];
    });
  }

  void updateVacancy() {
    if (_formKey.currentState!.validate()) {
      _firebaseService!
          .updateVacancy(
              widget.vacancyId,
              _jobPositionController.text,
              _descriptionController.text,
              _gender,
              _minimumAge,
              _educationLevel,
              double.parse(_salaryController.text),
              _locationController.text,
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

  List<String> jobPositions = [
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
    'Customer Service Manager'
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
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _jobPositionController,
                  decoration: const InputDecoration(
                    labelText: 'Job Position',
                  ),
                ),
                //_buildJobPositionList(),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _genderController,
                  decoration: const InputDecoration(
                    labelText: 'gender',
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _eduLevelController,
                  decoration: const InputDecoration(
                    labelText: 'Required Education Level',
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _salaryController,
                  decoration: const InputDecoration(
                    labelText: 'minimum salary',
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'location',
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                ElevatedButton(
                    onPressed: updateVacancy, child: const Text('Update')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
