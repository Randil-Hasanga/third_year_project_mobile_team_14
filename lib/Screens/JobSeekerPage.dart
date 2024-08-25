// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens./Help.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/CVCreation.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/CVUpload.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/applied_jobs.dart';
import 'package:job_management_system_mobileapp/Screens/change_password.dart';
import 'package:job_management_system_mobileapp/Screens/job_matching.dart';
import 'package:job_management_system_mobileapp/classes/language.dart';
import 'package:job_management_system_mobileapp/localization/demo_localization.dart';
import 'package:job_management_system_mobileapp/main.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:job_management_system_mobileapp/widgets/richTextWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'JobSeekerScreens/seeker_chat_home.dart';

class JobSeekerPage extends StatefulWidget {
  // ignore: use_super_parameters
  const JobSeekerPage({Key? key}) : super(key: key);

  @override
  State<JobSeekerPage> createState() => _JobSeekerPageState();
}

final FirebaseService firebaseService = FirebaseService();

class _JobSeekerPageState extends State<JobSeekerPage> {
  //Variables of JobSeeker Dashboard
  SharedPreferences? _sharedPreferences;
  FirebaseService? _firebaseService;
  String? _userName;
  double? _deviceWidth;
  String? profile_image;
  final RichTextWidget _richTextWidget = RichTextWidget();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    _initSharedPreferences();
    _getSeeker();
  }

  void _getSeeker() async {
    await _firebaseService!.getCurrentSeekerData().then((data) {
      if (mounted) {
        if (data != null) {
          setState(() {
            profile_image = data['profile_image'];
          });
        }
      }
    });
  }

  Future<void> _initSharedPreferences() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
    } catch (e) {
      print("Error initializing SharedPreferences: $e");
    }
  }

  Future<void> clearCredentials() async {
    try {
      await _sharedPreferences!.remove('email');
      await _sharedPreferences!.remove('password');
    } catch (e) {
      print("Error clearing credentials: $e");
      // Handle the error, if needed
    }
  }

//language navigation
  void _changeLanguage(Language? language) {
    print(language!.name);

    Locale _temp;

    switch (language.languageCode) {
      case 'en':
        {
          _temp = Locale(language.languageCode, 'US');
          break;
        }
      case 'si':
        {
          _temp = Locale(language.languageCode, 'LK');
          break;
        }
      case 'ta':
        {
          _temp = Locale(language.languageCode, 'LK');
          break;
        }
      default:
        {
          _temp = Locale(language.languageCode, 'US');
          break;
        }
    }
    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    _userName = _firebaseService!.currentUser!['username'];
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      //Top App Bar
      resizeToAvoidBottomInset:
          false, // Prevent keyboard from resizing the body
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton(
              icon: const Icon(
                Icons.language,
                color: Colors.black,
              ),
              underline: const SizedBox(),
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                      value: lang,
                      child: Row(
                        children: <Widget>[Text(lang.name)],
                      )))
                  .toList(),
              onChanged: (Language? language) {
                _changeLanguage(language);
              },
            ),
          ),
        ],
      ),

