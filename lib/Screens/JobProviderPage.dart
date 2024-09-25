import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/ProfileJobProvider.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/SeekerList.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/Vacancies.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/chat_home.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/feedback_home.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/interview_scheduler.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/my_vacanices.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/updateVacancy.dart';
import 'package:job_management_system_mobileapp/classes/language.dart';
import 'package:job_management_system_mobileapp/colors/colors.dart';
import 'package:job_management_system_mobileapp/localization/demo_localization.dart';
import 'package:job_management_system_mobileapp/main.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobProviderPage extends StatefulWidget {
  JobProviderPage({super.key});

  final FirebaseService firebaseService = FirebaseService();

  @override
  State<JobProviderPage> createState() => _JobProviderPageState();
}

class _JobProviderPageState extends State<JobProviderPage> {
  FirebaseService? _firebaseService;
  String? uid;
  SharedPreferences? _sharedPreferences;
  String? logo, _userName, _comName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
    uid = _firebaseService!.getCurrentUserUid();
    _initSharedPreferences();
    updateExpiredVacancies();
    _getProvider();
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

  // update expired vacancies
  Future<void> updateExpiredVacancies() async {
    final now = DateTime.now();

    final QuerySnapshot snapshot =
        await _firebaseService!.vacancyCollection.get();

    for (final vacancy in snapshot.docs) {
      final expiryDate = (vacancy.data() as Map)['expiry_date'] as Timestamp;
      final bool isActive = (vacancy.data() as Map)['active'] as bool;

      if (expiryDate.toDate().isBefore(now) && isActive) {
        await _firebaseService?.vacancyCollection
            .doc(vacancy.id)
            .update({'active': false});
      }
    }
  }

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

