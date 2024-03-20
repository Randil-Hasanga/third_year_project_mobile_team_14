import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderPage.dart';
import 'package:job_management_system_mobileapp/Screens/ForgotPassword.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  bool _isJobProvider = false;
  String? _accountType = 'seeker';
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  String? _userName, _email, _password, _reEnterPassword;

  FirebaseService? _firebaseService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    print(_accountType);
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
                            _signUpForm(),
                            const SizedBox(height: 20),
                            _buildAccountTypeSwitch(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildButton(
                        text: 'Sign Up',
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
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 170, 0)),
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          _isJobProvider ? 'Job Provider' : 'Job Seeker',
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 123, 0),
            fontSize: 18, // Adjust the font size as needed
          ),
        ),
        Switch(
          value: _isJobProvider,
          onChanged: (value) {
            setState(() {
              if (value) {
                _accountType = 'provider';
                _isJobProvider = value;
              } else {
                _accountType = 'seeker';
                _isJobProvider = value;
              }
            });
          },
          activeColor: Color.fromARGB(255, 26, 130, 74),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      child: MaterialButton(
        onPressed: _isLoading ? null : _registerUser,
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
                "Sign Up",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _signUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: [
          _userNameTextField(),
          _emailTextField(),
          _passwordTextField(),
          _reEnterPasswordTextField(),
        ],
      ),
    );
  }

  Widget _userNameTextField() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person,
            color: const Color.fromARGB(255, 255, 115, 1),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              onSaved: (_value) {
                setState(() {
                  _userName = _value;
                });
              },
              decoration: const InputDecoration(
                hintText: "Username",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emailTextField() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.email,
            color: const Color.fromARGB(255, 255, 115, 1),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              onSaved: (_value) {
                setState(() {
                  _email = _value;
                });
              },
              decoration: const InputDecoration(
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordTextField() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock,
            color: const Color.fromARGB(255, 255, 115, 1),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              onSaved: (_value) {
                setState(() {
                  _password = _value;
                });
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reEnterPasswordTextField() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock,
            color: const Color.fromARGB(255, 255, 115, 1),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              onSaved: (_value) {
                setState(() {
                  _reEnterPassword = _value;
                });
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Re-enter Password",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _registerUser() async {
    setState(
      () {
        _isLoading = true; // Set to true when login starts
      },
    );
    _signUpFormKey.currentState!.save();
    if (_password == _reEnterPassword) {
      if (_accountType != null) {
        bool _isRegistered = await _firebaseService!.registerUser(
          email: _email!,
          password: _password!,
          userName: _userName!,
          accountType: _accountType!,
        );
        setState(
          () {
            _isLoading = false; // Set to true when login starts
          },
        );
        if (_isRegistered) {
          Navigator.pushNamed(context, 'login');
          setState(
            () {
              _isLoading = false; // Set to true when login starts
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to register user'),
            ),
          );
          setState(
            () {
              _isLoading = false; // Set to true when login starts
            },
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an account type'),
          ),
        );
        setState(
          () {
            _isLoading = false; // Set to true when login starts
          },
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
      setState(
        () {
          _isLoading = false; // Set to true when login starts
        },
      );
    }
  }
}
