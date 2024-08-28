import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/colors/colors.dart';

class MyVacanices extends StatefulWidget {
  const MyVacanices({super.key});

  @override
  State<MyVacanices> createState() => _MyVacanicesState();
}

class _MyVacanicesState extends State<MyVacanices> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'My Vacancies',
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth! * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: appBarColor,
      ),
    );
  }
}
