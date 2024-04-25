import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:job_management_system_mobileapp/localization/demo_localization.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:quickalert/quickalert.dart';

class vacancies extends StatelessWidget {
  vacancies({super.key});

  final FirebaseService firebaseService = FirebaseService();

  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _jobPositionController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _salaryController = TextEditingController();
  final _locationController = TextEditingController();
  String? selectedLocation;

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
                  TextFormField(
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
                  ),
                  const SizedBox(height: 20),

                  //Dropdown for Job Position
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
                      _jobPositionController.text = value;
                      debugPrint('You selected $value');
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
                  /* TextFormField(
                    
                  ),*/
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
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
                  SizedBox(height: 20),

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

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FirebaseService().addVacancy(
                            _companyNameController.text,
                            _jobPositionController.text,
                            _descriptionController.text,
                            _salaryController.text,
                            _locationController.text);

                        _companyNameController.clear();
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
