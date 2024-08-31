import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final String lastMessage;
  final int unreadCount;

  const UserTile(
      {super.key,
      required this.text,
      this.onTap,
      required this.lastMessage,
      required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        child: ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/profile_picture.jpg'),
            ),
            title: Text(text),
            subtitle: Text(lastMessage),
            trailing: unreadCount > 0
                ? CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null),
      ),
    );
  }
}
