// ignore: file_names
import 'package:flutter/material.dart';
import 'JobSeekerDash.dart'; // Import the JobSeekerDash.dart file

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign Up",
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
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
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
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Re-enter Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to JobSeekerDash screen when "Sign Up" button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JobSeekerDash()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Set the background color to orange
                ),
                child: const Text("Sign Up"),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
