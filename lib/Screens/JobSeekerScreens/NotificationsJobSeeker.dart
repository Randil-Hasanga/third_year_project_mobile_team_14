import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
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
  int _newInterviewCount = 0;

  int _unreadNotificationCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchVacancyAndInterviewDetails();
    _fetchUnreadNotificationCount().then((count) {
      setState(() {
        _unreadNotificationCount = count;
      });
    });
  }

  Future<void> _fetchVacancyAndInterviewDetails() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    print("Fetching interview progress for userId: $userId");

    List<Map<String, dynamic>>? interviewDetails =
        await _fetchAppliedVacancies(userId);

    if (interviewDetails != null && interviewDetails.isNotEmpty && mounted) {
      print("Interview Details: $interviewDetails");
      setState(() {
        _interviewDetails = interviewDetails;
        _newInterviewCount = interviewDetails.length;  // Set when fetching new details
 // Update the interview count
      });
    } else {
      print("No interview details found.");
      setState(() {
        _interviewDetails = [];
        _newInterviewCount = 0; // Reset if no new interview details
      });
    }
  }

  Future<int> _fetchUnreadNotificationCount() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('notifications')
            .where('userId', isEqualTo: userId)
            .where('read', isEqualTo: false) // Only fetch unread notifications
            .get();
    return snapshot.docs.length;
  }

  Future<void> _markNotificationAsRead(String notificationId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'read': true});
      print("Notification $notificationId marked as read.");
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }

  Future<List<Map<String, dynamic>>?> _fetchAppliedVacancies(
      String userId) async {
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
          QuerySnapshot<Map<String, dynamic>> interviewSnapshot =
              await firestore
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
                'submitted_date': vacancyData['applied_at'],
                'notificationId': interviewData[
                    'notificationId'], // Ensure this field is included
                'read': interviewData['read'] ??
                    false // Ensure 'read' field is included with default value
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
void _handleInfoIconClick(Map<String, dynamic> interview) async {
  String? notificationId = interview['notificationId'];

  if (notificationId != null) {
    await _markNotificationAsRead(notificationId);

    // Update the UI after marking the notification as read
    setState(() {
      if (_newInterviewCount > 0) {
        _newInterviewCount--;
      }
      _interviewDetails?.removeWhere((i) => i['notificationId'] == notificationId);
      _unreadNotificationCount--;
    });
  }

  // Display the interview details to the user
  QuickAlert.show(
    context: context,
    type: QuickAlertType.info,
    title: 'Interview Details',
    text: '📅 Company: ${interview['companyName']}\n'
        '🕒 Date & Time: ${interview['dateTime']}\n'
        '📋 Topic: ${interview['topic']}\n'
        '📝 Description: ${interview['description']}\n'
        '📍 Type: ${interview['type']}\n'
        '📅 Submitted Date: ${interview['submitted_date'] is Timestamp ? DateFormat.yMMMd().add_jm().format((interview['submitted_date'] as Timestamp).toDate()) : 'Not found'}',
    confirmBtnText: 'OK',
    confirmBtnColor: Colors.orange.shade800,
    widget: Column(
      children: [
        const SizedBox(height: 10),
        GestureDetector(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: interview['link'])).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link copied to clipboard')),
              );
            });
          },
          child: Row(
            children: [
              const Icon(Icons.link, color: Colors.orange),
              const SizedBox(width: 5),
              Expanded(
                child: SelectableText(
                  interview['link'] ?? 'No link available',
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  onTap: () {
                    // Optionally, handle tap to open the link if desired
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
        title: const Text(
          'Interview Details',
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
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.event, color: Colors.white),
                    if (_newInterviewCount >
                        0) // Show badge if there are new interviews
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '$_newInterviewCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationsJobSeeker()),
                  );
                },
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
                          tileColor: interview['read']
                              ? Colors.grey[200]
                              : Colors
                                  .white, // Example to change background color
                          leading: Icon(
                            Icons.notifications,
                            color: interview['read']
                                ? Colors.grey
                                : Colors.orange.shade700, // Change icon color
                          ),
                          title: Text(
                            interview['companyName'] ?? 'Unknown Company',
                            style: TextStyle(
                              fontWeight: interview['read']
                                  ? FontWeight.normal
                                  : FontWeight.bold, // Change text weight
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
                              _handleInfoIconClick(interview);
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
