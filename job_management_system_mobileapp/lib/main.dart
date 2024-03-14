import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      
      // routes: {
      //   'login' :(context) => LoginPage(),
      // },
      initialRoute: 'login',
    );
  }
}


