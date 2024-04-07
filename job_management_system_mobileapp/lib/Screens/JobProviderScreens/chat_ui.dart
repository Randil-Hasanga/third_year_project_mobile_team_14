import 'package:flutter/material.dart';

class ChatUI extends StatelessWidget {
  final String reciverEmail;
  const ChatUI({super.key, required this.reciverEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(reciverEmail),
      ),
    );
  }
}
