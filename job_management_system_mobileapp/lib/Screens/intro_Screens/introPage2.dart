import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatefulWidget {
  const IntroPage2({super.key});

  @override
  State<IntroPage2> createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //add animation using lottie CDN
            Lottie.network(
                'https://lottie.host/92d74da4-2398-49b6-acb3-1e13504d56fb/KCkKI0Gzrz.json'),

            const SizedBox(height: 20),
            // Add some space between the animation and the text

            const Text(
              'Find your team here!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 255, 128, 0)),
            ),
          ],
        ),
      ),
    );
  }
}
