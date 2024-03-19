import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/Chattings.dart';
import 'package:job_management_system_mobileapp/Screens/Jobs.dart';
import 'package:job_management_system_mobileapp/Screens/CVCreation.dart';
import 'package:job_management_system_mobileapp/Screens/FeedBackJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/ProfileJobSeeker.dart';


class JobSeekerPage extends StatelessWidget {
  const JobSeekerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String language) {
              // Handle language selection here
              switch (language) {
                case 'English':
                  // Change app language to English
                  break;
                case 'සිංහල':
                  // Change app language to Sinhala
                  break;
                case 'தமிழ்':
                  // Change app language to Tamil
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'English',
                child: Text('English'),
              ),
              const PopupMenuItem<String>(
                value: 'සිංහල',
                child: Text('සිංහල'),
              ),
              const PopupMenuItem<String>(
                value: 'தமிழ்',
                child: Text('தமிழ்'),
              ),
            ],
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
              const SizedBox(height: 2,),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/Default.png'),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Job Seeker", style: TextStyle(color: Colors.white, fontSize: 40)),
                        Text("John Doe", style: TextStyle(color: Colors.white, fontSize: 20)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(225, 95, 27, .3),
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
                                  icon: Icon(Icons.search, color: Colors.grey,),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Add your job filter logic here
                              },
                              icon: const Icon(Icons.filter_list, color: Colors.grey,),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Featured Jobs",
                            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Jobs()),
    );
  },
  child: const Text(
    "See All",
    style: TextStyle(color: Color.fromARGB(255, 255, 145, 0), fontSize: 16),
  ),
),

                        ],
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            10,
                            (index) => Container(
                              margin: const EdgeInsets.all(8),
                              width: 250,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Job $index",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Recent Jobs",
                            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              // Add your logic to navigate to see all recent jobs
                            },
                            child: const Text(
                              "See All",
                              style: TextStyle(color: Color.fromARGB(255, 243, 117, 33), fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 300, // Adjust the height as needed
                        child: ListView(
                          children: List.generate(
                            5,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                              padding: const EdgeInsets.all(16),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Job Title $index",
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Company Name",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Location",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Description of the job goes here. You can provide more details about the job in this section.",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile_picture.jpg'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Job Seeker',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    'John Doe',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
  leading: Icon(Icons.search), // Icon for finding jobs
  title: const Text('Find Jobs'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>const Jobs()),
    );
  },
),

ListTile(
  leading: Icon(Icons.create), // Icon for creating CV
  title: const Text('Create CV'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>const CVCreation()),
    );
  },
),

ListTile(
  leading: Icon(Icons.feedback), // Icon for giving feedback
  title: const Text('Give Feedbacks'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>const FeedBackJobSeeker()),
    );
  },
),

ListTile(
  leading: Icon(Icons.notifications), // Icon for notifications
  title: const Text('Notifications'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>const NotificationsJobSeeker()),
    );
  },
),

ListTile(
  leading: Icon(Icons.settings), // Icon for profile settings
  title: const Text('Profile Settings'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>const ProfileJobSeeker()),
    );
  },
),
ListTile(
            leading: Icon(Icons.logout), // Icon for logout
            title: const Text('Logout'),
            onTap: () {
              // Perform logout action
            },
          ),

          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>const JobSeekerPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>const ProfileJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>const NotificationsJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>const Chattings()));
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your logic for the floating action button here
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
