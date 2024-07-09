import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/seeker_chat_home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
//import 'package:job_management_system_mobileapp/Screens/Chattings.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            _buildContactTile(
              context,
              icon: Icons.phone,
              title: 'Contact Number',
              subtitle: '0714587892',
              onTap: () {
                _callNumber(context, '0714587892');
              },
              onLongPress: () {
                _copyToClipboard(context, '0714587892');
              },
            ),
            _buildContactTile(
              context,
              icon: Icons.email,
              title: 'Email',
              subtitle: 'defnir@gmail.com',
              onTap: () {
                _launchEmail(context, 'defnir@gmail.com');
              },
              onLongPress: () {
                _copyToClipboard(context, 'defnir@gmail.com');
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Social Media',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            _buildContactTile(
              context,
              icon: Icons.facebook,
              title: 'Facebook',
              subtitle: 'Dept of Employment and Manpower',
              onTap: () {
                _launchURL(context,
                    'https://www.facebook.com/share/G99Wj1gb3AEcZfuD/?mibextid=qi2Omg');
              },
              onLongPress: () {
                _copyToClipboard(context,
                    'https://www.facebook.com/share/G99Wj1gb3AEcZfuD/?mibextid=qi2Omg');
              },
            ),
            _buildContactTile(
              context,
              icon: Icons.call,
              title: 'WhatsApp',
              subtitle: '+1234567890',
              onTap: () {
                _launchURL(context, 'https://wa.me/+1234567890');
              },
              onLongPress: () {
                _copyToClipboard(context, 'https://wa.me/+1234567890');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required void Function() onTap,
    required void Function() onLongPress,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange.shade800),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      subtitle: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Row(
          children: [
            Text(
              subtitle,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(width: 5),
            Icon(Icons.copy, size: 16, color: Colors.orange.shade800),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String data) {
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
      ),
    );
  }

  void _callNumber(BuildContext context, String number) async {
    try {
      final bool? result = await FlutterPhoneDirectCaller.callNumber(number);
      if (result != null && result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Calling...'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error while calling'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  void _launchEmail(BuildContext context, String email) async {
    final String uri = 'mailto:$email';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch email'),
        ),
      );
    }
  }

  void _launchURL(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch URL'),
        ),
      );
    }
  }
}
