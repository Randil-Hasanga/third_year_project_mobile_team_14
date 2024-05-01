// ignore_for_file: equal_elements_in_set, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/colors/colors.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:job_management_system_mobileapp/widgets/buttons.dart';
import 'package:job_management_system_mobileapp/widgets/richTextWidgets.dart';

class JobMatchingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JobMatchingScreenState();
  }
}

class _JobMatchingScreenState extends State<JobMatchingScreen> {
  RichTextWidget? _richTextWidget;
  FirebaseService? _firebaseService;
  ButtonWidgets? _buttonWidgets;
  String _selectedItem = 'District';

  double? _deviceWidth, _deviceHeight, expected_salary;
  String? seekerID;
  String? seeker_Prefered_District,
      seekerProvice,
      seeker_education,
      seeker_expected_salary,
      seeker_gender;

  Map<String, dynamic>? _CV_details;
  List<Map<String, dynamic>>? vacancies;
  bool _isMessageVisible = false; // info messge
  bool _isLoading = false; // Track whether data is being loaded
  List<Map<String, dynamic>>? filteredVacanciesByDistrict,
      filteredVacanciesByProvince,
      filteredVacanciesByEducation,
      bestMatchingVacancies;

  @override
  void initState() {
    super.initState();
    _richTextWidget = GetIt.instance.get<RichTextWidget>();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _buttonWidgets = GetIt.instance.get<ButtonWidgets>();
    _initializeData();
  }

  void _initializeData() async {
    setState(() {
      _isLoading = true; // Set isLoading to true while data is being loaded
    });
    Map<String, dynamic>? cvDetails = await _getCV();
    if (cvDetails != null) {
      _CV_details = cvDetails;
      print(_CV_details);
      print(_CV_details!['uid']);

      if (mounted) {
        setState(() {
          seekerID = _CV_details!['uid'];
          seeker_Prefered_District = _CV_details!['prefferedDistrict'];
          seeker_education = _CV_details!['EduQalification'];
          seeker_expected_salary = _CV_details!['salary'];
          seeker_gender = _CV_details!['gender'];
          expected_salary = double.parse(seeker_expected_salary!);
          print(seeker_education);
        });
      }

      await _loadVacanciesInPrefferedIndustry(); // Wait for data to be loaded
    } else {
      print('CV details not found');
      setState(() {
        _isLoading = false; // Set isLoading to false if data loading fails
      });
    }
  }

  Future<Map<String, dynamic>?> _getCV() async {
    return await _firebaseService!.getCurrentSeekerCV();
  }

