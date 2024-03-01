// ignore: file_names
import 'package:flutter/material.dart';
import 'LogIn.dart'; // Import the LogIn.dart file

class ChooseUser extends StatefulWidget {
  const ChooseUser({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChooseUserState createState() => _ChooseUserState();
}

class _ChooseUserState extends State<ChooseUser> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(250.0),
          child: AppBar(
            backgroundColor: Colors.transparent, // Set the AppBar color to transparent
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.orange, Colors.white], // Colors for the gradient
                  stops: [0.7, 1.0], // Gradient stops
                ),
                image: DecorationImage(
                  image: AssetImage("assets/DME_image01.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(255, 255, 255, 255), Colors.orange],
              stops: [0.7, 1.0],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserButton(
                  icon: Icons.work,
                  text: "Job Provider",
                  onPressed: () {
                    // Navigate to LogIn screen when Job Provider button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogIn()),
                    );
                  },
                ),
                const SizedBox(height: 75),
                UserButton(
                  icon: Icons.search,
                  text: "Job Seeker",
                  onPressed: () {
                    // Navigate to LogIn screen when Job Seeker button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogIn()),
                    );
                  },
                ),
                const SizedBox(height: 200),
                const Text(
                  "Job Center, District Secretariat, Matara",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const UserButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
          ),
          const SizedBox(height: 10),
          Text(text),
        ],
      ),
    );
  }
}
