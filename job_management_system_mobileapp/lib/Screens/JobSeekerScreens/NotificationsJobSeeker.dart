import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/Chattings.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';

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

  @override
  Widget build(BuildContext context) {
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfileJobSeeker()));
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/Default.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Deshani Bandara',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'johndoe@gmail.com',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JobSeekerPage(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileJobSeeker(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
              },
           ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chattings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Chattings(),
                  ),
                );
              },
            ),
          ],
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
        child: const Icon(Icons.work),
      ),
    );
  }
}