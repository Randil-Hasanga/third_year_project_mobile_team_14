import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/Chattings.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';

class Jobs extends StatefulWidget {
  const Jobs({Key? key}) : super(key: key);

  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  List<String> jobs = [
    'Job Position: Software Engineer\nCompany Name: Tech Innovations Inc\nLocation: Colombo\nSalary: 90,000/= 120,000/= per month\nDescription: Join our team to develop cutting-edge software solutions for our clients. You\'ll be responsible for designing, implementing, and maintaining software applications to meet customer needs.',
    'Job Position: Data Analyst\nCompany Name:Virtusa\nLocation: Colombo\nSalary: 90,000/= - 120,000/= per month\nDescription: Join our team to analyze and interpret complex data sets. You\'ll be responsible for gathering, processing, and analyzing data to provide valuable insights and recommendations to our clients',

    'Job Position: Web Developer\nCompany Name: LankaTech Solutions Pvt Ltd\nLocation: Colombo\nSalary: LKR 90,000 - LKR 120,000 per month\nDescription: Join our team to develop cutting-edge web applications for our clients. You\'ll be responsible for designing, implementing, and maintaining websites and web-based applications to meet customer needs.',

    'UI/UX Designer',
    'Marketing Manager',
    'Project Manager',
    'Accountant',
    'HR Specialist',
    'Customer Support',
    'Job Position: Sales Executive\nCompany Name: SalesSri Lanka Pvt Ltd\nLocation: Galle\nSalary: LKR 90,000 - LKR 120,000 per month\nDescription: Join our team to drive sales and revenue growth. You\'ll be responsible for prospecting new clients, negotiating contracts, and maintaining relationships with existing customers to achieve sales targets.',
    'Job Position: Graphic Designer\nCompany Name: DesignSri Lanka Pvt Ltd\nLocation: Colombo\nSalary: LKR 90,000 - LKR 120,000 per month\nDescription: Join our team to create visually appealing graphics and artworks. You\ll be responsible for designing marketing materials, branding assets, and multimedia content to support our business objectives.',
    'Content Writer',
    'Network Engineer',
    'Business Analyst',
    'Digital Marketer',
  ];

  List<String> selectedFilters = [];
  TextEditingController searchController = TextEditingController();

  List<String> filteredJobs = [];

  @override
  void initState() {
    super.initState();
    filteredJobs.addAll(jobs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 136, 0),
        title: const Text('Jobs'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 255, 153, 0),
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const JobSeekerPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfileJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const NotificationsJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const Chattings()));
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
                fillColor: const Color.fromARGB(255, 255, 255, 255),
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
                    backgroundColor: selectedFilters.contains(filterLabel) ? Colors.orange : Colors.grey.shade300,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(color: selectedFilters.contains(filterLabel) ? Colors.white : Colors.black),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: filteredJobs.isEmpty
                ? const Center(
                    child: Text('Not Found'),
                  )
                : ListView.builder(
                    itemCount: filteredJobs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 3.0,
                        child: Padding(
                          padding: const
EdgeInsets.all(20.0),
                    child: Text(filteredJobs[index]),
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
      filteredJobs.clear();
      for (String job in jobs) {
        if (job.toLowerCase().contains(query.toLowerCase()) && _passesFilter(job)) {
          filteredJobs.add(job);
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
