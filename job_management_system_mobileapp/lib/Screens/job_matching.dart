import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/colors/colors.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:job_management_system_mobileapp/widgets/listViewWidgets.dart';
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
  ListViewWidgets? _listViewWidgets;
  double? _deviceWidth, _deviceHeight;

  Map<String, dynamic>? _CV_details;
  List<Map<String, dynamic>>? vacancies;

  @override
  void initState() {
    super.initState();
    _richTextWidget = GetIt.instance.get<RichTextWidget>();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _listViewWidgets = GetIt.instance.get<ListViewWidgets>();
    _initializeData();
  }

  void _initializeData() async {
    Map<String, dynamic>? cvDetails = await _getCV();
    if (cvDetails != null) {
      _CV_details = cvDetails;
      print(_CV_details);
      _loadVacanciesInPrefferedIndustry();
    } else {
      print('CV details not found');
    }
  }

  Future<Map<String, dynamic>?> _getCV() async {
    return await _firebaseService!.getCurrentSeekerCV();
  }

  void _loadVacanciesInPrefferedIndustry() async {
    try {
      if (_CV_details != null) {
        List<String>? preferedIndustries =
            (_CV_details!['prefered_industries'] as List<dynamic>)
                .cast<String>();

        if (preferedIndustries != null) {
          List<Map<String, dynamic>>? data = await _firebaseService!
              .getVacanciesInPrefferedIndustry(preferedIndustries);

          if (mounted) {
            setState(() {
              vacancies = data;
            });
          }
          print(vacancies);
        } else {
          print('prefered_industries is null');
        }
      } else {
        print('_CV_details is null');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: _richTextWidget!
            .simpleText("Futured Jobs", 25, Colors.black87, FontWeight.w700),
        backgroundColor: appBarColor,
        actions: [],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.04),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _listViewWidgets!.horizontalListViewWidget("By prefered industries", vacancies, _deviceHeight, _richTextWidget),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}