//Dashboard screen

      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.orange.shade900,
                Colors.orange.shade800,
                Colors.orange.shade400,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 2,
                ),
                if (profile_image != null) ...{
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(profile_image!),
                          ),
                          const SizedBox(
                              height:
                                  10), // Adding some space between the profile image and the username
                          Text(
                            _userName ??
                                '', // Assuming _userName holds the user's name
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                } else ...{
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpmMLA8odEi8CaMK39yvrOg-EGJP6127PmCjqURn_ssg&s'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                },
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(168, 166, 165, 0.298),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors
                                    .grey.shade200, // Gray background color
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(
                                      60), // Adjust as per your design
                                  topRight: Radius.circular(
                                      60), // Adjust as per your design
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: _deviceWidth! * 0.05,
                                  vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    'Services',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Service items (replace with your icons and titles)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      serviceItem(Icons.work, 'Jobs', () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  JobMatchingScreen()),
                                        );
                                      }),
                                      serviceItem(Icons.create, 'Create CV',
                                          () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CVCreation()),
                                        );
                                      }),
                                      serviceItem(
                                          Icons.upload_file, 'Upload CV', () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CVUpload(
                                                    userId: '',
                                                  )),
                                        );
                                      }),
                                      serviceItem(Icons.help, 'Help', () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Help()),
                                        );
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Divider(
                              height: 5,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _richTextWidget.simpleText(
                                Localization.of(context)
                                    .getTranslatedValue('featured_jobs')!,
                                16,
                                Colors.black,
                                FontWeight.bold),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          JobMatchingScreen()),
                                );
                              },
                              child: _richTextWidget.simpleText(
                                  Localization.of(context)
                                      .getTranslatedValue('see_all')!,
                                  15,
                                  const Color.fromARGB(255, 243, 117, 33),
                                  null),
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            height: 130, // Adjust the height as needed
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('vacancy')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  ); // Show loading indicator while fetching data
                                }

                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                if (snapshot.data?.docs.isEmpty ?? true) {
                                  return Center(
                                    child: Text(
                                      'No matching vacancies',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }

                                return Container(
                                  color: Colors
                                      .white, // Background color for the list
                                  child: Row(
                                    children: List.generate(
                                      snapshot.data?.docs.length ?? 0,
                                      (index) {
                                        var vacancyData =
                                            snapshot.data?.docs[index].data();
                                        String companyName = '';

                                        if (vacancyData != null) {
                                          companyName = (vacancyData as Map<
                                                  String,
                                                  dynamic>)['company_name']
                                              as String;
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  8.0), // Added padding horizontally
                                          child: Container(
                                            width: 250,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  119,
                                                  236,
                                                  144,
                                                  108), // Card background color
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  15.0), // Adjusted padding
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.business,
                                                          color: Color.fromARGB(
                                                              255,
                                                              0,
                                                              0,
                                                              0)), // Icon color
                                                      const SizedBox(width: 8),
                                                      Flexible(
                                                        child: Text(
                                                          companyName,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            color: Color.fromARGB(
                                                                255,
                                                                0,
                                                                0,
                                                                0), // Text color
                                                            fontWeight: FontWeight
                                                                .bold, // Optional: Font weight
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.work,
                                                          color: Color.fromARGB(
                                                              255,
                                                              0,
                                                              0,
                                                              0)), // Icon color
                                                      const SizedBox(width: 8),
                                                      Flexible(
                                                        child: Text(
                                                          (vacancyData?[
                                                                  'job_position']
                                                              as String),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            color: Color.fromARGB(
                                                                221,
                                                                0,
                                                                0,
                                                                0), // Text color
                                                            fontWeight: FontWeight
                                                                .bold, // Make the text bold
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.location_on,
                                                          color: Color.fromARGB(
                                                              255,
                                                              0,
                                                              0,
                                                              0)), // Icon color
                                                      const SizedBox(width: 8),
                                                      Flexible(
                                                        child: Text(
                                                          (vacancyData?[
                                                                  'location']
                                                              as String),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            color: Color.fromARGB(
                                                                255,
                                                                0,
                                                                0,
                                                                0), // Text color
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      //Drawer of function list
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.orange.shade900,
                    Colors.orange.shade800,
                    Colors.orange.shade400,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Text(
                    'Hii, $_userName ...', // Replace $_userName with the actual username variable
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Services of Job Management System', // Replace with your desired text
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.search,
                  color: Color.fromARGB(
                      255, 255, 137, 2)), // Icon for finding jobs
              title: _richTextWidget.simpleText(
                  Localization.of(context).getTranslatedValue('featured_jobs')!,
                  16,
                  Colors.black,
                  FontWeight.bold),
              onTap: () async {
                bool isCvExist = await _firebaseService!.checkCVExist();
                if (isCvExist) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JobMatchingScreen()),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Alert"),
                        content: const Text("Please create CV and try again."),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.create,
                  color:
                      Color.fromARGB(255, 255, 137, 2)), // Icon for creating CV
              title: _richTextWidget.simpleText(
                  Localization.of(context).getTranslatedValue('create_CV')!,
                  16,
                  Colors.black,
                  FontWeight.bold),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CVCreation()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.work,
                  color:
                      Color.fromARGB(255, 255, 137, 2)), // Icon for creating CV
              title: _richTextWidget.simpleText(
                  Localization.of(context).getTranslatedValue('applied_jobs')!,
                  16,
                  Colors.black,
                  FontWeight.bold),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppliedJobs()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.upload_file,
                color: Color.fromARGB(255, 255, 137, 2),
              ), // Icon for uploading CV
              title: Text(
                Localization.of(context).getTranslatedValue('upload_CV') ??
                    'Upload CV',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CVUpload(
                            userId: '',
                          )),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications,
                  color:
                      Color.fromARGB(255, 255, 137, 2)), // Icon for creating CV
              title: _richTextWidget.simpleText(
                  Localization.of(context).getTranslatedValue('notifications')!,
                  16,
                  Colors.black,
                  FontWeight.bold),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationsJobSeeker()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings,
                  color:
                      Color.fromARGB(255, 255, 137, 2)), // Icon for creating CV
              title: _richTextWidget.simpleText(
                  Localization.of(context)
                      .getTranslatedValue('profile_settings')!,
                  16,
                  Colors.black,
                  FontWeight.bold),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileJobSeeker()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.security,
                  color:
                      Color.fromARGB(255, 255, 137, 2)), // Icon for creating CV
              title: _richTextWidget.simpleText(
                  Localization.of(context)
                      .getTranslatedValue('change_password')!,
                  16,
                  Colors.black,
                  FontWeight.bold),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePassword()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help,
                  color: Color.fromARGB(255, 255, 137, 2)),
              title: _richTextWidget.simpleText(
                  Localization.of(context).getTranslatedValue('help')!,
                  16,
                  Colors.black,
                  FontWeight.bold),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Help()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout,
                  color: Color.fromARGB(255, 255, 137, 2)), // Icon for logout
              title: _richTextWidget.simpleText(
                  Localization.of(context).getTranslatedValue('log_out')!,
                  16,
                  Colors.black,
                  FontWeight.bold),
              onTap: () async {
                await clearCredentials();
                await _firebaseService!.logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, "login", (route) => false);
              },
            ),
          ],
        ),
      ),

      //BottomNavigationBar

      bottomNavigationBar: BottomAppBar(
        color: Colors.orange.shade800,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const JobSeekerPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings,
                    color: Color.fromARGB(
                        255, 255, 255, 255)), // Change the color here
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const NotificationsJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeekerChatHome(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Services of Job Seeker
Widget serviceItem(IconData icon, String title, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: <Widget>[
        Icon(icon, size: 50, color: Colors.orange.shade900),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}