import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_management_system_mobileapp/colors/colors.dart';
import 'package:job_management_system_mobileapp/localization/demo_localization.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:job_management_system_mobileapp/widgets/appbar_widget.dart';
import 'package:job_management_system_mobileapp/widgets/buttons.dart';
import 'package:job_management_system_mobileapp/widgets/richTextWidgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/quickalert.dart';

class JobProviderProfile extends StatefulWidget {
  JobProviderProfile({super.key});

  @override
  State<JobProviderProfile> createState() => _JobProviderProfileState();
}

class _JobProviderProfileState extends State<JobProviderProfile> {
  FirebaseService? _firebaseService;
  final RichTextWidget _richTextWidget = RichTextWidget();
  final ButtonWidgets _buttonWidgets = ButtonWidgets();
  final AppBarWidget _appBarWidget = AppBarWidget();
  double? _deviceWidth, _deviceHeight;

  final GlobalKey<FormState> _companyDetailsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _districtKey = GlobalKey<FormState>();
  ScrollController _industryScrollController = ScrollController();

  String? _companyName,
      _email,
      _districtFull,
      _faxNumber,
      _agentMobile,
      _companyAddress,
      _agentTelephone,
      _agentName,
      _agentPosition,
      _membershipNumber,
      _selectedDistrict,
      _selectedIndFull,
      _selectedOrgFull,
      _selectedOrgType,
      _selectedIndustry,
      _logo,
      _businessRegistrationPDFLink;

  XFile? selectedImage;
  File? _businessRegistrationPDF;

  TextEditingController _districtController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _memberNumberController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyAddressController =
      TextEditingController();
  final TextEditingController _agentNameController = TextEditingController();
  final TextEditingController _agentPositionController =
      TextEditingController();
  final TextEditingController _agentTelephoneController =
      TextEditingController();
  final TextEditingController _agentMobileController = TextEditingController();
  final TextEditingController _agentFaxController = TextEditingController();
  final TextEditingController _agentEmailController = TextEditingController();

  bool? isBeingUpdated = false;
  String? rejectionDescription, approvalId;

