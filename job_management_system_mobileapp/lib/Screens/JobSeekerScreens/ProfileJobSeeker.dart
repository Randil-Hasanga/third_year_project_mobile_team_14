import 'package:flutter/material.dart';

class ProfileJobSeeker extends StatefulWidget {
  // ignore: use_super_parameters
  const ProfileJobSeeker({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileJobSeekerState createState() => _ProfileJobSeekerState();
}

class _ProfileJobSeekerState extends State<ProfileJobSeeker> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variable to hold the selected image file
  // Add your logic to handle image selection and update this variable
  // You can use packages like image_picker to select images
  // File? _selectedImage;

  @override
  void dispose() {
    // Dispose the controllers to avoid memory leaks
    _usernameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String language) {
              // Handle language selection here
              switch (language) {
                case 'English':
                  // Change app language to English
                  break;
                case 'සිංහල':
                  // Change app language to Sinhala
                  break;
                case 'தமிழ்':
                  // Change app language to Tamil
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'English',
                child: Text('English'),
              ),
              const PopupMenuItem<String>(
                value: 'සිංහල',
                child: Text('සිංහල'),
              ),
              const PopupMenuItem<String>(
                value: 'தமிழ்',
                child: Text('தமிழ்'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            // Editable profile photo
            GestureDetector(
              onTap: () {
                // Add your logic to change the profile photo
                // For example:
                // _selectImage();
              },
              child: const CircleAvatar(
                radius: 50,
                // Use _selectedImage here if it's selected, otherwise use a placeholder
                // backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : AssetImage('assets/Default.png'),
                backgroundImage: AssetImage('assets/Default.png'),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Clear all text fields
                    _usernameController.clear();
                    _emailController.clear();
                    _phoneNumberController.clear();
                    _passwordController.clear();
                  },
                  child: const Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Submit the profile data
                    // You can access the data using the controller's text properties
                    // For example: _usernameController.text, _emailController.text, etc.
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
