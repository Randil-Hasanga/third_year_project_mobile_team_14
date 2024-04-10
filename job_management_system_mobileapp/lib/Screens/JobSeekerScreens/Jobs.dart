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
  List<String> jobs = [
    'Job Position: Software Engineer\nCompany Name: Tech Innovations Inc\nLocation: Colombo\nSalary: 90,000/= 120,000/= per month\nDescription: Join our team to develop cutting-edge software solutions for our clients. You\'ll be responsible for designing, implementing, and maintaining software applications to meet customer needs.',
    'Job Position: Data Analyst\nCompany Name:Virtusa\nLocation: Colombo\nSalary: 90,000/= - 120,000/= per month\nDescription: Join our team to analyze and interpret complex data sets. You\'ll be responsible for gathering, processing, and analyzing data to provide valuable insights and recommendations to our clients',

    'Job Position: Web Developer\nCompany Name: LankaTech Solutions Pvt Ltd\nLocation: Colombo\nSalary: LKR 90,000 - LKR 120,000 per month\nDescription: Join our team to develop cutting-edge web applications for our clients. You\'ll be responsible for designing, implementing, and maintaining websites and web-based applications to meet customer needs.',
    'Job Position: Sales Executive\nCompany Name: SalesSri Lanka Pvt Ltd\nLocation: Galle\nSalary: LKR 90,000 - LKR 120,000 per month\nDescription: Join our team to drive sales and revenue growth. You\'ll be responsible for prospecting new clients, negotiating contracts, and maintaining relationships with existing customers to achieve sales targets.',
    'Job Position: Graphic Designer\nCompany Name: DesignSri Lanka Pvt Ltd\nLocation: Colombo\nSalary: LKR 90,000 - LKR 120,000 per month\nDescription: Join our team to create visually appealing graphics and artworks. You\ll be responsible for designing marketing materials, branding assets, and multimedia content to support our business objectives.',
    
    'Job Position:UI/UX Designer\nCompany Name: IFS\nLocation: Galle\n',
    'Job Position:Marketing Manager\nCompany Name:Code Alpha\nLocation:Colombo\n',
    'Job Position:Project Manager\nCompany Name:SalesSri Lanka Pvt Ltd\nLocation: Ratnapura\n',
    'Job Position:Accountant\nCompany Name:SupportSri Lanka Pvt Ltd\nLocation:Kegalle\n',
    'Job Position:HR Specialist\nCompany Name:HR Solutions Lanka Pvt Ltd\nLocation: Kandy\n',
    'Job Position:Customer Support\nCompany Name:FinanceSri Lanka Pvt Ltd\nLocation: Nugegoda\n',
    'Job Position:Content Writer\nCompany Name:Code Alpha\nLocation: Embilipitiya\n',
    'Job Position:Network Engineer\nCompany Name:Code Alpha\nLocation: Eheliyagoda\n',
    'Job Position:Business Analyst\nCompany Name:MarketSri Lanka Pvt Ltd\nLocation: Awissawella\n',
    'Job Position:Digital Marketer\nCompany Name:ProjectSri Lanka Pvt Ltd\nLocation: Jaffna\n',
  ];

  List<String> selectedFilters = [];
  TextEditingController searchController = TextEditingController();

  List<String> filteredJobs = [];


   double? _deviceWidth, _deviceHeight;        // for the responsiveness of the device

  @override
  void initState() {
    super.initState();
    filteredJobs.addAll(jobs);
  }

  @override
  Widget build(BuildContext context) {


     //responsiveness of the device
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
        backgroundColor:  Colors.orange.shade800,
        title: const Text(
    'Find Your Job Here',
    style: TextStyle(
      color: Color.fromARGB(255, 248, 248, 248), // Add the desired color here
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
                icon: const Icon(Icons.home,color: Colors.white,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const JobSeekerPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings,color: Colors.white,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications,color: Colors.white,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const NotificationsJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat,color: Colors.white,),
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
                  }else if (index == 4) {
                    filterLabel = 'Mobile App';
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
                    backgroundColor: selectedFilters.contains(filterLabel) ? Colors.orange : const Color.fromARGB(255, 240, 236, 236),
                    checkmarkColor: const Color.fromARGB(255, 1, 114, 5),
                    labelStyle: TextStyle(color: selectedFilters.contains(filterLabel) ? const Color.fromARGB(255, 107, 44, 44) : Colors.black),
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
