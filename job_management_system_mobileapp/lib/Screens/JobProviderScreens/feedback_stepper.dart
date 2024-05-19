import 'package:flutter/material.dart';

class FeedbackStepper extends StatefulWidget {
  const FeedbackStepper({super.key});

  @override
  State<FeedbackStepper> createState() => _FeedbackStepperState();
}

class _FeedbackStepperState extends State<FeedbackStepper> {
  int currentStep = 0;

  continueStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep = currentStep + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Applicant Name',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stepper(
          currentStep: currentStep,
          onStepContinue: continueStep,
          steps: [
            Step(
              title: const Text('Inform about Interview'),
              content: const Text('do call for interview ?'),
              isActive: currentStep >= 0,
              state: currentStep >= 0 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: const Text('Face for interview'),
              content: const Text('do face for interview ?'),
              isActive: currentStep >= 1,
              state: currentStep >= 1 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: const Text('Result of Interview'),
              content: const Text('pass or not interview ?'),
              isActive: currentStep >= 2,
              state: currentStep >= 2 ? StepState.complete : StepState.disabled,
            ),
          ]),
    );
  }
}
