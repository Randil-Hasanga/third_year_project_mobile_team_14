import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/localization/demo_localization.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:job_management_system_mobileapp/widgets/appbar_widget.dart';
import 'package:job_management_system_mobileapp/widgets/buttons.dart';
import 'package:job_management_system_mobileapp/widgets/richTextWidgets.dart';

class AppliedJobs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppliedJobsState();
}

class AppliedJobsState extends State<AppliedJobs> {
  AppBarWidget appBarWidget = AppBarWidget();
  RichTextWidget richTextWidget = RichTextWidget();
  ButtonWidgets _buttonWidgets = ButtonWidgets();
  FirebaseService? _firebaseService;
  List<Map<String, dynamic>>? appliedJobs;

  @override
  void initState() {
    _firebaseService = GetIt.instance.get<FirebaseService>();
    getAppliedJobs();
  }

  void getAppliedJobs() async {
    appliedJobs = await _firebaseService!.getAppliedJobs();
    setState(() {});
    print("Applied jobs : $appliedJobs");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget.simpleAppBarWidget(
          Localization.of(context).getTranslatedValue('applied_jobs')!, 20),
      bottomNavigationBar: appBarWidget.bottomAppBarSeeker(context),
      body: ListView.builder(
        //controller: _scrollControllerLeft,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: appliedJobs?.length ?? 0,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return AppliedJobsListWidget(appliedJobs![index]);
        },
      ),
    );
  }

  Widget AppliedJobsListWidget(Map<String, dynamic> job) {
    String? uid = _firebaseService!.uid;
    return Container(
        margin: EdgeInsets.only(top: 10, left: 5, right: 5),
        decoration: BoxDecoration(
          border: Border.all(style: BorderStyle.solid, color: Colors.black),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      richTextWidget!.simpleTextWithIconLeft(
                          Icons.work,
                          job['job_position'],
                          20,
                          Colors.black,
                          FontWeight.w700,
                          Colors.black),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            richTextWidget!.simpleTextWithIconLeft(
                                Icons.business,
                                job['company_name'],
                                15,
                                Colors.black,
                                FontWeight.w700,
                                Colors.black),
                            richTextWidget!.simpleTextWithIconLeft(
                                Icons.location_pin,
                                job['location'],
                                15,
                                Colors.black,
                                FontWeight.w700,
                                Colors.black),
                            richTextWidget!.simpleTextWithIconLeft(
                                Icons.currency_exchange,
                                "Rs. ${job['minimum_salary']}0",
                                20,
                                const Color.fromARGB(255, 146, 0, 0),
                                FontWeight.w700,
                                Colors.black),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (job['logo'] != null && job['logo'] != '') ...{
                    Center(
                      child: Image.network(
                        job['logo']!, // Replace with your image URL
                        height: 50,
                        width: 80,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          );
                        },
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Text(
                              'Image not found'); // Placeholder for error case
                        },
                      ),
                    ),
                  },
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buttonWidgets!.simpleElevatedButtonWidgetWithIcon(
                      onPressed: () async {
                        await _firebaseService!.removeSeekerFromVacancy(
                            job['vacancy_id'], _firebaseService!.uid);

                        print("Removed from vacancy");
                        getAppliedJobs();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 120, 120),
                      ),
                      buttonText: "Remove",
                      icon: Icons.close),
                ],
              ),
            ],
          ),
        ));
  }
}
