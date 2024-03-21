import 'package:emailjs/emailjs.dart';
import 'package:flutter/material.dart';

class EmailService {
  final serviceID = "service_1un6rrh";
  final templateID = "template_pmznrjr";
  final publicKey = "qP1AIEXUXjj4wmILR";
  final privateKey = "erU8nuiHf2Zt3SLDF1VAx";

  EmailService();

  Future<void> sendEmail(String email, String username,String otp,) async {

    Map<String, dynamic> templateParams = {
      'name': username,
      'otp': otp,
      'to_email': email,
      'subject': 'OTP Verification',
    };
    try {
      await EmailJS.send(
        serviceID,
        templateID,
        templateParams,
        Options(
          publicKey: publicKey,
          privateKey: privateKey,
        ),
      );
      print('SUCCESS!');
    } catch (error) {
      print(error.toString());
    }
  }
}
