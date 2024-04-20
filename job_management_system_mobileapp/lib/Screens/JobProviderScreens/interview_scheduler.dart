import "package:board_datetime_picker/board_datetime_picker.dart";
import "package:flutter/material.dart";
import "package:job_management_system_mobileapp/localization/demo_localization.dart";
import "package:job_management_system_mobileapp/services/firebase_services.dart";
import "package:quickalert/models/quickalert_type.dart";
import "package:quickalert/widgets/quickalert_dialog.dart";

class InterviewScheduler extends StatefulWidget {
  InterviewScheduler({super.key});

  final FirebaseService _firebaseService = FirebaseService();

  @override
  State<InterviewScheduler> createState() => _InterviewSchedulerState();
}

class _InterviewSchedulerState extends State<InterviewScheduler> {
  String groupValue = "Online";

  DateTime _selectedDateTime = DateTime.now();

  void _chooseDateTime() async {
    final result = await showBoardDateTimePicker(
      context: context,
      pickerType: DateTimePickerType.datetime,
      initialDate: _selectedDateTime,
      options: BoardDateTimeOptions(
        languages: const BoardPickerLanguages(
          today: 'Today',
          tomorrow: 'Tomorrow',
          now: 'Now',
        ),
        startDayOfWeek: DateTime.monday,
        pickerFormat: PickerFormat.ymd,
        activeColor: Colors.blue.shade200,
        backgroundDecoration: const BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _selectedDateTime = result;
      });
    }
  }

  void showAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
    );
  }

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
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: "Add Participants",
                    hintText: "Select Participants",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Participant 1",
                      child: Text("Participant 1"),
                    ),
                    DropdownMenuItem(
                      value: "Participant 2",
                      child: Text("Participant 2"),
                    ),
                    DropdownMenuItem(
                      value: "Participant 3",
                      child: Text("Participant 3"),
                    ),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20.0),
                // select iterview type
                Row(
                  children: [
                    Radio(
                      value: "Online",
                      groupValue: groupValue,
                      onChanged: (value) {
                        setState(
                          () {
                            groupValue = value!;
                          },
                        );
                      },
                    ),
                    const Text(
                      "Online",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 30.0),
                    Radio(
                      value: "Physical",
                      groupValue: groupValue,
                      onChanged: (value) {
                        setState(
                          () {
                            groupValue = value!;
                          },
                        );
                      },
                    ),
                    const Text(
                      "Physical",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                //date and time pickers
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _chooseDateTime,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          "Select Date and Time",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    /*Text(
                        _selectedDateTime.toString(),
                        ),*/
                  ],
                ),
                const SizedBox(height: 80.0),
                ElevatedButton(
                  onPressed: () {
                    showAlert();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