  Map<String, dynamic>? _jobProviderDetails;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _getProvider();
    getUpdatedData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _districtController.dispose();
    super.dispose();
  }

  void getUpdatedData() async {
    await _firebaseService!.getUpdatedUser();
    if (mounted) {
      setState(() {
        isBeingUpdated = _firebaseService!.currentUser!['isBeingUpdated'];
        approvalId = _firebaseService!.currentUser!['approval_id'];
      });
    }

    if (isBeingUpdated == true) {
      rejectionDescription =
          await _firebaseService!.getRejectionReason(approvalId!);
      setState(() {});
      print(rejectionDescription);
    }
  }

  void _getProvider() async {
    _jobProviderDetails = await _firebaseService!.getCurrentProviderData();

    print(_jobProviderDetails);
    print("is being updated : $isBeingUpdated");

    if (_jobProviderDetails != null) {
      setState(() {
        _districtController.text = _jobProviderDetails!['districtFull'] ?? '';
        _industryController.text = _jobProviderDetails!['industry'] ?? '';
        _memberNumberController.text =
            _jobProviderDetails!['membership_number'] ?? '';
        _companyNameController.text =
            _jobProviderDetails!['company_name'] ?? '';
        _companyAddressController.text =
            _jobProviderDetails!['company_address'] ?? '';
        _agentNameController.text = _jobProviderDetails!['repName'] ?? '';
        _agentPositionController.text = _jobProviderDetails!['repPost'] ?? '';
        _agentTelephoneController.text =
            _jobProviderDetails!['repTelephone'] ?? '';
        _agentMobileController.text = _jobProviderDetails!['repMobile'] ?? '';
        _agentFaxController.text = _jobProviderDetails!['repFax'] ?? '';
        _agentEmailController.text = _jobProviderDetails!['repEmail'] ?? '';
      });
    }

    _logo = _jobProviderDetails?['logo'];
    _companyName = _jobProviderDetails?['company_name'];
    _email = _jobProviderDetails?['repEmail'];
    _faxNumber = _jobProviderDetails?['repFax'];
    _agentMobile = _jobProviderDetails?['repMobile'];
    _companyAddress = _jobProviderDetails?['company_address'];
    _agentTelephone = _jobProviderDetails?['repTelephone'];
    _agentName = _jobProviderDetails?['repName'];
    _agentPosition = _jobProviderDetails?['repPost'];
    _membershipNumber = _jobProviderDetails?['membership_number'];
    _districtFull = _jobProviderDetails?['districtFull'];
    _selectedDistrict = _jobProviderDetails?['district'];
    _selectedOrgType = _jobProviderDetails?['org_type'];
    _selectedIndustry = _jobProviderDetails?['industry'];
    _businessRegistrationPDFLink = _jobProviderDetails?['businessRegDoc'];
  }

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
      appBar: _appBarWidget.simpleAppBarWidget(
          Localization.of(context).getTranslatedValue('edit_profile')!, 20),
      bottomNavigationBar: _appBarWidget.bottomAppBarProvider(context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.04),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              if (isBeingUpdated == true) ...{
                Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(164, 244, 67, 54),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Icon(Icons.warning),
                      _richTextWidget.simpleText(
                          "Your Application has been rejected",
                          15,
                          Colors.black,
                          FontWeight.w600),
                      SizedBox(
                        height: 5,
                      ),
                      _richTextWidget.simpleText(
                          "Reason", 20, Colors.black, FontWeight.w600),
                      if (rejectionDescription != null) ...{
                        _richTextWidget.simpleTextMax2("$rejectionDescription",
                            null, Colors.black, FontWeight.bold)
                      }
                    ],
                  ),
                )
              },
              Padding(
                padding: EdgeInsets.only(top: _deviceHeight! * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Localization.of(context).getTranslatedValue('logo')!,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Container(
                      height: 1,
                      width: _deviceWidth! * 0.6,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: _deviceHeight! * 0.02,
                  ),
                  _addCompanyLogo(),
                  SizedBox(
                    height: _deviceHeight! * 0.02,
                  ),
                  const Divider(),
                  SizedBox(
                    height: _deviceHeight! * 0.02,
                  ),
                  _companyDetailsForm(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _companyDetailsForm() {
    return Container(
      child: Form(
        key: _companyDetailsFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _memberNumberTextField(), // mona wage format ekakda thiyenne kiyala ahanna
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            _companyNameTextField(),
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            const Divider(),
            SizedBox(
              height: _deviceHeight! * 0.01,
            ),
            _filePicker(),
            SizedBox(
              height: _deviceHeight! * 0.01,
            ),
            const Divider(),
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            _companyAddressTextField(),
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            _districtTextField(),
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            if (_selectedIndustry != null) ...{
              _showSelectedIndustry(),
            },
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            _industryListView(),
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            if (_selectedOrgType != null) ...{
              _showSelectedORG(),
            },
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            _orgTypeWidget(),
            SizedBox(
              height: _deviceHeight! * 0.03,
            ),
            _agentNameTextField(),
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            _agentPositionTextField(),
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            _agentTelephoneNumberTextField(),
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            _agentMobileNumberTextField(),
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            _faxNumberTextField(),
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            _emailTextField(),
            SizedBox(
              height: _deviceHeight! * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _clearButton(),
                _submitButton(),
              ],
            ),
            SizedBox(
              height: _deviceHeight! * 0.01,
            ),
          ],
        ),
      ),
    );
  }

  Widget _addCompanyLogo() {
    if (_logo != null && selectedImage == null) {
      return GestureDetector(
        onTap: () {
          _pickAndResizeImage();
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(_logo!),
                  fit: BoxFit.cover,
                ),
              ),
              height: 100,
              width: 200,
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
              // width: _deviceWidth! * 0.3,
              // height: _deviceHeight! * 0.15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(selectedImage!.path),
                  width: 200,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: _deviceHeight! * 0.05,
              width: _deviceHeight! * 0.05,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromARGB(161, 204, 130, 33)),
              child: GestureDetector(
                onTap: () => _pickAndResizeImage(),
                child: const Icon(
                  Icons.add_a_photo,
                  size: 35,
                  color: Colors.black,
                ),
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
              // width: _deviceWidth! * 0.3,
              // height: _deviceHeight! * 0.15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(selectedImage!.path),
                  width: 200,
                  colorBlendMode: BlendMode.clear,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: _deviceHeight! * 0.05,
              width: _deviceHeight! * 0.05,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromARGB(161, 204, 130, 33)),
              child: GestureDetector(
                onTap: () => _pickAndResizeImage(),
                child: const Icon(
                  Icons.add_a_photo,
                  size: 35,
                  color: Colors.black,
                ),
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
              child: SvgPicture.asset(
                "assets/logo.svg",
                width: 250,
                height: 125,
              ),
            ),
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

  bool isEnglish(String text) {
    final RegExp englishRegex = RegExp(r'^[a-zA-Z ]+$');
    return englishRegex.hasMatch(text);
  }

  // bool isEnglishWithSymbolsAndNumbers(String text) {
  //   final RegExp englishRegex = RegExp(r'^[a-zA-Z ,.!?]+$');
  //   return englishRegex.hasMatch(text);
  // }

  bool isEnglishWithSymbolsAndNumbers(String text) {
    final RegExp englishRegex = RegExp(r'^[a-zA-Z0-9 ,.!?]+$');
    return englishRegex.hasMatch(text);
  }

  Widget _memberNumberTextField() {
    return TextFormField(
      controller: _memberNumberController,
      decoration: InputDecoration(
        label: Text(
          Localization.of(context).getTranslatedValue('membership_number')!,
        ),
        border: const OutlineInputBorder(),
      ),
      onSaved: (newValue) {
        setState(() {
          _membershipNumber = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Membership number cannot be empty";
        } else {
          return null;
        }
      },
    );
  }

  Widget _companyNameTextField() {
    return TextFormField(
      controller: _companyNameController,
      decoration: InputDecoration(
        label: Text(
          Localization.of(context).getTranslatedValue('company_name')!,
        ),
        border: const OutlineInputBorder(),
      ),
      onSaved: (newValue) {
        setState(() {
          _companyName = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Company name cannot be empty";
        } else if (!isEnglishWithSymbolsAndNumbers(value)) {
          return "Company name must be in English";
        } else {
          return null;
        }
      },
    );
  }

  Widget _companyAddressTextField() {
    return TextFormField(
      controller: _companyAddressController,
      minLines: 3,
      maxLines: 8,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        label: Text(
          Localization.of(context).getTranslatedValue('company_address')!,
        ),
        border: const OutlineInputBorder(),
      ),
      onSaved: (newValue) {
        setState(() {
          _companyAddress = newValue;
        });
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Address cannot be empty";
        } else if (!isEnglishWithSymbolsAndNumbers(value)) {
          return "Address must be in English";
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
          _districtController = controller;
          return TextField(
            maxLines: 2,
            minLines: 1,
            controller: controller,
            focusNode: focusNode,
            onEditingComplete: onEditingComplete,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(
                  Localization.of(context).getTranslatedValue('district')!),
            ),
          );
        },
        onSelected: (String item) {
          _districtFull = item;
          List<String> parts = item.split(" - ");
          String englishDistrict = parts[0]; // Extract English word
          setState(() {
            _selectedDistrict = englishDistrict;
          });
          print("$_selectedDistrict,$_selectedOrgType,$_selectedIndustry");
        },
      ),
    );
  }

  Widget _showSelectedORG() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _richTextWidget.simpleText(
                Localization.of(context)
                    .getTranslatedValue('selcted_org_type')!,
                15,
                Colors.black,
                FontWeight.w500),
            _richTextWidget.simpleText(
                _selectedOrgType!, 17, Colors.black, FontWeight.w700),
          ],
        ),
      ),
    );
  }

  Widget _orgTypeWidget() {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            color: buttonDefaultColorOrange,
            borderRadius: BorderRadius.circular(20)),
        child: ExpansionTile(
          title: Text(Localization.of(context).getTranslatedValue('org_type')!),
          children: [
            Container(
              //height: _deviceHeight! * 0.35,
              child: ListView.builder(
                  itemCount: orgtypes.length,
                  shrinkWrap: true,
                  //scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return _orgTypeListViewBuilder(orgtypes[index], index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orgTypeListViewBuilder(String ORG, int index) {
    bool isSelected = _selectedOrgFull == ORG;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth! * 0.02,
        vertical: _deviceWidth! * 0.01,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedOrgFull = ORG;
            RegExp englishRegex = RegExp(r'[a-zA-Z]+');
            String? englishWord = englishRegex.firstMatch(ORG)?.group(0);

            _selectedOrgType = englishWord;
          });

          print("$_selectedDistrict,$_selectedOrgType,$_selectedIndustry");
        },
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromARGB(255, 201, 255, 203)
                    : const Color.fromARGB(232, 255, 246, 243),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(_deviceWidth! * 0.02),
              child: Text(
                ORG,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showSelectedIndustry() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _richTextWidget.simpleText(
                Localization.of(context)
                    .getTranslatedValue('selected_industry')!,
                15,
                Colors.black,
                FontWeight.w500),
            _richTextWidget.simpleText(
                _selectedIndustry!, 17, Colors.black, FontWeight.w700),
          ],
        ),
      ),
    );
  }

  Widget _industryListView() {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: buttonDefaultColorOrange,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ExpansionTile(
          title: Text(Localization.of(context).getTranslatedValue('industry')!),
          children: [
            Container(
              height: _deviceHeight! * 0.35,
              child: ListView.builder(
                  itemCount: industries.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return _industryListViewBuilder(industries[index], index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _industryListViewBuilder(String industry, int index) {
    bool isSelected = _selectedIndFull == industry;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth! * 0.02,
        vertical: _deviceWidth! * 0.01,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndFull = industry;
            List<String> englishParts =
                industry.split(RegExp(r'[\u0D80-\u0DFF]+'));
            String englishPart =
                englishParts[0].replaceAll('\u2022', '').trim();

            _selectedIndustry = englishPart;
          });

          print("$_selectedDistrict,$_selectedOrgType,$_selectedIndustry");
        },
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromARGB(255, 201, 255, 203)
                    : const Color.fromARGB(232, 255, 246, 243),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(_deviceWidth! * 0.02),
              child: Text(
                industry,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _agentNameTextField() {
    return TextFormField(
      controller: _agentNameController,
      decoration: InputDecoration(
        label: Text(
          Localization.of(context).getTranslatedValue('agent_name')!,
        ),
        border: const OutlineInputBorder(),
      ),
      onSaved: (newValue) {
        setState(() {
          _agentName = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Agent name cannot be empty";
        } else if (!isEnglishWithSymbolsAndNumbers(value)) {
          return "Agent name must be in English";
        } else {
          return null;
        }
      },
    );
  }

  Widget _agentPositionTextField() {
    return TextFormField(
      controller: _agentPositionController,
      decoration: InputDecoration(
        label: Text(
          Localization.of(context).getTranslatedValue('agent_position')!,
        ),
        border: const OutlineInputBorder(),
      ),
      onSaved: (newValue) {
        setState(() {
          _agentPosition = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Agent Position cannot be empty";
        } else if (!isEnglishWithSymbolsAndNumbers(value)) {
          return "Agent Position must be in English";
        } else {
          return null;
        }
      },
    );
  }

  Widget _agentTelephoneNumberTextField() {
    return TextFormField(
      controller: _agentTelephoneController,
      decoration: InputDecoration(
        label: Text(
          Localization.of(context).getTranslatedValue('telephone_number')!,
        ),
        border: const OutlineInputBorder(),
      ),
      onSaved: (newValue) {
        setState(() {
          _agentTelephone = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Telephone number cannot be empty";
        } else if (value.length != 10) {
          return "Telephone number must be 10 digits";
        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
          return "Telephone number must contain only digits";
        } else {
          return null;
        }
      },
    );
  }

  Widget _agentMobileNumberTextField() {
    return TextFormField(
      controller: _agentMobileController,
      decoration: InputDecoration(
        label: Text(
          Localization.of(context).getTranslatedValue('mobile_number')!,
        ),
        border: const OutlineInputBorder(),
      ),
      onSaved: (newValue) {
        setState(() {
          _agentMobile = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Mobile number cannot be empty";
        } else if (value.length != 10) {
          return "Mobile number must be 10 digits";
        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
          return "Mobile number must contain only digits";
        } else {
          return null;
        }
      },
    );
  }

  Widget _faxNumberTextField() {
    return TextFormField(
      controller: _agentFaxController,
      decoration: InputDecoration(
        label: Text(
          Localization.of(context).getTranslatedValue('fax_number')!,
        ),
        border: const OutlineInputBorder(),
      ),
      onSaved: (newValue) {
        setState(() {
          _faxNumber = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Fax number cannot be empty";
        } else if (value.length != 10) {
          return "Fax number must be 10 digits";
        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
          return "Fax number must contain only digits";
        } else {
          return null;
        }
      },
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      controller: _agentEmailController,
      decoration: InputDecoration(
        label: Text(
          Localization.of(context).getTranslatedValue('email')!,
        ),
        border: const OutlineInputBorder(),
      ),
      onSaved: (newValue) {
        setState(() {
          _email = newValue;
        });
      },
      validator: (_value) {
        bool _result = _value!.contains(
          RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
        );
        return _result ? null : "Please enter a valid email";
      },
    );
  }

  Widget _clearButton() {
    return MaterialButton(
      elevation: 2,
      minWidth: _deviceWidth! * 0.4,
      color: const Color(0x608A8A8A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      onPressed: () {
        setState(() {
          _membershipNumber = '';
          _companyName = '';
          _companyAddress = '';
          _selectedDistrict = '';
          _selectedIndFull = '';
          _selectedOrgFull = '';
          _selectedOrgType = '';
          _selectedIndustry = '';
          _agentName = '';
          _agentPosition = '';
          _agentTelephone = '';
          _agentMobile = '';
          _faxNumber = '';
          _email = '';

          _districtController.clear();
          _industryController.clear();
          _memberNumberController.clear();
          _companyNameController.clear();
          _companyAddressController.clear();
          _agentNameController.clear();
          _agentPositionController.clear();
          _agentTelephoneController.clear();
          _agentMobileController.clear();
          _agentFaxController.clear();
          _agentEmailController.clear();
        });
      },
      child: Text(
        Localization.of(context).getTranslatedValue('clear')!,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _submitButton() {
    return MaterialButton(
      minWidth: _deviceWidth! * 0.4,
      color: buttonDefaultColorGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      onPressed: () {
        _validateAndSave();
      },
      child: Text(
        Localization.of(context).getTranslatedValue('save')!,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _filePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        _richTextWidget.simpleText(
            Localization.of(context)
                .getTranslatedValue('business_resistration')!,
            17,
            Colors.black,
            FontWeight.w700),
        _buttonWidgets.simpleElevatedButtonWidget(
            onPressed: () {
              _pickPDF(context);
            },
            buttonText: "Pick PDF",
            style: null)
      ],
    );
  }

  void _pickPDF(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.first.path;
        _businessRegistrationPDF = File(result.files.first.path!);
        if (filePath != null) {
          // Do something with the file path, like storing it in a variable
          print("Picked PDF file: $filePath");
        }
      } else {
        // User canceled the picker or no files were selected
        print("User canceled the picker or no files were selected");
      }
    } catch (e) {
      print("Error picking PDF file: $e");
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: appBarColor,
          ),
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green[100], // Customize the background color
          title: const Text(
            "Success",
            style: TextStyle(color: Colors.green), // Customize the text color
          ),
          content: Text(
            "Company detailed updated",
            style:
                TextStyle(color: Colors.green[900]), // Customize the text color
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _getProvider();
              },
              child: const Text(
                'OK',
                style:
                    TextStyle(color: Colors.green), // Customize the text color
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.red);
  }

  void _validateAndSave() async {
    if (_selectedDistrict == null || _selectedDistrict!.isEmpty) {
      _showErrorMessage(context, "District Field Empty or Invalid");
    } else if (!sriLankanDistricts
        .any((district) => district == _districtFull)) {
      _showErrorMessage(context, "Insert Valid District");
    } else {
      if (_businessRegistrationPDFLink != null ||
          _businessRegistrationPDF != null) {
        if (_companyDetailsFormKey.currentState!.validate()) {
          _companyDetailsFormKey.currentState!.save();
          _showLoadingDialog(context);

          await _firebaseService!.addJobProviderDetails(
            selectedImage,
            _logo,
            _membershipNumber!,
            _companyName!,
            _businessRegistrationPDF,
            _businessRegistrationPDFLink,
            _companyAddress!,
            _selectedDistrict!,
            _selectedIndustry!,
            _selectedOrgType!,
            _agentName!,
            _agentPosition!,
            _agentTelephone!,
            _agentMobile!,
            _faxNumber!,
            _email!,
            _districtFull!,
          );

          Navigator.of(context).pop(); // Dismiss the loading dialog
          _showSuccessDialog(context);

          // getUpdatedData();
          setState(() {
            isBeingUpdated = false;
          });
        }
      } else {
        Navigator.of(context).pop(); // Dismiss the loading dialog
        _showErrorMessage(
            context, "Please provide business registration document");
      }
    }
  }

  void _showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          style: const TextStyle(color: Colors.black),
          message,
          textAlign: TextAlign.center,
          selectionColor: const Color.fromARGB(255, 230, 255, 2),
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }

  static const List<String> orgtypes = [
    "Public - රාජ්‍ය - அரச",
    "Private - පෞද්ගලික - தனியார்",
    "NGO - රාජ්‍ය නොවන - அரசசாரா நிறுவனம்",
  ];

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

  static const List<String> industries = [
    "\u2022Agriculture, Animal Husbandry and Forestry\n\u2022කෘෂිකර්මය, සත්ව පාලනය සහ වන වගාව\n\u2022விவசாயம், விலங்கு பராமரிப்பு மற்றும் வனவியல்",
    "\u2022Fishing\u2022  \u2022ධීවර\u2022  \u2022மீனவர்\u2022",
    "\u2022Mining and Quarrying\n\u2022පතල් හා කැනීම්\n\u2022சுரங்கம் மற்றும் குவாரி",
    "\u2022Manufacturing\u2022  \u2022නිෂ්පාදන\u2022  \u2022உற்பத்தி\u2022",
    "\u2022Electricity Gas and Water Supply\n\u2022විදුලිබල ගෑස් හා ජලසම්පාදන\n\u2022மின்சார எரிவாயு மற்றும் நீர் வழங்கல்",
    "\u2022Construction\u2022  \u2022ඉදිකිරීම්\u2022  \u2022கட்டுமானம்\u2022",
    "\u2022Wholesale and Retail Trade\n\u2022තොග හා සිල්ලර වෙළඳාම්\n\u2022மொத்த மற்றும் சில்லறை வர்த்தகம்",
    "\u2022Hotel and Restaurant\n\u2022හෝටල් හා ආපනශාලා සේවා\n\u2022விடுதிகள் மற்றும் உணவகங்கள்",
    "\u2022Financial Services\n\u2022මූල්‍ය සේවා\n\u2022நிதிச் சேவைகள்",
    "\u2022Real Estate Services\n\u2022ඉඩකඩම් බදු දීම් ආශ්‍රිත සේවා\n\u2022ரியல் எஸ்டேட் சேவைகள்",
    "\u2022Computer Related Services\n\u2022පරිගණක ආශ්‍රිත සේවා\n\u2022கணினி தொடர்பான சேவைகள்",
    "\u2022Research and Development Services\n\u2022පර්යේෂණ හා සංවර්ධන සේවා\n\u2022ஆராய்ச்சி மற்றும் வளர்ச்சி சேவைகள்",
    "\u2022Public Administration and Defence\n\u2022රාජ්‍ය පරිපාලන හා ආරක්‍ෂක\n\u2022பொது நிர்வாகம் மற்றும் பாதுகாப்பு",
    "\u2022Health and Social Services\n\u2022සෞඛ්‍ය හා සමාජ සේවා\n\u2022சுகாதாரம் மற்றும் சமூக சேவைகள்",
    "\u2022Other Community, Social and Personal Services\n\u2022වෙනත් ප්‍රජා මූලික සමාජ හා පුද්ගලික සේවා\n\u2022வேறு சமுதாய சமூக மற்றும் தனிப்பட்ட சேவை",
    "\u2022Private Household with Employed Personals\n\u2022ගෘහස්ත සේවයේ නියුක්ත සේවා\n\u2022தொழில் புரிகின்ர நபர்களுடனான வீட்டுடமை",
    "\u2022Extra Territorial Organizations\n\u2022වෙනත් ප්‍රාදේශීය සංවිධාන\n\u2022பிற பிராந்திய அமைப்புகள்",
    "\u2022Transportation and Storage\n\u2022ප්‍රවාහනය හා ගබඩාකරණය\n\u2022போக்குவரத்து மற்றும் சேமிப்பிடம்",
  ];
}
