import "package:animated_splash_screen/animated_splash_screen.dart";
import "package:flutter/material.dart";
import "package:job_management_system_mobileapp/Screens/LogInPage.dart";

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Image.asset(
            "assets/logo.png",
            height: MediaQuery.of(context).size.width / 2.5,
            width: MediaQuery.of(context).size.width / 2.5,
          ),
          //SizedBox(height: 20),
          const Text("Job Management System",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
      nextScreen: const LogInPage(),
      splashIconSize: 400,
      backgroundColor: Colors.orange.shade900,
    );
  }
}
