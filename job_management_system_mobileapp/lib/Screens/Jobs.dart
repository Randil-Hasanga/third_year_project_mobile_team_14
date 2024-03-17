import 'package:flutter/material.dart';

class Jobs extends StatefulWidget {
  const Jobs({Key? key}) : super(key: key);

  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  List<String> jobs = [
    'Software Engineer',
    'Web Developer',
    'Data Analyst',
    'UI/UX Designer',
    'Marketing Manager',
    'Project Manager',
    'Accountant',
    'HR Specialist',
    'Customer Support',
    'Sales Executive',
    'Graphic Designer',
    'Content Writer',
    'Network Engineer',
    'Business Analyst',
    'Digital Marketer',
  ];

  List<String> selectedFilters = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text('Filter Jobs'),
              children: [
                Wrap(
                  spacing: 8.0,
                  children: List.generate(
                    5,
                    (index) => FilterChip(
                      label: Text('Filter ${index + 1}'),
                      selected: selectedFilters.contains('Filter ${index + 1}'),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedFilters.add('Filter ${index + 1}');
                          } else {
                            selectedFilters.remove('Filter ${index + 1}');
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: jobs.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 3.0,
                  child: Center(
                    child: Text(jobs[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
