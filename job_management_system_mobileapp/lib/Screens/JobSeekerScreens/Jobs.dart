import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/Chattings.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';
import 'package:quickalert/quickalert.dart';

class Jobs extends StatefulWidget {
  const Jobs({Key? key}) : super(key: key);

  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  List<String> selectedFilters = [];
  TextEditingController searchController = TextEditingController();

  List<String> filteredSnapshot = []; // Declare the filteredSnapshot list here
  QuerySnapshot? snapshot; // Add a variable to store the original snapshot

  double? _deviceWidth, _deviceHeight;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('vacancy').get().then((value) {
      setState(() {
        snapshot = value;
        filteredSnapshot = value.docs.map((doc) {
          String companyName = doc['company_name'] as String;
          String jobPosition = doc['job_position'] as String;
          String location = doc['location'] as String;

          return 'Company Name: $companyName\nJob Position: $jobPosition\nLocation: $location';
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    void showAlert() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
        title: const Text(
          'Find Your Job Here',
          style: TextStyle(
            color: Color.fromARGB(
                255, 248, 248, 248), // Add the desired color here
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange.shade800,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const JobSeekerPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const NotificationsJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Chattings()));
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for jobs...',
                prefixIcon: const Icon(Icons.search, color: Colors.orange),
                filled: true,
                fillColor: Color.fromARGB(255, 231, 211, 181),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                filterJobs(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: List.generate(
                5,
                (index) {
                  String filterLabel = 'Filter ${index + 1}';
                  if (index == 0) {
                    filterLabel = 'Software Engineer';
                  } else if (index == 1) {
                    filterLabel = 'Web Developer';
                  } else if (index == 2) {
                    filterLabel = 'Data Analyst';
                  } else if (index == 3) {
                    filterLabel = 'UI/UX Designer';
                  } else if (index == 4) {
                    filterLabel = 'Network Engineer';
                  }
                  return FilterChip(
                    label: Text(filterLabel),
                    selected: selectedFilters.contains(filterLabel),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedFilters.add(filterLabel);
                        } else {
                          selectedFilters.remove(filterLabel);
                        }
                      });
                      filterJobs(searchController.text);
                    },
                    selectedColor: const Color.fromARGB(255, 236, 168, 84),
                    backgroundColor: selectedFilters.contains(filterLabel)
                        ? Colors.orange
                        : const Color.fromARGB(255, 240, 236, 236),
                    checkmarkColor: const Color.fromARGB(255, 1, 114, 5),
                    labelStyle: TextStyle(
                        color: selectedFilters.contains(filterLabel)
                            ? const Color.fromARGB(255, 107, 44, 44)
                            : Colors.black),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: filteredSnapshot.isEmpty
                ? Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: const Text(
                        'Not Found',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredSnapshot.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange
                              .shade100, // Set the desired background color
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(filteredSnapshot[index]),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void filterJobs(String query) {
    setState(() {
      filteredSnapshot.clear();
      if (snapshot != null) {
        for (var doc in snapshot!.docs) {
          String companyName = doc['company_name'] as String;
          String jobPosition = doc['job_position'] as String;
          String location = doc['location'] as String;

          String job =
              'Company Name: $companyName\nJob Position: $jobPosition\nLocation: $location';

          if (job.toLowerCase().contains(query.toLowerCase()) &&
              _passesFilter(job)) {
            filteredSnapshot.add(job);
          }
        }
      }
    });
  }

  bool _passesFilter(String job) {
    if (selectedFilters.isEmpty) {
      return true;
    }
    for (String filter in selectedFilters) {
      if (job.toLowerCase().contains(filter.toLowerCase())) {
        return true;
      }
    }
    return false;
  }
}
