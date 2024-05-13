import "package:board_datetime_picker/board_datetime_picker.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:job_management_system_mobileapp/Screens/JobSeekerPage.dart";
import "package:job_management_system_mobileapp/services/firebase_services.dart";
import "package:quickalert/models/quickalert_type.dart";
import "package:quickalert/widgets/quickalert_dialog.dart";

class InterviewScheduler extends StatefulWidget {
  InterviewScheduler({super.key});

  @override
  State<InterviewScheduler> createState() => _InterviewSchedulerState();
}

class _InterviewSchedulerState extends State<InterviewScheduler> {
  FirebaseService? firebaseSerice;

  String groupValue = "";
  bool showLinkFeild = false;
  final TextEditingController _linkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _descriptionController = TextEditingController();
  Map<String, dynamic>? _jobProviderDetails;

  String selectedvacancy = "0";
  String selectedvacancyName = 'Select vacancy';

  DateTime _selectedDateTime = DateTime.now();

  String? companyName;

  @override
  void initState() {
    super.initState();
    firebaseSerice = GetIt.instance.get<FirebaseService>();
    _getProvider();
  }

  void _getProvider() async {
    _jobProviderDetails = await firebaseSerice!.getCurrentProviderData();

    if (_jobProviderDetails != null) {
      setState(() {
        if (mounted) {
          companyName = _jobProviderDetails!['company_name'];
        }
      });
    }
  }

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

  void linkPopup() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      title: "Enter Link",
      text: "Please enter the link",
      confirmBtnText: "Continue",
      widget: TextFormField(
        controller: _linkController,
        decoration: InputDecoration(
          labelText: "Meeting Link",
          hintText: "https://meet.google.com/xyz-abc",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Select Vacancy:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 30.0),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('vacancy')
                          .where('uid', isEqualTo: firebaseSerice!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        List<DropdownMenuItem> vacancyItems = [];

                        if (!snapshot.hasData) {
                          const CircularProgressIndicator();
                        } else {
                          final Vacancies =
                              snapshot.data?.docs.reversed.toList();
                          vacancyItems.add(
                            const DropdownMenuItem(
                              value: "0",
                              child: Text('Select Vacancy'),
                            ),
                          );

                          for (var vacancy in Vacancies!) {
                            vacancyItems.add(
                              DropdownMenuItem(
                                value: vacancy.id,
                                child: Text(
                                  vacancy['job_position'],
                                ),
                              ),
                            );
                          }
                        }
                        return DropdownButton(
                          menuMaxHeight: screenWidth * 0.5,
                          items: vacancyItems,
                          onChanged: (vacancyValue) {
                            selectedvacancyName = vacancyItems
                                .firstWhere(
                                    (item) => item.value == vacancyValue)
                                .child
                                .toString();

                            selectedvacancy = vacancyValue;

                            print(vacancyValue);
                          },
                          value: selectedvacancy,
                          isExpanded: false,
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.02),
                //input field for topic
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter the topic";
                    }
                    return null;
                  },
                  controller: _topicController,
                  decoration: InputDecoration(
                    labelText: "Topic",
                    hintText: "HR Interview",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                //input field for description
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter description";
                    }
                    return null;
                  },
                  minLines: 3,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "give a brief description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // select interview type
                Row(
                  children: [
                    const Text(
                      "Type:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Radio(
                      value: "Online",
                      groupValue: groupValue,
                      onChanged: (value) {
                        setState(
                          () {
                            groupValue = value!;
                            showLinkFeild = true;
                            linkPopup();
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
                    SizedBox(width: screenWidth * 0.02),
                    Radio(
                      value: "Physical",
                      groupValue: groupValue,
                      onChanged: (value) {
                        setState(
                          () {
                            groupValue = value!;
                            showLinkFeild = false;
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
                    SizedBox(width: screenWidth * 0.02),
                    /*Text(
                      _selectedDateTime.toString(),
                    ),*/
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Selected Date and Time: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(_selectedDateTime.toString()),
                  ],
                ),

                SizedBox(height: screenHeight * 0.08),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      firebaseSerice?.addInterviewDetails(
                        companyName!,
                        selectedvacancy,
                        _topicController.text,
                        _descriptionController.text,
                        groupValue,
                        _linkController.text,
                        _selectedDateTime.toString(),
                      );
                      showAlert();

                      _topicController.clear();
                      _descriptionController.clear();
                      selectedvacancy = "0";
                      groupValue = "";
                      _linkController.clear();
                      _selectedDateTime = DateTime.now();
                    }
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
