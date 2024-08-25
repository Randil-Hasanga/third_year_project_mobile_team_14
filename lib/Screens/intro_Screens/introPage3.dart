import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatefulWidget {
  const IntroPage3({super.key});

  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //add animation using lottie CDN
            Lottie.network(
                'https://lottie.host/117cac29-bf32-4947-b793-1cafb17833f1/gxXL8i3xCn.json'),

            const SizedBox(
                height:
                    20), // Add some space between the animation and the text

            const Text(
              'Generate your Cv here!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 255, 128, 0)),
            ),
          ],
        ),
      ),
    );
  }
}
