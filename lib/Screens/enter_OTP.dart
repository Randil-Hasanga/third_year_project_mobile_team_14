import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/Screens/SignUp.dart';
import 'package:job_management_system_mobileapp/services/email_services.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';

class EnterOTP extends StatefulWidget {
  String userName;
  String email;
  String password;
  String confirmPassword;
  String accountType;
  EnterOTP({
    required this.userName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.accountType,
  });

  @override
  State<EnterOTP> createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTP> {
  final GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();
  FirebaseService? _firebaseService;
  EmailService? _emailService;
  EnterOTP? _enterOTP;

  String? _userName, _email, _password, _accountType;
  late bool _pending;

  bool _isLoading = false;
  String? otp;
  String? _enteredOTP;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseService = GetIt.instance<FirebaseService>();
    _emailService = GetIt.instance<EmailService>();

    _userName = widget.userName;
    _email = widget.email;
    _password = widget.password;
    _accountType = widget.accountType;

    generateOTP(6);
    _emailService!.sendEmail(_email!, _userName!, otp!);
  }

  void generateOTP(int length) {
    const chars = '0123456789';
    final random = Random();
    setState(() {
      otp = String.fromCharCodes(Iterable.generate(
          length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: Colors.orange[900],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Check Your Inbox',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'We sent a 6-digit code to your email address. Please enter the code below.\n\nIf you did not receive the email, please check your spam folder.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            Form(
              key: _otpFormKey,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Enter OTP',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                onSaved: (newValue) {
                  _enteredOTP = newValue!;
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[900],
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors
                              .orange), // make the progress indicator white to make it visible on the orange button
                        )
                      : const Text(
                          "Verify OTP",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _registerUser() async {
    _otpFormKey.currentState!.save();

    if (_enteredOTP == otp) {
      setState(
        () {
          _isLoading = true; // Set to true when login starts
        },
      );

      if (_accountType == 'provider') {
        setState(() {
          _pending = true;
        });
      } else {
        setState(() {
          _pending = false;
        });
      }

      bool _isRegistered = await _firebaseService!.registerUser(
        email: _email!,
        password: _password!,
        userName: _userName!,
        accountType: _accountType!,
        pending: _pending,
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
          content: Text('Invalid OTP'),
        ),
      );
    }
  }
}
