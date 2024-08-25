import "package:flutter/material.dart";
import "package:lottie/lottie.dart";

class IntroPage1 extends StatefulWidget {
  const IntroPage1({super.key});

  @override
  State<IntroPage1> createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //add animation using lottie CDN
            Lottie.network(
                'https://lottie.host/50395d6d-a719-46e2-9a98-5b234b93f4f1/mSJFiaHZgb.json'),

            const SizedBox(
                height:
                    20), // Add some space between the animation and the text

            const Text(
              'Find your dream job here!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 255, 128, 0)),
            ),
          ],
        ),
      ),
    );
  }
}
