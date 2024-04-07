import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/chat_ui.dart';
import 'package:job_management_system_mobileapp/componets/user_title.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'), // Set the title of the app bar
        backgroundColor: const Color.fromARGB(255, 255, 136, 0),
      ),
      body: _buildJobSeekerList(),
    );
  }

  Widget _buildJobSeekerList() {
    return StreamBuilder(
      stream: firebaseService.getJobSeekerStream(),
      builder: ((context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Text('Error');
        }
        //Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>(
                  (userData) => _buildJobSeekerListItem(userData, context))
              .toList(),
        );
      }),
    );
  }

  // Individual list item for job seeker
  Widget _buildJobSeekerListItem(
      Map<String, dynamic> userData, BuildContext context) {
    return JobSeekerTitle(
        text: userData['email'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatUI(
                reciverEmail: userData['email'],
              ),
            ),
          );
        });
  }
}
