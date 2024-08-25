import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/Screens/enter_OTP.dart';
import 'package:job_management_system_mobileapp/services/email_services.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:job_management_system_mobileapp/widgets/textfield_widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  bool _isJobProvider = false;
  int? OTP;
  String _accountType = 'seeker';
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  String? _userName, _email, _password, _reEnterPassword;
  bool showTextPwd = true;
  bool showTextRePwd = true;

  TextFieldWidgets _textFieldWidgets = TextFieldWidgets();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                      const SizedBox(height: 125),
                      const Text("Job Center, Matara"),
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
        onPressed: () {
          _validateAndSave();
        },
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
          // _userNameTextField(),
          _textFieldWidgets.usernameTextFieldStyleSignUp((value) {
            setState(() {
              _userName = value;
            });
          }, "Username", validate: true),
          // _emailTextField(),
          _textFieldWidgets.emailTextFieldStyleSignUp((value) {
            setState(() {
              _email = value;
            });
          }, "Email", validate: true),
          // _passwordTextField(),
          _textFieldWidgets.passwordTextFieldStyle2(showTextPwd, () {
            setState(() {
              showTextPwd = !showTextPwd;
            });
          }, (value) {
            setState(() {
              _password = value;
            });
          }, "Password", validate: true),
          //_reEnterPasswordTextField(),
          _textFieldWidgets.passwordTextFieldStyle2(showTextRePwd, () {
            setState(() {
              showTextRePwd = !showTextRePwd;
            });
          }, (value) {
            setState(() {
              _reEnterPassword = value;
            });
          }, "Re-enter Password", validate: true),
        ],
      ),
    );
  }

  void _validateAndSave() async {
    if (_signUpFormKey.currentState!.validate()) {
      _signUpFormKey.currentState!.save();

      if (_password != _reEnterPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Password does not match",
              selectionColor: Color.fromARGB(255, 230, 255, 2),
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnterOTP(
                userName: _userName!,
                email: _email!,
                password: _password!,
                confirmPassword: _reEnterPassword!,
                accountType: _accountType),
          ),
        );
      }
    }
  } // write codes tp generate random otp
}
