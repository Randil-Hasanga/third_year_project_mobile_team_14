import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/updateVacancy.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';
import 'package:path/path.dart';

class VacancyTile extends StatelessWidget {
  final String vId;
  final String jobPosition;
  final String jobType;
  final String location;
  final double salary;
  final String description;
  VacancyTile(
      {super.key,
      required this.vId,
      required this.jobPosition,
      required this.jobType,
      required this.location,
      required this.salary,
      required this.description});

  FirebaseService? _firebaseService;

  @override
  Widget build(BuildContext context) {
    void showModelSheet() {
      showModalBottomSheet(
          context: context,
          builder: (context) => Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 16, 16),
                child: SizedBox(
                  child: Center(
                    child: Column(
                      children: [
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Job description",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: Text(description)),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 185, 120),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VacancyUpdaterUI(vacancyId: vId),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Update',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 40),
                            Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(context, vId);
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        showModelSheet();
      },
      child: Container(
        width: screenWidth! * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.work),
                const SizedBox(width: 10),
                Text(
                  jobPosition,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 10),
                Text(
                  jobType,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.location_pin),
                const SizedBox(width: 10),
                Text(
                  location,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.currency_exchange,
                ),
                const SizedBox(width: 10),
                Text(
                  "Rs.$salary",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String vacancyID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Vacancy'),
          content: const Text('Do you want to delete this vacancy?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _firebaseService?.deleteVacancy(vacancyID);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
