import 'package:flutter/material.dart';

class ChooseUser extends StatefulWidget {
  @override
  _ChooseUserState createState() => _ChooseUserState();
}

class _ChooseUserState extends State<ChooseUser> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(250.0),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 241, 157, 47),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/DME_image01.png"),
                  fit: BoxFit.cover,// Adjust this property to control the image size
              ),
            ),
          ),
        ),
      ),
       body: Container(
  color: const Color.fromARGB(255, 241, 157, 47),
  child: Center(
    child: Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(top: 20.0), // Adjust top margin as needed
      child: Text(
        "Job Center, District Secretariat, Matara",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
),
  
      ),
    );
  }
}
