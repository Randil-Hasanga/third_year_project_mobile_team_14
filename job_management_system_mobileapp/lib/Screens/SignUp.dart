import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderPage.dart';
import 'package:job_management_system_mobileapp/Screens/ForgotPassword.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isJobProvider = false;

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
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1300),
                      child: const Text(
                        "Create Account",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1400),
                        child: Column(
                          children: <Widget>[
                            _buildTextFieldWithIcon(
                              hintText: "Username",
                              icon: Icons.person,
                            ),
                            _buildTextFieldWithIcon(
                              hintText: "Email",
                              icon: Icons.email,
                            ),
                            _buildTextFieldWithIcon(
                              hintText: "Password",
                              icon: Icons.lock,
                              isObscure: true,
                            ),
                            _buildTextFieldWithIcon(
                              hintText: "Re-enter Password",
                              icon: Icons.lock,
                              isObscure: true,
                            ),
                            const SizedBox(height: 20),
                            _buildAccountTypeSwitch(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildButton(
                        text: 'Sign Up',
                        onPressed: () {
                          // Implement your sign up logic here
                          // For demonstration purposes, navigate to the appropriate page based on the selected account type
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _isJobProvider
                                  ? const JobProviderPage()
                                  : const JobSeekerPage(),
                            ),
                          );
                        },
                        color: Colors.orange.shade900,
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          // Navigate to the forgot password page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: FadeInUp(
                          duration: const Duration(milliseconds: 1500),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Color.fromARGB(255, 255, 170, 0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTypeSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
       Text(
  _isJobProvider ? 'Job Provider' : 'Job Seeker',
  style: const TextStyle(
    color: Color.fromARGB(255, 36, 114, 8),
    fontSize: 18, // Adjust the font size as needed
  ),
),

        Switch(
          value: _isJobProvider,
          onChanged: (value) {
            setState(() {
              _isJobProvider = value;
            });
          },
          activeColor: Color.fromARGB(255, 26, 130, 74),
        ),
      ],
    );
  }

  Widget _buildTextFieldWithIcon({
    required String hintText,
    required IconData icon,
    bool isObscure = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color.fromARGB(255, 255, 115, 1),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              obscureText: isObscure,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return MaterialButton(
      onPressed: onPressed,
      height: 50,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Center(
        child: Text(
          "Sign Up",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}