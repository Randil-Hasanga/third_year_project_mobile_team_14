import 'package:flutter/material.dart';

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
