// ignore: file_names
import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/Vacancies.dart';
import 'package:job_management_system_mobileapp/Screens/LogInPage.dart';

class JobProviderPage extends StatelessWidget {
  const JobProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // You can adjust this factor according to your preference
    double fontSize = screenWidth * 0.04; // Example factor

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
              const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/Default.png'),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Dinuka Sandeepa",
                            style:
                                TextStyle(color: Colors.white, fontSize: 30)),
                        Text("Software Engineer",
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
                  padding: const EdgeInsets.all(30),
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
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "My vacancies",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              // Add your logic to navigate to see all posted jobs
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
                            "Scheduled interviews",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              // Add your logic to navigate to see all scheduled interviews
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
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            5,
                            (index) => Container(
                              margin: const EdgeInsets.all(8),
                              width: 250,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Vacancy $index",
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
                            "Suggested Seekers",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              // Add your logic to navigate to see all suggested seekers
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
                        height: 230, // Adjust the height as needed
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Profile Icon
                                    const CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                          'assets/profile_picture.jpg'),
                                    ),
                                    const SizedBox(height: 8),
                                    // Skills
                                    const Text(
                                      "Skills: Skill 1, Skill 2, Skill 3",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    // Preferred Working Section
                                    const Text(
                                      "Preferred Working: Location, Remote",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    // View CV Button
                                    ElevatedButton(
                                      onPressed: () {
                                        // Add your logic to view the CV of the job seeker
                                      },
                                      child: const Text("View CV"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Profile Icon
                                  const CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                        'assets/profile_picture.jpg'),
                                  ),
                                  const SizedBox(height: 8),
                                  // Skills
                                  const Text(
                                    "Skills: Skill 1, Skill 2, Skill 3",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  // Preferred Working Section
                                  const Text(
                                    "Preferred Working: Location, Remote",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  // View CV Button
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add your logic to view the CV of the job seeker
                                    },
                                    child: const Text("View CV"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Requested CV List",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
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
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Profile Icon
                                  const CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        AssetImage('assets/Default.jpg'),
                                  ),
                                  const SizedBox(height: 8),
                                  // Job Seeker Name
                                  const Text(
                                    "Dinuka Sandeepa",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  // View CV Button
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add your logic to view the CV of the job seeker
                                    },
                                    child: const Text("View CV"),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Profile Icon
                                  const CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                        'assets/profile_picture.jpg'),
                                  ),
                                  const SizedBox(height: 8),
                                  // Job Seeker Name
                                  const Text(
                                    "Jane Doe",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  // View CV Button
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add your logic to view the CV of the job seeker
                                    },
                                    child: const Text("View CV"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Feedback CV List", // Add the Feedback CV list section title
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              // Add your logic to navigate to the feedback CV list page
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
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Profile Icon
                                  const CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                        'assets/profile_picture.jpg'),
                                  ),
                                  const SizedBox(height: 8),
                                  // Job Seeker Name
                                  const Text(
                                    "John Doe",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  // Submit Feedback Button
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add your logic to submit feedback for the job seeker
                                    },
                                    child: const Text("Submit Feedback"),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Profile Icon
                                  const CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        AssetImage('assets/Default.png'),
                                  ),
                                  const SizedBox(height: 8),
                                  // Job Seeker Name
                                  const Text(
                                    "Jane Doe",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  // Submit Feedback Button
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add your logic to submit feedback for the job seeker
                                    },
                                    child: const Text("Submit Feedback"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Add the requested CV list boxes here similar to the suggested seekers
                      // You can use the same widget as suggested seekers but with different data
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
                    backgroundImage: AssetImage('assets/Default.jpg'),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Dinuka Sandeepa',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    'Software Engineer',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.create,
                  color: Color.fromARGB(255, 255, 137, 2)),
              title: const Text('Create Vacancy'),
              onTap: () {
                // Navigate to find jobs page
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => vacancies()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule,
                  color: Color.fromARGB(255, 255, 137, 2)),
              title: const Text('Schedule Interveiws'),
              onTap: () {
                // Navigate to create CV page
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_2,
                  color: Color.fromARGB(255, 255, 137, 2)),
              title: const Text('See JobSeekers'),
              onTap: () {
                // Navigate to create CV page
              },
            ),
            ListTile(
              leading: const Icon(Icons.description,
                  color: Color.fromARGB(255, 255, 137, 2)),
              title: const Text('See CV'),
              onTap: () {
                // Navigate to create CV page
              },
            ),
            ListTile(
              leading: const Icon(Icons.comment,
                  color: Color.fromARGB(255, 255, 137, 2)),
              title: const Text('Give feedbacks'),
              onTap: () {
                // Navigate to create CV page
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings,
                  color: Color.fromARGB(255, 255, 137, 2)),
              title: const Text('Profile Setting'),
              onTap: () {
                // Navigate to create CV page
              },
            ),
            ListTile(
              leading: const Icon(Icons.power_settings_new,
                  color: Color.fromARGB(255, 255, 137, 2)),
              title: const Text('Log out'),
              onTap: () {
                // Navigate to create CV page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LogInPage(),
                  ),
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
                          builder: (context) => JobProviderPage()));
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JobProviderPage()));
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
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
