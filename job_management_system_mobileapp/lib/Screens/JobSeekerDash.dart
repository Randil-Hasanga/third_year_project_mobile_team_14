import 'package:flutter/material.dart';

class JobSeekerDash extends StatelessWidget {
  const JobSeekerDash({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Seeker Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Add action to navigate to profile screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greet user
              const Text(
                'Hii User Name',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),

              // Search job section
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search job',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      // Add action for filter button
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Featured Jobs section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Featured Jobs',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add action to navigate to all featured jobs
                    },
                    child: const Text(
                      'see all..',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
              // Add scrolling buttons for featured jobs details here
              // Example: ListView.builder()

              const SizedBox(height: 20),

              // Recent Jobs section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Jobs',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add action to navigate to all recent jobs
                    },
                    child: const Text(
                      'see all..',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
              // Add list of recent jobs here
              // Example: ListView.builder()

            ],
          ),
        ),
      ),
  bottomNavigationBar: BottomAppBar(
  color: const Color.fromARGB(255, 221, 140, 10), // Set the background color to orange
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      IconButton(
        icon: const Icon(Icons.home, color: Colors.deepOrange), // Set the icon color to dark orange
        onPressed: () {
          // Add action to navigate to home screen
        },
      ),
      IconButton(
        icon: const Icon(Icons.settings, color: Colors.deepOrange), // Set the icon color to dark orange
        onPressed: () {
          // Add action to navigate to settings screen
        },
      ),
      IconButton(
        icon: const Icon(Icons.notifications, color: Colors.deepOrange), // Set the icon color to dark orange
        onPressed: () {
          // Add action to navigate to notifications screen
        },
      ),
      IconButton(
        icon: Icon(Icons.chat, color: Colors.deepOrange), // Set the icon color to dark orange
        onPressed: () {
          // Add action to navigate to chat screen
        },
      ),
    ],
  ),
  
),

    );
  }
}
