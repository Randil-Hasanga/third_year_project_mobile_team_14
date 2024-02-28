import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar:AppBar(
         
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/DME_image01.png"),
                fit: BoxFit.cover  ),
            ),
          ),
          
         
        ),

        body:Center(child: Text("JOB CENTER "),
        ),
      ),
    );
  }
}
