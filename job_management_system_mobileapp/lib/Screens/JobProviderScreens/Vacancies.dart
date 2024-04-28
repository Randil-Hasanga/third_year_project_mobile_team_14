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
  final FirebaseService firebaseService = FirebaseService();

  final _formKey = GlobalKey<FormState>();

  final _companyNameController = TextEditingController();

  final _jobPositionController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _salaryController = TextEditingController();

  final _locationController = TextEditingController();

  String? selectedLocation;

  FirebaseService? firebaseSerice;

  String selectedJobPosition = '';

  String? _companyname;

  DateTime issuedDate = DateTime.now();

  Map<String, dynamic>? _jobProviderDetails;

  @override
  void initState() {
    super.initState();
    firebaseSerice = GetIt.instance.get<FirebaseService>();
  }

  void _getProvider() async {
    _jobProviderDetails = await firebaseSerice!.getCurrentProviderData();

    if (_jobProviderDetails != null) {
      setState(() {
        _companyNameController.text =
            _jobProviderDetails!['company_name'] ?? '';
      });
    }

    _companyname = _jobProviderDetails!['company_name'];
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

    void showAlert() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          DemoLocalization.of(context).getTranslatedValue('create_vacancy')!,
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
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Input for Company Name
                  /*TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter company name";
                      }
                      return null;
                    },
                    controller: _companyNameController,
                    decoration: const InputDecoration(
                        labelText: 'Company Name',
                        hintText: 'Company Name',
                        border: OutlineInputBorder()),
                  ),*/

                  SizedBox(
                    height: screenHeight * 0.02,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('provider_details')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var providerData =
                                snapshot.data?.docs[index].data();
                            String companyName = '';

                            if (providerData != null) {
                              companyName = (providerData
                                      as Map<String, dynamic>)['company_name']
                                  as String;
                            }
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        _companyNameController.text =
                                            (providerData as Map<String,
                                                    dynamic>)['company_name']
                                                as String,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),

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
                            return "please enter job position";
                          }
                          return null;
                        },
                        controller: controller,
                        focusNode: focusNode,
                        onFieldSubmitted: (_) => onFieldSubmitted,
                        decoration: const InputDecoration(
                          labelText: 'Job Position',
                          hintText: 'Job Position',
                          border: OutlineInputBorder(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter description";
                      }
                      return null;
                    },
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Description',
                        border: OutlineInputBorder()),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter description";
                      }
                      return null;
                    },
                    controller: _salaryController,
                    decoration: const InputDecoration(
                        labelText: 'Salary',
                        hintText: 'Salary',
                        border: OutlineInputBorder()),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  //dropdown for location
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'Location',
                        hintText: 'Location',
                        border: OutlineInputBorder()),
                    value: selectedLocation,
                    onChanged: (String? value) {
                      selectedLocation = value;
                      _locationController.text = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select location';
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

                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        firebaseSerice!.addVacancy(
                          _companyNameController.text,
                          _jobPositionController.text,
                          _descriptionController.text,
                          _salaryController.text,
                          _locationController.text,
                          issuedDate,
                        );

                        _companyNameController.clear();
                        selectedJobPosition = '';
                        _jobPositionController.clear();
                        _descriptionController.clear();
                        _salaryController.clear();
                        _locationController.clear();
                        showAlert();
                      }
                    },
                    child: const Text('Add Vacancy'),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
