import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:uuid/uuid.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchUploadedCVs();
  }

  // Function to fetch the list of uploaded CVs
  Future<void> _fetchUploadedCVs() async {
    try {
      final ListResult result = await FirebaseStorage.instance
          .ref('CVs/${widget.userId}')
          .listAll();
      List<String> fileNames = result.items.map((Reference ref) => ref.name).toList();
      setState(() {
        _uploadedCVs = fileNames;
      });
    } catch (e) {
      print('Error fetching uploaded CVs: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File selection canceled.'),
        ),
      );
    }
  }

  // Function to upload the selected file to Firebase Storage
  Future<void> _uploadFile() async {
    if (_file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a file first.'),
        ),
      );
      return;
    }

    try {
      // Generate a unique filename using UUID
      String fileName = '${Uuid().v4()}.pdf'; // Example: '123e4567-e89b-12d3-a456-426614174000.pdf'

      // Create a reference to the file location
      Reference ref = FirebaseStorage.instance
          .ref('CVs/${widget.userId}/$fileName');

      // Start the file upload
      UploadTask uploadTask = ref.putFile(_file!);

      // Listen to the upload task events
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      // Wait for the upload to complete
      await uploadTask;

      // Show success alert
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'CV uploaded successfully',
        text: 'Your CV has been uploaded successfully.',
      );

      // Refresh the list of uploaded CVs
      _fetchUploadedCVs();
    } catch (e) {
      print('Error uploading CV: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload CV.'),
        ),
      );
    } finally {
      setState(() {
        _uploadProgress = 0.0; // Reset the progress indicator
      });
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
        SnackBar(
          content: Text('Failed to delete CV.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload CV'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.grey[200],
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: _selectFile,
                  child: Text('Select File'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadFile,
                  child: Text('Upload CV'),
                ),
                SizedBox(height: 20),
                _uploadProgress > 0
                    ? Column(
                        children: [
                          Text('Uploading: ${(_uploadProgress * 100).toStringAsFixed(2)}%'),
                          SizedBox(height: 10),
                          LinearProgressIndicator(value: _uploadProgress),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.grey[300],
            child: Column(
              children: <Widget>[
                Text('Uploaded CVs:'),
                SizedBox(height: 10),
                _uploadedCVs.isEmpty
                    ? Text('No CVs uploaded.')
                    : Container(
                        height: 200, // Fixed height for the list
                        child: ListView.builder(
                          itemCount: _uploadedCVs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_uploadedCVs[index]),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteCV(_uploadedCVs[index]),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
