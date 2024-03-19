import 'package:flutter/material.dart';

class CVCreation extends StatelessWidget {
  // ignore: use_super_parameters
  const CVCreation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CVS'), // Set the title of the app bar
      ),
      body: const Center(
        child: Text('Welcome to the CVs!'), // Placeholder content
      ),
    );
  }
}
