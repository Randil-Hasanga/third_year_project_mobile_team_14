import "package:animated_splash_screen/animated_splash_screen.dart";
import "package:flutter/material.dart";
import "package:job_management_system_mobileapp/Screens/LogInPage.dart";
import "package:job_management_system_mobileapp/Screens/onboardScreen.dart";

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Image.asset(
            "assets/Logo.png",
            height: MediaQuery.of(context).size.width / 2.5,
            width: MediaQuery.of(context).size.width / 2.5,
          ),
          //SizedBox(height: 20),
          const Text("Job Management System",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.orange)),
              
        ],
      ),
      nextScreen: const OnboardScreen(),
      splashIconSize: 400,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}
