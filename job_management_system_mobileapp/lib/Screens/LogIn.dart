import 'package:flutter/material.dart';
import 'JobProviderDash.dart'; // Import the JobProviderDash.dart file
import 'ForgetPassword.dart'; // Import the ForgetPassword.dart file
import 'SignUp.dart'; // Import the SignUp.dart file

class LogIn extends StatelessWidget {
  const LogIn({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false, // Set to false to prevent resizing when keyboard is displayed
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0), // Adjust the padding as needed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "LogIn",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "User Name",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add logic to validate user credentials and navigate accordingly
                    // For now, navigating to JobProviderDash
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const JobProviderDash()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Set the background color of the button to orange
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text("LogIn",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20), // Add some space here
                GestureDetector(
                  onTap: () {
                    // Navigate to ForgetPassword screen when "Forget password?" text is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgetPassword()),
                    );
                  },
                  child: const Text(
                    "Forget password?",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Navigate to SignUp screen when "Sign Up" button is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const Spacer(), // Add spacer to push the text to the bottom
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Job Center, District Secretariat, Matara",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
