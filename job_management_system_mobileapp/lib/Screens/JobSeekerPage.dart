// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/Screens/Chattings.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/CVCreation.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/LogInPage.dart';
import 'package:job_management_system_mobileapp/Screens/job_matching.dart';
import 'package:job_management_system_mobileapp/classes/language.dart';
import 'package:job_management_system_mobileapp/localization/demo_localization.dart';
import 'package:job_management_system_mobileapp/main.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens./Help.dart';

class JobSeekerPage extends StatefulWidget {
  // ignore: use_super_parameters
  const JobSeekerPage({Key? key}) : super(key: key);

  @override
  State<JobSeekerPage> createState() => _JobSeekerPageState();
}

final FirebaseService firebaseService = FirebaseService();

class _JobSeekerPageState extends State<JobSeekerPage> {
  FirebaseService? _firebaseService;
  String? _userName;
  double? _deviceWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
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
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        // Add code here to handle the edit functionality
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/Default.png'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("$_userName",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 30)),
                        const Text("BICT(HONS)",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                          Text(
                            DemoLocalization.of(context)
                                .getTranslatedValue('featured_jobs')!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: _deviceWidth! * 0.04,
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JobMatchingScreen()),
                              );
                            },
                            child: Text(
                              DemoLocalization.of(context)
                                  .getTranslatedValue('see_all')!,
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 255, 145, 0),
                                  fontSize: _deviceWidth! * 0.03),
                            ),
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
                                return Center(
                                  child: CircularProgressIndicator(),
                                ); // Show loading indicator while fetching data
                              }

                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              return Container(
                                color: Color.fromARGB(255, 255, 255,255), // Background color for the list
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
                                                SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    Icon(Icons.work),
                                                    SizedBox(width: 8),
                                                    Flexible(
                                                      child: Text(
                                                        (vacancyData?[
                                                                'job_position']
                                                            as String),
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 6),
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            DemoLocalization.of(context)
                                .getTranslatedValue('recent_jobs')!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: _deviceWidth! * 0.04,
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              // Add your logic to navigate to see all recent jobs
                            },
                            child: Text(
                              DemoLocalization.of(context)
                                  .getTranslatedValue('see_all')!,
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 243, 117, 33),
                                  fontSize: _deviceWidth! * 0.03),
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
                                return Center(
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
                                                color: Color.fromARGB(255, 234, 232, 232), // Background color for data
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
                                                    SizedBox(height: 1),
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
                                                    SizedBox(height: 1),
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
              title: const Text('Find Jobs'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JobMatchingScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.create,
                  color:
                      Color.fromARGB(255, 255, 137, 2)), // Icon for creating CV
              title: const Text('Create CV'),
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
              title: const Text('Notifications'),
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
              title: const Text('Profile Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileJobSeeker()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help,
                  color: Color.fromARGB(255, 255, 137, 2)),
              title: const Text("Help"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Help()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout,
                  color: Color.fromARGB(255, 255, 137, 2)), // Icon for logout
              title: const Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LogInPage()),
                );
              },
            ),
          ],
        ),
      ),
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
                          builder: (context) => const Chattings()));
                },
              ),
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Add your logic for the floating action button here
      //   },
      //  child: const Icon(Icons.add,color: Color.fromARGB(255, 2, 71, 36)),
      // ),
    );
  }
}
