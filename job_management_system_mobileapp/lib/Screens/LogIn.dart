import 'package:flutter/material.dart';

class LogIn extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(250.0),
          child: AppBar(
            backgroundColor: Colors.transparent, // Set the AppBar color to transparent
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.orange, Colors.white], // Colors for the gradient
                  stops: [0.7, 1.0], // Gradient stops
                ),
                image: DecorationImage(
                  image: AssetImage("assets/DME_image01.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    }
}