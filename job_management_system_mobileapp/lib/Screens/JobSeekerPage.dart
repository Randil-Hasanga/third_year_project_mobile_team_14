// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens./Help.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/CVCreation.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/LogInPage.dart';
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

      body: Container(
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
                        SizedBox(
                            height:
                                10), // Adding some space between the profile image and the username
                        Text(
                          _userName ??
                              '', // Assuming _userName holds the user's name
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
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
                        child: Row(
                          children: <Widget>[
                            const Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Add your job filter logic here
                              },
                              icon: const Icon(
                                Icons.filter_list,
                                color: Color.fromARGB(255, 158, 158, 158),
                              ),
                            ),
                          ],
                        ),
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
                                    builder: (context) => JobMatchingScreen()),
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

                              return Container(
                                color: const Color.fromARGB(255, 255, 255,
                                    255), // Background color for the list
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
                                            dynamic>)['company_name'] as String;
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                8.0), // Added padding horizontally
                                        child: Container(
                                          width: 250,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
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
                                                    const Icon(Icons.business),
                                                    const SizedBox(width: 8),
                                                    Flexible(
                                                      child: Text(
                                                        companyName,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.work),
                                                    const SizedBox(width: 8),
                                                    Flexible(
                                                      child: Text(
                                                        (vacancyData?[
                                                                'job_position']
                                                            as String),
                                                        style: const TextStyle(
                                                            fontSize: 15),
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
                                                        Icons.location_on),
                                                    const SizedBox(width: 8),
                                                    Flexible(
                                                      child: Text(
                                                        (vacancyData?[
                                                                'location']
                                                            as String),
                                                        style: const TextStyle(
                                                            fontSize: 15),
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
                      const Divider(),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _richTextWidget.simpleText(
                              Localization.of(context)
                                  .getTranslatedValue('recent_jobs')!,
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
                              // Add your logic to navigate to see all recent jobs
                            },
                            child: Text(
                              Localization.of(context)
                                  .getTranslatedValue('see_all')!,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 243, 117, 33),
                                  fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                          width: MediaQuery.of(context)
                              .size
                              .width, // Set width to the full screen width
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

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  snapshot.data?.docs.length ?? 0,
                                  (index) {
                                    var vacancyData =
                                        snapshot.data?.docs[index].data();
                                    String companyName = '';

                                    if (vacancyData != null) {
                                      companyName = (vacancyData as Map<String,
                                          dynamic>)['company_name'] as String;
                                    }
                                    return Container(
                                      margin: const EdgeInsets.all(1),
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255,
                                                    234,
                                                    232,
                                                    232), // Background color for data
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.business),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          companyName = (vacancyData
                                                                  as Map<String,
                                                                      dynamic>)[
                                                              'company_name'] as String,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .blue),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 1),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.work),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          companyName =
                                                              (vacancyData)[
                                                                      'job_position']
                                                                  as String,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 1),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.location_on),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          companyName =
                                                              (vacancyData)[
                                                                      'location']
                                                                  as String,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('assets/profile_picture.jpg'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$_userName',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
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