  void _getProvider() async {
    await _firebaseService!.getCurrentProviderData().then((data) {
      if (mounted) {
        if (data != null) {
          setState(() {
            logo = data['logo'];
            _userName = data['repName'];
            _comName = data['company_name'];
          });
        }
      }
    });
  }
  // DemoLocalization.of(context)
  //                               .getTranslatedValue('my_vacancies')!,

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // You can adjust this factor according to your preference
    double fontSize = screenWidth * 0.04; // Example factor

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange.shade900, actions: <Widget>[
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
      ]),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange.shade900,
              Colors.orange.shade800,
              Colors.orange.shade400
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
              if (logo != null) ...{
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(logo!),
                        ),
                        const SizedBox(height: 10),
                        if (_comName != null) ...{
                          Text(
                            _comName!, // Assuming _userName holds the user's name
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        } else ...{
                          Text(
                            _userName!, // Assuming _userName holds the user's name
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        }, // Adding some space between the profile image and the username
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
              const SizedBox(height: 20),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            Localization.of(context)
                                .getTranslatedValue('my_vacancies')!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth! * 0.04,
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyVacanices(),
                                ),
                              );
                            },
                            child: const Text(
                              "See All",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 145, 0),
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 180,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('vacancy')
                              .where('uid', isEqualTo: _firebaseService!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Text('Loading...'),
                              ); // Show loading indicator while fetching data
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    bool isCompanyExist =
                                        await _firebaseService!
                                            .checkCompanyExist();

                                    if (isCompanyExist) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Vacancies()));
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Alert"),
                                            content: Text(
                                              Localization.of(context)
                                                  .getTranslatedValue(
                                                      'create_vacancy_warning')!,
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text("OK"),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                    // Navigate to find jobs page
                                  },
                                  child: Container(
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "+",
                                          style: TextStyle(fontSize: 100),
                                        ),
                                        Text("Create Vacancies"),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            List<DocumentSnapshot> vacancies =
                                snapshot.data!.docs;

                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                width: 10,
                              ),
                              itemCount: vacancies.length,
                              itemBuilder: (context, index) {
                                String vacancyID = vacancies[index].id;
                                String companyName =
                                    vacancies[index]['company_name'];
                                String jobPosition =
                                    vacancies[index]['job_position'];
                                String location = vacancies[index]['location'];

                                return Container(
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(10),
                                  width: 300,
                                  decoration: BoxDecoration(
                                    color: cardBackgroundColorLayer4
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.business),
                                          const SizedBox(width: 8),
                                          Text(
                                            companyName,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.work),
                                          const SizedBox(width: 8),
                                          Text(
                                            jobPosition,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on),
                                          const SizedBox(width: 8),
                                          Text(
                                            location,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      VacancyUpdaterUI(
                                                    vacancyId: vacancyID,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.edit,
                                                color: Colors.black),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _showDeleteConfirmationDialog(
                                                  context, vacancyID);
                                            },
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Scheduled Interviews",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "See All",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 145, 0),
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 150,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _firebaseService?.interviewCollection
                              .where('uid', isEqualTo: _firebaseService!.uid)
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
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    bool isCompanyExist =
                                        await _firebaseService!
                                            .checkCompanyExist();

                                    if (isCompanyExist) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  InterviewScheduler()));
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Alert"),
                                            content: Text(
                                              Localization.of(context)
                                                  .getTranslatedValue(
                                                      'create_vacancy_warning')!,
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text("OK"),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                    // Navigate to find jobs page
                                  },
                                  child: Container(
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "+",
                                          style: TextStyle(fontSize: 100),
                                        ),
                                        Text("Shedule Interviews"),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            return _bulidInterviewList(
                                context, snapshot.data!.docs);
                          },
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

      //drawer

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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/Default.jpg'),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Quick Access",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    'Job Provider',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.create,
                  color: Color.fromARGB(255, 255, 137, 2)),
              title: Text(
                Localization.of(context).getTranslatedValue('create_vacancy')!,
              ),
              onTap: () async {
                bool isCompanyExist =
                    await _firebaseService!.checkCompanyExist();

                if (isCompanyExist) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Vacancies()));
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Alert"),
                        content: Text(
                          Localization.of(context)
                              .getTranslatedValue('create_vacancy_warning')!,
                        ),
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
                // Navigate to find jobs page
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule,
                  color: Color.fromARGB(255, 255, 137, 2)),
              title: Text(
                Localization.of(context)
                    .getTranslatedValue('schedule_inverviews')!,
              ),
              onTap: () async {
                bool isCompanyExist =
                    await _firebaseService!.checkCompanyExist();

                if (isCompanyExist) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InterviewScheduler()));
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Alert"),
                        content: Text(
                          Localization.of(context)
                              .getTranslatedValue('create_vacancy_warning')!,
                        ),
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
                // Navigate to find jobs page
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_2,
                  color: Color.fromARGB(255, 255, 137, 2)),
              title: Text(
                Localization.of(context).getTranslatedValue('see_job_seekers')!,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JobSeekerList(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.timeline,
                  color: Color.fromARGB(255, 255, 137, 2)),
              title: Text(
                Localization.of(context)
                    .getTranslatedValue('interview_progress')!,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const FeedbackHome();
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings,
                  color: Color.fromARGB(255, 255, 137, 2)),
              title: Text(
                Localization.of(context)
                    .getTranslatedValue('edit_company_info')!,
              ),
              onTap: () {
                Navigator.pushNamed(context, 'editProviderProfile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.power_settings_new,
                  color: Color.fromARGB(255, 255, 137, 2)),
              title: Text(
                Localization.of(context).getTranslatedValue('log_out')!,
              ),
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange.shade800,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JobProviderPage()));
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JobProviderProfile()));
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JobProviderPage()));
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.chat,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatHome()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String vacancyID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Vacancy'),
          content: const Text('Do you want to delete this vacancy?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _firebaseService?.deleteVacancy(vacancyID);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Widget _bulidInterviewList(
      BuildContext context, List<DocumentSnapshot> interviews) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 10, right: 10),
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return _buildInterviewItem(context, interviews[index]);
        },
        itemCount: interviews.length);
  }

  Widget _buildInterviewItem(BuildContext context, DocumentSnapshot interview) {
    String topic = interview['topic'];
    String interviewDate = interview['date_time'];

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      width: 300,
      decoration: BoxDecoration(
        color: cardBackgroundColorLayer4.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _bulidInterviewDetailsRow(Icons.topic, topic, 15),
          const SizedBox(
            height: 4,
          ),
          _bulidInterviewDetailsRow(Icons.calendar_month, interviewDate, 15),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  _bulidInterviewDetailsRow(IconData icon, String text, double fonSize) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: fonSize, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
