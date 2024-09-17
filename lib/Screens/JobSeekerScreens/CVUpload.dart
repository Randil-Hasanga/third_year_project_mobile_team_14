import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/NotificationsJobSeeker.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/seeker_chat_home.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';
import 'package:path_provider/path_provider.dart';

class CVUpload extends StatefulWidget {
  final String userId;

  CVUpload({required this.userId});

  @override
  _CVUploadState createState() => _CVUploadState();
}

class _CVUploadState extends State<CVUpload> {
  File? _file; // Variable to hold the selected file
  List<String> _uploadedCVs = []; // List to hold the names of uploaded CVs
  double _uploadProgress = 0.0; // Variable to track the upload progress
  bool _isUploadComplete = false; // Variable to track upload completion

  @override
  void initState() {
    super.initState();
    _fetchUploadedCVs();
  }

  Future<void> _fetchUploadedCVs() async {
    try {
      final ListResult result =
          await FirebaseStorage.instance.ref('CVs/${widget.userId}').listAll();
      List<String> fileNames = result.items.map((ref) => ref.name).toList();
      setState(() {
        _uploadedCVs = fileNames;
      });
    } catch (e) {
      print('Error fetching uploaded CVs: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch uploaded CVs.'),
        ),
      );
    }
  }

  // Function to select a file using file_picker package
  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Specify allowed extensions
    );

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
      // Show success message
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Successfully selected',
        text: 'Next, upload your CV',
      );
    } else {
      // User canceled the picker or selection failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File selection failed. Please try again.'),
        ),
      );
      // Show failure message
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'File selection failed',
        text: 'Please try selecting the file again.',
      );
    }
  }

  // Function to upload the selected file to Firebase Storage
  Future<void> _uploadFile() async {
    if (_file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a file first.'),
        ),
      );
      return;
    }

    try {
      // Generate a unique filename using UUID
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String fileName = '$uid.pdf';

      // Create a reference to the file location
      Reference ref = FirebaseStorage.instance.ref('CVs/$fileName');

      // Start the file upload
      UploadTask uploadTask = ref.putFile(_file!);

      // Listen to the upload task events
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.success) {
          String downloadUrl = await snapshot.ref.getDownloadURL();
          CollectionReference users =
              FirebaseFirestore.instance.collection('users');
          await users.doc(uid).update({'cv': downloadUrl});
        }

        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      // Wait for the upload to complete
      await uploadTask;

      // Update state to show upload completion message
      setState(() {
        _uploadProgress = 0.0; // Reset the progress indicator
        _isUploadComplete = true;
      });

      // Show success alert
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: 'Your CV is successfully uploaded.',
      );
    } catch (e) {
      print('Error uploading CV: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to upload CV.'),
        ),
      );
    }
  }

  // Function to delete the CV from Firebase Storage
  Future<void> _deleteCV(String fileName) async {
    try {
      // Delete file from Firebase Storage
      await FirebaseStorage.instance
          .ref('CVs/${widget.userId}/$fileName')
          .delete();

      // Show success alert
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'CV deleted successfully',
        text: 'Your CV has been deleted successfully.',
      );

      // Refresh the list of uploaded CVs
      _fetchUploadedCVs();
    } catch (e) {
      print('Error deleting CV: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete CV.'),
        ),
      );
    }
  }

  // Function to view the uploaded PDF file
  Future<void> _viewPDF(String fileName) async {
    try {
      // Get the download URL from Firebase Storage
      String downloadURL = await FirebaseStorage.instance
          .ref('CVs/${widget.userId}/$fileName')
          .getDownloadURL();

      // Download the file to a temporary directory
      final response = await HttpClient().getUrl(Uri.parse(downloadURL));
      final fileStream = await response.close();
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      final fileSink = file.openWrite();
      await fileStream.pipe(fileSink);
      await fileSink.flush();
      await fileSink.close();

      // Navigate to PDF viewer using flutter_pdfview package
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('View PDF'),
            ),
            body: PDFView(
              filePath: filePath,
            ),
          ),
        ),
      );
    } catch (e) {
      print('Error viewing PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to view PDF.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload your CV'),
        backgroundColor: Colors.orange.shade800,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[200],
              child: Column(
                children: <Widget>[
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _selectFile,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Select File',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadFile,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Upload CV',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _uploadProgress > 0 && _uploadProgress < 1
                      ? Column(
                          children: [
                            Text(
                                'Uploading: ${(_uploadProgress * 100).toStringAsFixed(2)}%'),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(value: _uploadProgress),
                          ],
                        )
                      : _isUploadComplete
                          ? const Text(
                              'CV upload Successfully',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 224, 147, 31)),
                            )
                          : Container(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width *
                      0.9, // Constrain width to avoid overflow
                ),
                child: const Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8, // Space between icon and text
                  children: <Widget>[
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange,
                      size: 24, // Adjust the size of the icon as needed
                    ),
                    Text(
                      'Please note that this uploaded CV is applied to the vacancies.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                      ),
                      softWrap: true, // Allows the text to wrap if necessary
                    ),
                  ],
                ),
              ),
            )
          ],
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
                icon: const Icon(Icons.home,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const JobSeekerPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.event,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const NotificationsJobSeeker()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SeekerChatHome()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
