//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';

class ChatUI extends StatelessWidget {
  final String reciverEmail;
  final String reciverID;
  ChatUI({super.key, required this.reciverEmail, required this.reciverID});

  final TextEditingController _messageController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  //send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _firebaseService.sendMessage(reciverID, _messageController.text);
    }
  }

  //clear message
  void clearMessage() {
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(reciverEmail),
      ),
      body: Column(
        children: [
          //display messages
          //Expanded(child: _buildMessageList()),

          _buildJobProviderInput(), //message input
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String? senderID;
    if (_firebaseService.currentUser != null) {
      senderID = _firebaseService.currentUser!['uid'];
    }
    return StreamBuilder(
      stream: _firebaseService.getMessages(reciverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: [
            Column(
              children: snapshot.data!.docs
                  .map((doc) => _buildMessageItem(doc))
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Text(data['message']);
  }

  //message input
  Widget _buildJobProviderInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: const InputDecoration(
              hintText: 'Type a message',
            ),
            obscureText: false,
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.send),
        )
      ],
    );
  }
}
