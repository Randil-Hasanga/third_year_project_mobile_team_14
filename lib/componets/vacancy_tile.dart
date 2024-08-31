import 'package:flutter/material.dart';

class VacancyTile extends StatelessWidget {
  final String jobPosition;
  final String jobType;
  final String location;
  final double salary;
  const VacancyTile(
      {super.key,
      required this.jobPosition,
      required this.jobType,
      required this.location,
      required this.salary});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
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
                Text(jobPosition),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 10),
                Text(jobType)
              ],
            ),
            Row(
              children: [
                const Icon(Icons.location_pin),
                const SizedBox(width: 10),
                Text(location)
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.currency_exchange,
                ),
                const SizedBox(width: 10),
                Text("Rs.$salary")
              ],
            )
          ],
        ),
      ),
    );
  }
}
