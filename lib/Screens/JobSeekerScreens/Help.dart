import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/seeker_chat_home.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen width and height for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
        title: const Text(
          'Help Center',
          style: TextStyle(
            color: Color.fromARGB(255, 248, 248, 248),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange.shade800,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // 5% of screen width for padding
          ),
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
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.event,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04), // 4% padding for all sides
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: screenWidth * 0.06, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // 2% of screen height
              _buildContactTile(
                context,
                icon: Icons.phone,
                title: 'Contact Number',
                subtitle: '0771132872',
              ),
              _buildContactTile(
                context,
                icon: Icons.email,
                title: 'Email',
                subtitle: 'pesmatara.dme@gmail.com',
              ),
              SizedBox(height: screenHeight * 0.04), // 4% of screen height
             /* Text(
                'Social Media',
                style: TextStyle(
                  fontSize: screenWidth * 0.06, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),*/
              SizedBox(height: screenHeight * 0.02),
             /* _buildContactTile(
                context,
                icon: Icons.facebook,
                title: 'Facebook',
                subtitle: 'Dept of Employment and Manpower',
              ),
              _buildContactTile(
                context,
                icon: Icons.call,
                title: 'WhatsApp',
                subtitle: '+1234567890',
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange.shade800),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: MediaQuery.of(context).size.width * 0.045, // Responsive font size
        ),
      ),
      subtitle: GestureDetector(
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: subtitle)); // Copy to clipboard
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Copied'),
            ),
          );
        },
        child: Text(
          subtitle,
          style: TextStyle(
            color: Colors.black54,
            fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
