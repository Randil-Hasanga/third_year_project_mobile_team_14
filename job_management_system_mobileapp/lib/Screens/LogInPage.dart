import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/SignUp.dart';
import 'package:job_management_system_mobileapp/Screens/ForgotPassword.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _isLoading = false;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  String? _email, _password;
  FirebaseService? _firebaseService;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange.shade900,
              Colors.orange.shade800,
              Colors.orange.shade400,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: const Row(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: CircleAvatar(
                              radius: 30, // Increased radius
                              backgroundImage: AssetImage(
                                  'assets/Default.png'), // Adjust the image path as needed
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1300),
                      child: const Text(
                        "Welcome Back",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _loginForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60),
          topRight: Radius.circular(60),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _loginFormKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 60),
              FadeInUp(
                duration: const Duration(milliseconds: 1400),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 245, 245, 245),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 213, 210, 205),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.orange,
                            width: 2,
                          ),
                        ),
                      ),
                      onSaved: (_value) {
                        setState(() {
                          _email = _value;
                        });
                      },
                      validator: (_value) {
                        bool _result = _value!.contains(
                          RegExp(
                              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
                        );
                        return _result ? null : "Please enter a valid email";
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 213, 210, 205),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.orange,
                            width: 2,
                          ),
                        ),
                      ),
                      onSaved: (_value) {
                        setState(() {
                          _password = _value;
                        });
                      },
                      validator: (_value) => _value!.length >= 8
                          ? null
                          : "Please enter password greater than 8 characters",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                child: MaterialButton(
                  onPressed: _isLoading ? null : _loginUser,
                  height: 50,
                  color: Colors.orange[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors
                              .orange), // make the progress indicator white to make it visible on the orange button
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                height: 50,
                color: const Color.fromARGB(255, 243, 239, 239),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Color.fromARGB(255, 249, 150, 2)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'fogot_pwd');
                },
                child: FadeInUp(
                  duration: const Duration(milliseconds: 1500),
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Color.fromARGB(255, 255, 153, 0)),
                  ),
                  
                ),
              ),const SizedBox(height: 150),
              const Text("Job Center, Matara"),
            ],
          ),
        ),
      ),
    );
  }

  void _loginUser() async {
    setState(
      () {
        _isLoading = true; // Set to true when login starts
      },
    );
    _loginFormKey.currentState!.save();
    bool _result =
        await _firebaseService!.loginUser(email: _email!, password: _password!);

    setState(
      () {
        _isLoading = false; // Set to false when login ends
      },
    );

    if (_result) {
      if (_firebaseService!.currentUser!['type'] == 'seeker') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JobSeekerPage()),
        );
      } else if (_firebaseService!.currentUser!['type'] == 'provider') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JobProviderPage()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Invalid email or password",
            selectionColor: Color.fromARGB(255, 230, 255, 2),
          ),
        ),
      );
    }
  }
}
