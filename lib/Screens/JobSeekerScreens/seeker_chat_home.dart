import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';

import '../../componets/user_title.dart';
import '../../services/chat_services.dart';
import '../../services/firebase_services.dart';
import '../JobProviderScreens/chat_page.dart';

class SeekerChatHome extends StatelessWidget {
  SeekerChatHome({super.key});

  final ChatService _chatService = ChatService();
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("chat home"),
        backgroundColor: Colors.orange.shade900,
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
                  Navigator.popAndPushNamed(context, "seeker_chats");
                },
              ),
            ],
          ),
        ),
      ),




      body: _buildProviderList(),
    );
  }

  _buildProviderList() {
    return StreamBuilder(
      stream: _chatService.getProviderStream(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Text('Error');
        }

        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>(
                  (userData) => _buildProviderListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  _buildProviderListItem(Map<String, dynamic> userData, BuildContext context) {
    //display all provider except current user
    if (userData['email'] != _firebaseService.getCurrentUserChat()!.email) {
      return FutureBuilder<Map<String, dynamic>>(
        future: _chatService.getMessageDetails(
            userData['uid'], _firebaseService.getCurrentUserChat()!.uid),
        builder: (context, messageSnapshot) {
          if (messageSnapshot.connectionState == ConnectionState.waiting) {
            return UserTile(
              text: userData['username'],
              lastMessage: 'Loading...',
              unreadCount: 0,
            );
          }

          if (messageSnapshot.hasError) {
            return UserTile(
              text: userData['username'],
              lastMessage: 'Error loading messages',
              unreadCount: 0,
            );
          }

          final messageDetails = messageSnapshot.data!;
          return UserTile(
            text: userData['username'],
            lastMessage: messageDetails['lastMessage'],
            unreadCount: messageDetails['unread'],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverName: userData['username'],
                    receiverEmail: userData['email'],
                    receiverID: userData['uid'],
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      return Container();
    }
  }
}
