import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/chat_page.dart';
import 'package:job_management_system_mobileapp/componets/user_title.dart';
import 'package:job_management_system_mobileapp/services/chat_services.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';

class ChatHome extends StatelessWidget {
  ChatHome({super.key});

  final ChatService _chatService = ChatService();
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("chat home"),
        backgroundColor: Colors.orange.shade900,
      ),
      body: _buildUserList(),
    );
  }

  //build list of users except current user
  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatService.getUserStream(),
        builder: (context, snapshot) {
          //error
          if (snapshot.hasError) {
            return const Text('Error');
          }

          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading..');
          }

          //return list view
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  //build individual user tile
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    //display all users except current user
    if (userData['email'] != _firebaseService.getCurrentUserChat()!.email) {
      return UserTile(
        text: userData['username'],
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
    } else {
      return Container();
    }
  }
}
