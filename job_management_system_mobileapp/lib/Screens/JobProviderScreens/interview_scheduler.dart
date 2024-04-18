import "package:flutter/material.dart";
import "package:job_management_system_mobileapp/localization/demo_localization.dart";

class InterviewScheduler extends StatefulWidget {
  const InterviewScheduler({super.key});

  @override
  State<InterviewScheduler> createState() => _InterviewSchedulerState();
}

class _InterviewSchedulerState extends State<InterviewScheduler> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Interview Scheduler",
          style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth! * 0.04,
              fontWeight: FontWeight.bold),
        ), // Set the title of the app bar
        backgroundColor: const Color.fromARGB(255, 255, 136, 0),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            child: Column(
              children: [
                //input field for topic
                TextField(
                  decoration: InputDecoration(
                    labelText: "Topic",
                    hintText: "HR Interview",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                //input field for description
                TextFormField(
                  minLines: 3,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "give a brief description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                //add participants
              ],
            ),
          ),
        ),
      ),
    );
  }
}
