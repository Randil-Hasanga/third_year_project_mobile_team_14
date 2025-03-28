import 'package:flutter/material.dart';

class UserTitleFeedback extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const UserTitleFeedback({super.key, required this.text, this.onTap});

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
        child: Row(
          children: [
            Icon(Icons.person),
            const SizedBox(width: 20),
            Text(text),
          ],
        ),
      ),
    );
  }
}
