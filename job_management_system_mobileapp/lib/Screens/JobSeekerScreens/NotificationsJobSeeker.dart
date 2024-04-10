import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/Chattings.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';


class NotificationsJobSeeker extends StatefulWidget {
  // ignore: use_super_parameters
  const NotificationsJobSeeker({Key? key}) : super(key: key);

  @override
  _NotificationsJobSeekerState createState() => _NotificationsJobSeekerState();
}

class _NotificationsJobSeekerState extends State<NotificationsJobSeeker> {
  final List<String> _notifications = [
    'New job posting available',
    'You applied successfully to a job posting',
    'A company has contacted you for a job posting',
    'You have a message in your inbox',
    'New job posting available',
    'You applied successfully to a job posting',
    'A company has contacted you for a job posting',
    'You have a message in your inbox',
    'New job posting available',
    'You applied successfully to a job posting',
    'A company has contacted you for a job posting',
    'You have a message in your inbox',
  ];
     double? _deviceWidth, _deviceHeight; 


  @override
  Widget build(BuildContext context) {
 //responsiveness of the device
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    void showAlert() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
      );
    }


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
                icon: const Icon(Icons.home,color: Colors.white,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const JobSeekerPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings,color: Colors.white,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications,color: Colors.white,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const NotificationsJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat,color: Colors.white,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const Chattings()));
                },
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(_notifications[index]),
            onTap: () {
              // Handle notification tap
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const JobSeekerPage(),
            ),
          );
        },
      
      ),
    );}
}