  Future<void> _loadVacanciesInPrefferedIndustry() async {
    try {
      if (_CV_details != null) {
        List<String>? preferedIndustries =
            (_CV_details!['prefered_industries'] as List<dynamic>)
                .cast<String>();

        if (preferedIndustries != null) {
          List<Map<String, dynamic>>? data = await _firebaseService!
              .getVacanciesInPrefferedIndustry(preferedIndustries);

          setState(() {
            vacancies = data;
            _isLoading = false;
            filteredVacanciesByDistrict = _filterByGender(
              _filterByDistrict(
                _filterByEducation(vacancies),
              ),
            );
            filteredVacanciesByProvince = _filterByGender(
              _filterByProvince(
                _filterByEducation(vacancies),
              ),
            );
            filteredVacanciesByEducation = _filterByGender(
              _filterByEducation(vacancies),
            );
            bestMatchingVacancies = _filterByGender(
              _filterBySalary(
                _filterByDistrict(
                  _filterByEducation(vacancies),
                ),
              ),
            );

            print("Best matching vacancies : $bestMatchingVacancies");
          });
          print(vacancies);
        } else {
          print('prefered_industries is null');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('_CV_details is null');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

//Filter by Gender
  List<Map<String, dynamic>>? _filterByGender(
      List<Map<String, dynamic>>? list) {
    if (list != null) {
      List<Map<String, dynamic>> filteredVacancies = list.where((vacancy) {
        return ((vacancy['gender'] == seeker_gender) ||
            (vacancy['gender'] == "Any"));
      }).toList();

      print("Filtered vacancies by Gender: $filteredVacancies");
      return filteredVacancies;
    } else {
      print("Cannot filter");
      return null;
    }
  }

//Filter by district

  List<Map<String, dynamic>>? _filterByDistrict(
      List<Map<String, dynamic>>? list) {
    if (list != null) {
      List<Map<String, dynamic>> filteredVacancies = list.where((vacancy) {
        return vacancy['location'] == seeker_Prefered_District;
      }).toList();

      print("Filtered vacancies by district: $filteredVacancies");
      return filteredVacancies;
    } else {
      print("Cannot filter");
      return null;
    }
  }

//Filter by Province

  List<Map<String, dynamic>>? _filterByProvince(
      List<Map<String, dynamic>>? list) {
    if (list != null) {
      String preferredProvince = _getProviceByDistrict();

      if (preferredProvince.isNotEmpty) {
        List<String> districtsInProvince =
            _getDistrictsByProvince(preferredProvince);

        List<Map<String, dynamic>> filteredVacancies = list.where((vacancy) {
          return districtsInProvince.contains(vacancy['location']);
        }).toList();

        print("Filtered vacancies by provice: $filteredVacancies");
        return filteredVacancies;
      } else {
        print("Cannot determine preferred province");
        return null;
      }
    } else {
      print("Cannot filter, vacancies are null");
      return null;
    }
  }

  String _getProviceByDistrict() {
    String district =
        seeker_Prefered_District ?? ''; // Ensure district is not null
    if (district == "Matara" ||
        district == "Galle" ||
        district == "Hambantota") {
      return "Southern";
    } else if (district == "Ampara" ||
        district == "Batticaloa" ||
        district == "Trincomalee") {
      return "Eastern";
    } else if (district == "Anuradhapura" || district == "Polonnaruwa") {
      return "North Central";
    } else if (district == "Badulla" || district == "Monaragala") {
      return "Uva";
    } else if (district == "Colombo" ||
        district == "Gampaha" ||
        district == "Kalutara") {
      return "Western";
    } else if (district == "Jaffna" ||
        district == "Kilinochchi" ||
        district == "Mannar" ||
        district == "Mullaitivu" ||
        district == "Vavuniya") {
      return "Northern";
    } else if (district == "Kandy" ||
        district == "Matale" ||
        district == "Nuwara Eliya") {
      return "Central";
    } else if (district == "Kegalle" || district == "Ratnapura") {
      return "Sabaragamuwa";
    } else if (district == "Kurunegala" || district == "Puttalam") {
      return "North Western";
    } else {
      return "Unknown";
    }
  }

  List<String> _getDistrictsByProvince(String province) {
    switch (province) {
      case "Southern":
        return ["Matara", "Galle", "Hambantota"];
      case "Eastern":
        return ["Ampara", "Batticaloa", "Trincomalee"];
      case "North Central":
        return ["Anuradhapura", "Polonnaruwa"];
      case "Uva":
        return ["Badulla", "Monaragala"];
      case "Western":
        return ["Colombo", "Gampaha", "Kalutara"];
      case "Northern":
        return ["Jaffna", "Kilinochchi", "Mannar", "Mullaitivu", "Vavuniya"];
      case "Central":
        return ["Kandy", "Matale", "Nuwara Eliya"];
      case "Sabaragamuwa":
        return ["Kegalle", "Ratnapura"];
      case "North Western":
        return ["Kurunegala", "Puttalam"];
      default:
        return [];
    }
  }

//Filter by Education

  List<Map<String, dynamic>>? _filterByEducation(
      List<Map<String, dynamic>>? list) {
    List<String> _educationList = _getQualificationsBelow(seeker_education);

    List<Map<String, dynamic>> filteredVacancies = list!.where((vacancy) {
      return _educationList.contains(vacancy['max_education']);
    }).toList();

    print("Filtered vacancies by education: $filteredVacancies");
    return filteredVacancies;
  }

  List<String> _getQualificationsBelow(String? educationLevel) {
    switch (educationLevel) {
      case 'Below O/L':
        return ['Below O/L'];
      case 'Passed O/L':
        return ['Below O/L', 'O/L'];
      case 'Passed A/L':
        return ['Below O/L', 'O/L', 'A/L'];
      case 'Undergraduate':
        return ['Below O/L', 'O/L', 'A/L', 'Undergraduate'];
      case 'Graduate':
        return ['Below O/L', 'O/L', 'A/L', 'Undergraduate', 'Graduate'];
      case 'Post Graduate Diploma':
        return [
          'Below O/L',
          'O/L',
          'A/L',
          'Undergraduate',
          'Graduate',
          'PostGraduate'
        ];
      default:
        return [];
    }
  }

  List<Map<String, dynamic>>? _filterBySalary(
      List<Map<String, dynamic>>? list) {
    if (list != null) {
      List<Map<String, dynamic>> filteredVacancies = list.where((vacancy) {
        return vacancy['minimum_salary'] >= expected_salary;
      }).toList();

      print("Filtered vacancies by salary: $filteredVacancies");
      return filteredVacancies;
    } else {
      print("Cannot filter");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: _richTextWidget!
            .simpleText("Featured Jobs", 23, Colors.black87, FontWeight.w700),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Info'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "All the results are shown according to your curriculum vitae (CV).\n\n",
                              ),
                              TextSpan(
                                text: "Best Matching Vacancies\n",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    "Best Matching Vacancies are filtered by your gender, age, preferred industries, preferred district, expected minimum salary, and your highest education.\n\n",
                              ),
                              TextSpan(
                                text: "Vacancies by Preferred Area\n",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    "Vacancies by Preferred Area are filtered by your district or province, gender, and highest education level.\n\n",
                              ),
                              TextSpan(
                                text: "Vacancies by Highest Education\n",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    "Vacancies by Highest Education are filtered by your gender, age, and highest education level.\nYou can see vacancies according to your education level, regardless of company location.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.info,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.04),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (seekerID != null && !(_isLoading)) ...{
                      SizedBox(
                        height: _deviceHeight! * 0.01,
                      ),
                      applyForVacanciesListWidget("Best Matching Vacancies",
                          bestMatchingVacancies, seekerID!, _deviceHeight),
                      SizedBox(
                        height: _deviceHeight! * 0.02,
                      ),
                      const Divider(
                        thickness: 3,
                      ),
                      _locationDropDown(),
                      if (_selectedItem == "District") ...{
                        applyForVacanciesListWidget(
                            null,
                            filteredVacanciesByDistrict,
                            seekerID!,
                            _deviceHeight),
                      } else if (_selectedItem == "Province") ...{
                        applyForVacanciesListWidget(
                            null,
                            filteredVacanciesByProvince,
                            seekerID!,
                            _deviceHeight),
                      },
                      SizedBox(
                        height: _deviceHeight! * 0.02,
                      ),
                      const Divider(
                        thickness: 3,
                      ),
                      applyForVacanciesListWidget(
                          "By Highest Education",
                          filteredVacanciesByEducation,
                          seekerID!,
                          _deviceHeight),
                    }
                  ],
                ),
              ),
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _locationDropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _richTextWidget!.simpleText(
            "By Prefered Area", 21, Colors.black87, FontWeight.w600),
        DropdownButton<String>(
          value: _selectedItem,
          onChanged: (String? newValue) {
            setState(() {
              _selectedItem = newValue!;
            });
          },
          underline: Container(),
          items: <String>['District', 'Province'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: _richTextWidget!
                  .simpleText(value, 16, Colors.black87, FontWeight.w600),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget applyForVacanciesListWidget(
    String? text,
    List<Map<String, dynamic>>? list,
    String seekerId,
    double? _deviceHeight,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: _deviceHeight! * 0.01,
        ),
        if (text != null) ...{
          _richTextWidget!
              .simpleText(text!, 21, Colors.black87, FontWeight.w600),
          SizedBox(
            height: _deviceHeight * 0.01,
          ),
        },
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: cardBackgroundColorLayer4,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                //blurRadius: 5,
                offset: Offset(0, 0),
              ),
            ],
          ),
          height: _deviceHeight * 0.31196,
          child: _buildList(list, _deviceHeight, seekerId),
        ),
      ],
    );
  }

  Widget _buildList(
    List<Map<String, dynamic>>? list,
    double _deviceHeight,
    String seekerId,
  ) {
    if (list == null || list.isEmpty) {
      return const Center(
        child: Text(
          'No matching vacancies found',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(_deviceHeight! * 0.015),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          Map<String, dynamic>? listItem = list[index];
          if (listItem != null) {
            return _buildItem(
              seekerId,
              listItem,
            );
          } else {
            return const SizedBox(); // Return an empty SizedBox if vacancy is null
          }
        },
      ),
    );
  }

  Widget _buildItem(
    String seeker_id,
    Map<String, dynamic> listItem,
  ) {
    bool isApplying = false;
    bool isApplied = false;

    List appliedByList = listItem['applied_by'];

    if (appliedByList != null && appliedByList.contains(seeker_id)) {
      isApplied = true;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Card(
        color: cardBackgroundColorLayer3,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _richTextWidget!.simpleTextWithIconLeft(
                      Icons.work,
                      listItem['job_position'],
                      25,
                      Colors.black,
                      FontWeight.w700),
                  _richTextWidget!.simpleTextWithIconLeft(
                      Icons.business,
                      listItem['company_name'],
                      15,
                      Colors.black,
                      FontWeight.w700),
                  _richTextWidget!.simpleTextWithIconLeft(Icons.construction,
                      listItem['industry'], 15, Colors.black, FontWeight.w700),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _richTextWidget!.simpleTextWithIconLeft(
                              Icons.location_pin,
                              listItem['location'],
                              15,
                              Colors.black,
                              FontWeight.w700),
                        ],
                      ),
                      _richTextWidget!.simpleTextWithIconLeft(
                          Icons.school,
                          listItem['max_education'],
                          15,
                          Colors.black,
                          FontWeight.w700),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _richTextWidget!.simpleTextWithIconLeft(
                              Icons.currency_exchange,
                              "Rs. ${listItem['minimum_salary']}",
                              20,
                              const Color.fromARGB(255, 146, 0, 0),
                              FontWeight.w700),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  if (isApplied) ...{
                    _buttonWidgets!.simpleElevatedButtonWidget(
                        onPressed: () async {
                          await _firebaseService!.removeSeekerFromVacancy(
                              listItem['vacancy_id'], seeker_id);

                          print("Removed from vacancy");
                          _loadVacanciesInPrefferedIndustry();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 120, 255, 124),
                        ),
                        buttonText: "Applied"),
                  } else ...{
                    _buttonWidgets!.simpleElevatedButtonWidget(
                        onPressed: () async {
                          await _firebaseService!.applyForVacancy(
                              listItem['vacancy_id'], seeker_id);

                          print("Applied for vacancy");
                          _loadVacanciesInPrefferedIndustry();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 185, 120),
                        ),
                        buttonText: "Apply"),
                  }
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
