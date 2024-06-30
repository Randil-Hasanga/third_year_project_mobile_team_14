

//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
        title: const Text(
          'Help Center',
          style: TextStyle(
            color: Color.fromARGB(255, 248, 248, 248),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Contact Number'),
            subtitle: InkWell(
              onTap: () {
                _callNumber(context, '071');
              },
              child: const Row(
                children: [
                  Text('0714587892'),
                  SizedBox(width: 5),
                  Icon(Icons.copy, size: 16),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: InkWell(
              onTap: () {
                _launchEmail(context, 'defnir@gmail.com');
              },
              child: const Row(
                children: [
                  Text('defnir@gmail.com'),
                  SizedBox(width: 5),
                  Icon(Icons.copy, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Social Media',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.facebook),
            title: const Text('Facebook'),
            subtitle: InkWell(
              onTap: () {
                _launchURL(context,
                    'https://www.facebook.com/share/G99Wj1gb3AEcZfuD/?mibextid=qi2Omg');
              },
              child: const Row(
                children: [
                  Text('Department of Employement and Manpower'),
                  SizedBox(width: 5),
                  Icon(Icons.copy, size: 16),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.call),
            title: const Text('WhatsApp'),
            subtitle: InkWell(
              onTap: () {
                _launchURL(context, 'https://wa.me/+1234567890');
              },
              child: const Row(
                children: [
                  Text('+1234567890'),
                  SizedBox(width: 5),
                  Icon(Icons.copy, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String data) {
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
      ),
    );
  }

  void _callNumber(BuildContext context, String number) async {
    try {
      var FlutterPhoneDirectCaller;
      final bool? result = await FlutterPhoneDirectCaller.callNumber(number);
      if (result != null && result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Calling...'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error while calling'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  void _launchEmail(BuildContext context, String email) async {
    final String uri = 'mailto:$email';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch email'),
        ),
      );
    }
  }

  void _launchURL(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch URL'),
        ),
      );
    }
  }
}
