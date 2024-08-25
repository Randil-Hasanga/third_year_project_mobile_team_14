import 'package:flutter/material.dart';

class InterviewDetailsTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const InterviewDetailsTile(
      {super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.assignment_outlined),
            const SizedBox(width: 20),
            Text(text),
          ],
        ),
      ),
    );
  }
}
