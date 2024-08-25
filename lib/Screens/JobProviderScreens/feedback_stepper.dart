import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';

class FeedbackStepper extends StatefulWidget {
  final String applicantId;
  final String vacancyId;

  const FeedbackStepper(
      {super.key, required this.applicantId, required this.vacancyId});

  @override
  State<FeedbackStepper> createState() => _FeedbackStepperState();
}

class _FeedbackStepperState extends State<FeedbackStepper> {
  FirebaseService? firebaseService;
  int currentStep = 0;
  bool applicationReceived = false;
  bool initialInterviewPassed = false;
  bool selectStatus = false;
  String feedback = '';

  continueStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
    }
  }

  cancelStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Interview Progress',
          style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: continueStep,
        onStepCancel: cancelStep,
        controlsBuilder:
            (BuildContext context, ControlsDetails controlsDetails) {
          return Container();
        },
        steps: [
          Step(
            title: const Text(
              'Application Received',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              children: [
                const Text('Has the application been received?'),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 157, 178, 187),
                      ),
                      onPressed: () {
                        setState(() {
                          applicationReceived = true;
                          continueStep();
                        });
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: screenHeight * 0.01,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          applicationReceived = false;
                          continueStep();
                        });
                      },
                      child: const Text(
                        'No',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            isActive: currentStep >= 0,
            state: currentStep >= 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text(
              'Initial Screening',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              children: [
                const Text('Did the applicant pass the initial screening?'),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 157, 178, 187),
                      ),
                      onPressed: () {
                        setState(() {
                          initialInterviewPassed = true;
                          continueStep();
                        });
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: screenHeight * 0.01,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        initialInterviewPassed = false;
                        continueStep();
                      },
                      child: const Text(
                        'No',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            isActive: currentStep >= 1,
            state: currentStep >= 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text(
              'Interview Result',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Was the applicant selected for the position?'),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 157, 178, 187),
                      ),
                      onPressed: () {
                        setState(() {
                          selectStatus = true;
                        });
                      },
                      child: const Text(
                        'Selected',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(width: screenHeight * 0.01),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectStatus = false;
                        });
                      },
                      child: const Text(
                        'Not Selected',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Flexible(
                  fit: FlexFit.loose,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Feedback',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onChanged: (value) {
                      feedback = value;
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 143, 255, 120),
                  ),
                  onPressed: _submitFeedback,
                  child: const Text(
                    'Submit Feedback',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            isActive: currentStep >= 2,
            state: currentStep >= 2 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
    );
  }

  void _submitFeedback() async {
    try {
      await firebaseService!.interViewProgressCollection.doc().set({
        'applicantId': widget.applicantId,
        'vacancyId': widget.vacancyId,
        'application_received': applicationReceived,
        'initial_interview_passed': initialInterviewPassed,
        'select_Status': selectStatus,
        'feedback': feedback,
        'providerId': firebaseService?.uid,
        'submitted_date': DateTime.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted Successfully!'),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting feedback: $e'),
        ),
      );
    }
  }
}
