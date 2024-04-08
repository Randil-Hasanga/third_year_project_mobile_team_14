import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';
import 'package:job_management_system_mobileapp/localization/demo_localization.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/quickalert.dart';

class JobProviderProfile extends StatefulWidget {
  JobProviderProfile({super.key});

  @override
  State<JobProviderProfile> createState() => _JobProviderProfileState();
}

class _JobProviderProfileState extends State<JobProviderProfile> {
  final FirebaseService firebaseService = FirebaseService();
  double? _deviceWidth, _deviceHeight;
  final GlobalKey<FormState> _companyDetailsFormKey = GlobalKey<FormState>();

  String? _companyName, _selectedDistrict, _selectedCountry, _selectedIndustry;
  XFile? selectedImage;
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          DemoLocalization.of(context).getTranslatedValue('edit_profile')!,
          style: TextStyle(
              color: Colors.black,
              fontSize: _deviceWidth! * 0.04,
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
                          builder: (context) => JobProviderPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileJobSeeker()));
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.04),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: _deviceHeight! * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _addCompanyLogo(),
                ],
              ),
              SizedBox(
                height: _deviceHeight! * 0.02,
              ),
              _companyDetailsForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addCompanyLogo() {
    if (selectedImage != null) {
      return GestureDetector(
        onTap: () {
          _pickAndResizeImage();
        },
        child: Container(
          // width: _deviceWidth! * 0.3,
          // height: _deviceHeight! * 0.15,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(selectedImage!.path),
              width: 250,
              height: 125,
              fit: BoxFit.cover,
            ),
          ),
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage(
                    "https://avatar.iran.liara.run/public/40",
                  ),
                ),
              ),
            ),
            Icon(Icons.add_a_photo),
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
      minWidth: 800,
      minHeight: 600,
      quality: 90,
    )) as List<int>;

    String fileName = imageFile.name;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String compressedImgPath = '$appDocPath/$fileName.jpg';
    await File(compressedImgPath).writeAsBytes(imageBytes);

    return XFile(compressedImgPath);
  }

  Widget _companyDetailsForm() {
    return Container(
      child: Form(
        key: _companyDetailsFormKey,
        child: Column(
          children: [
            _districtTextField(),
           // _industryTextField(),
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            _companyNameTextField(),
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            _companyAddressTextField(),
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  bool isEnglish(String text) {
    final RegExp englishRegex = RegExp(r'^[a-zA-Z]+$');
    return englishRegex.hasMatch(text);
  }

  Widget _companyNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(
          DemoLocalization.of(context).getTranslatedValue('company_name')!,
        ),
        border: OutlineInputBorder(),
      ),
      onSaved: (newValue) {
        setState(() {
          _companyName = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Company name cannot be empty";
        } else if (!isEnglish(value)) {
          return "Company name must be in English";
        } else {
          return null;
        }
      },
    );
  }

  Widget _companyAddressTextField() {
    return TextFormField(
      minLines: 3,
      maxLines: 8,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        label: Text(
          DemoLocalization.of(context).getTranslatedValue('company_address')!,
        ),
        border: OutlineInputBorder(),
      ),
      onSaved: (newValue) {
        setState(() {
          _companyName = newValue;
        });
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Company name cannot be empty";
        } else {
          return null;
        }
      },
    );
  }

  Widget _districtTextField() {
    return SingleChildScrollView(
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<String>.empty();
          } else {
            return sriLankanDistricts.where((element) {
              return element
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          }
        },
        fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
          _districtController:
          controller;
          return TextField(
            maxLines: 2,
            minLines: 1,
            controller: controller,
            focusNode: focusNode,
            onEditingComplete: onEditingComplete,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text("District"),
            ),
          );
        },
        onSelected: (String item) {
          if (!sriLankanDistricts.any(
              (district) => district.toLowerCase() == item.toLowerCase())) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Insert Valid District",
                  textAlign: TextAlign.center,
                  selectionColor: Color.fromARGB(255, 230, 255, 2),
                ),
              ),
            );
          }
          List<String> parts = item.split(" - ");
          String englishDistrict = parts[0]; // Extract English word
          setState(() {
            _selectedDistrict = englishDistrict;
          });
          print(_selectedDistrict);
        },
      ),
    );
  }

  // Widget _industryTextField() {
  //   return SingleChildScrollView(
  //     child: Autocomplete<String>(
  //       optionsBuilder: (TextEditingValue textEditingValue) {
  //         if (textEditingValue.text == '') {
  //           return const Iterable<String>.empty();
  //         } else {
  //           return industries.where((element) {
  //             return element
  //                 .toLowerCase()
  //                 .contains(textEditingValue.text.toLowerCase());
  //           });
  //         }
  //       },
  //       fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
  //         _industryController: controller;
  //         controller;
  //         return TextField(
  //           maxLines: 6,
  //           minLines: 3,
  //           controller: controller,
  //           focusNode: focusNode,
  //           onEditingComplete: onEditingComplete,
  //           decoration: InputDecoration(
  //             alignLabelWithHint: true,
  //             border: OutlineInputBorder(),
  //             label: Text("Industry"),
  //           ),
  //         );
  //       },
  //       onSelected: (String item) {
  //         // if (!industries.any(
  //         //     (district) => district.toLowerCase() == item.toLowerCase())) {
  //         //   ScaffoldMessenger.of(context).showSnackBar(
  //         //     const SnackBar(
  //         //       content: Text(
  //         //         "Insert Valid District",
  //         //         textAlign: TextAlign.center,
  //         //         selectionColor: Color.fromARGB(255, 230, 255, 2),
  //         //       ),
  //         //     ),
  //         //   );
  //         // }
  //         List<String> parts = item.split("-");
  //         String englishIndustry = parts[1]; // Extract English word
  //         setState(() {
  //           _selectedIndustry = englishIndustry;
  //         });
  //         _industryController.text = _selectedIndustry!;
  //         _industryController.selection = TextSelection.fromPosition(TextPosition(offset: _industryController.text.length));
  //         print(_selectedIndustry);
  //       },
  //     ),
  //   );
  // }

  static const List<String> sriLankanDistricts = [
    'Ampara - අම්පාර - அம்பாறை',
    'Anuradhapura - අනුරාධපුර - அனுராதபுர',
    'Badulla - බදුල්ල - பதுளை',
    'Batticaloa - මඩකලපුව - மட்டக்களப்பு',
    'Colombo - කොළඹ - கொழும்பு',
    'Galle - ගාල්ල - காலி',
    'Gampaha - ගම්පහ - கம்பஹா',
    'Hambantota - හම්බන්තොට - அம்பான்தோட்டை',
    'Jaffna - යාපනය - யாழ்ப்பாணம்',
    'Kalutara - කළුතර - களுத்துறை',
    'Kandy - මහනුවර - கண்டி',
    'Kegalle - කෑගල්ල - கேகாலை',
    'Kilinochchi - කිලිනොච්චි - கிளிநொச்சி',
    'Kurunegala - කුරුණෑගල - குருநாகல்',
    'Mannar - මන්නාරම - மன்னார்',
    'Matale - මාතලේ - மாத்தளை',
    'Matara - මාතර - மாத்தறை',
    'Monaragala - මොනරාගල - மொண்ணாரகல்',
    'Mullaitivu - මුලතිව් - முல்லைத்தீவு',
    'Nuwara Eliya - නුවර එළිය - நுவரேலியா',
    'Polonnaruwa - පොළොන්නරුව - பொலன்னறுவை',
    'Puttalam - පුත්තලම - புத்தளம்',
    'Ratnapura - රත්නපුර - இரத்தினபுரை',
    'Trincomalee - ත්‍රිකුණාමලය - திருகோணமலை',
    'Vavuniya - වවුනියා - வவுனியா',
  ];

  // static const List<String> industries = [
  //   "1. -Agriculture, Animal Husbandry and Forestry\n   -කෘෂිකර්මය, සත්ව පාලනය සහ වන වගාව\n   -விவசாயம், விலங்கு பராமரிப்பு மற்றும்\n     வனவியல்",
  // ];
}
