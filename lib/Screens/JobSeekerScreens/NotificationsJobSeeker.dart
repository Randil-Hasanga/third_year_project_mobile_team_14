import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/seeker_chat_home.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class NotificationsJobSeeker extends StatefulWidget {
  const NotificationsJobSeeker({Key? key}) : super(key: key);

  @override
  _NotificationsJobSeekerState createState() => _NotificationsJobSeekerState();
}

class _NotificationsJobSeekerState extends State<NotificationsJobSeeker> {
  double? _deviceWidth, _deviceHeight;
  List<Map<String, dynamic>>? _interviewDetails;
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchVacancyAndInterviewDetails();
  }

  Future<void> _fetchVacancyAndInterviewDetails() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    print("Fetching interview progress for userId: $userId");

    // Check if the user has applied for any vacancy
    List<Map<String, dynamic>>? interviewDetails = await _fetchAppliedVacancies(userId);

    if (interviewDetails != null && interviewDetails.isNotEmpty && mounted) {
      setState(() {
        _interviewDetails = interviewDetails;
        _notificationCount = interviewDetails.length;
      });
    } else {
      setState(() {
        _interviewDetails = [];
        _notificationCount = 0;
      });
    }
  }

  Future<List<Map<String, dynamic>>?> _fetchAppliedVacancies(String userId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Fetch vacancies where the user has applied
      QuerySnapshot<Map<String, dynamic>> vacancySnapshot = await firestore
          .collection('vacancy')
          .where('applied_by', arrayContains: userId)
          .get();

      if (vacancySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> interviewDetailsList = [];

        for (var vacancyDoc in vacancySnapshot.docs) {
          Map<String, dynamic> vacancyData = vacancyDoc.data();
          String vacancyId = vacancyData['vacancy_id'];

          // Fetch the interview details for this vacancy
          QuerySnapshot<Map<String, dynamic>> interviewSnapshot = await firestore
              .collection('interview_details')
              .where('vacancy_id', isEqualTo: vacancyId)
              .where('uid', isEqualTo: vacancyData['uid'])
              .get();

          if (interviewSnapshot.docs.isNotEmpty) {
            for (var interviewDoc in interviewSnapshot.docs) {
              Map<String, dynamic> interviewData = interviewDoc.data();
              interviewDetailsList.add({
                'companyName': interviewData['company_name'],
                'jobPosition': vacancyData['job_position'],
                'dateTime': interviewData['date_time'],
                'description': interviewData['description'],
                'link': interviewData['link'],
                'topic': interviewData['topic'],
                'type': interviewData['type'],
                'submitted_date': vacancyData['applied_at']
              });
            }
          }
        }

        return interviewDetailsList;
      } else {
        print("No vacancies found for userId: $userId");
        return null;
      }
    } catch (e) {
      print("Error fetching applied vacancies: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color.fromARGB(255, 248, 248, 248),
          ),
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
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const JobSeekerPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileJobSeeker()));
                },
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationsJobSeeker()));
                    },
                  ),
                  if (_notificationCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Center(
                          child: Text(
                            '$_notificationCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.chat, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SeekerChatHome()));
                },
              ),
            ],
          ),
        ),
      ),
      body: _interviewDetails == null
          ? const Center(child: CircularProgressIndicator())
          : _interviewDetails!.isEmpty
              ? const Center(
                  child: Text("No interview notifications available."))
              : ListView.builder(
                  itemCount: _interviewDetails!.length,
                  itemBuilder: (context, index) {
                    var interview = _interviewDetails![index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: ListTile(
                          leading: Icon(
                            Icons.notifications,
                            color: Colors.orange.shade700,
                          ),
                          title: Text(
                            interview['companyName'] ?? 'Unknown Company',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                              'Position: ${interview['jobPosition'] ?? 'Unknown Position'}'),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.info_outline,
                              color: Colors.orange,
                            ),
                            onPressed: () {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.info,
                                title: 'Interview Details',
                                text:
                                    '📅 Company: ${interview['companyName']}\n'
                                    '🕒 Date & Time: ${interview['dateTime']}\n'
                                    '📋 Topic: ${interview['topic']}\n'
                                    '📝 Description: ${interview['description']}\n'
                                    '🔗 Link: ${interview['link']}\n'
                                    '📍 Type: ${interview['type']}\n'
                                    '📅 Submitted Date: ${interview['submitted_date'] is Timestamp ? DateFormat.yMMMd().add_jm().format((interview['submitted_date'] as Timestamp).toDate()) : 'Not found'}',
                                confirmBtnText: 'OK',
                                confirmBtnColor: Colors.orange.shade800,
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
