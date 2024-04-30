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

  double? _deviceWidth, _deviceHeight;
  String? seekerID;
  String? seeker_Prefered_District, seekerProvice, seeker_education;

  Map<String, dynamic>? _CV_details;
  List<Map<String, dynamic>>? vacancies;
  bool _isLoading = false; // Track whether data is being loaded
  List<Map<String, dynamic>>? filteredVacanciesByDistrict,
      filteredVacanciesByProvince,
      filteredVacanciesByEducation;

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
            filteredVacanciesByDistrict = _filterByDistrict();
            filteredVacanciesByProvince = _filterByProvince();
            filteredVacanciesByEducation = _filterByEducation();
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

//Filter by district

  List<Map<String, dynamic>>? _filterByDistrict() {
    if (vacancies != null) {
      List<Map<String, dynamic>> filteredVacancies =
          vacancies!.where((vacancy) {
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

  List<Map<String, dynamic>>? _filterByProvince() {
    if (vacancies != null) {
      String preferredProvince = _getProviceByDistrict();

      if (preferredProvince.isNotEmpty) {
        List<String> districtsInProvince =
            _getDistrictsByProvince(preferredProvince);

        List<Map<String, dynamic>> filteredVacancies =
            vacancies!.where((vacancy) {
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

  List<Map<String, dynamic>>? _filterByEducation() {
    List<String> _educationList = _getQualificationsBelow(seeker_education);

    List<Map<String, dynamic>> filteredVacancies = vacancies!.where((vacancy) {
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

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: _richTextWidget!
            .simpleText("Featured Jobs", 25, Colors.black87, FontWeight.w700),
        backgroundColor: appBarColor,
        actions: [],
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
                    if (seekerID != null && !(_isLoading))
                      applyForVacanciesListWidget("By preferred industries",
                          vacancies, seekerID!, _deviceHeight),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget applyForVacanciesListWidget(
    String text,
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
        _richTextWidget!.simpleText(text, 21, Colors.black87, FontWeight.w600),
        SizedBox(
          height: _deviceHeight * 0.01,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: cardBackgroundColorLayer4,
          ),
          height: _deviceHeight * 0.285,
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
    return Padding(
      padding: EdgeInsets.all(_deviceHeight! * 0.015),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list?.length ?? 0,
        itemBuilder: (context, index) {
          Map<String, dynamic>? listItem = list?[index];
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

    return Card(
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _richTextWidget!.simpleTextWithIconLeft(
                            Icons.currency_exchange,
                            "Rs. ${listItem['minimum_salary']}",
                            20,
                            Color.fromARGB(255, 146, 0, 0),
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
                        await _firebaseService!
                            .applyForVacancy(listItem['vacancy_id'], seeker_id);

                        print("Applied for vacancy");
                        _loadVacanciesInPrefferedIndustry();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 120, 174, 255),
                      ),
                      buttonText: "Apply"),
                }
              ],
            ),
          ],
        ),
      ),
    );
  }
}
