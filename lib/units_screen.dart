import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnify_1_0/unit_test_screen.dart';
import 'firebase_service.dart';


class UnitsScreen extends StatefulWidget {
  final String courseCode;

  UnitsScreen({
    required this.courseCode,
  });

  @override
  _UnitsScreenState createState() => _UnitsScreenState();

}

class _UnitsScreenState extends State<UnitsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseService _firebaseService = FirebaseService.instance;
  final TextEditingController _unitNameController = TextEditingController();
  final TextEditingController _unitDesController = TextEditingController();


  String unitName = '';
  String unitDescription = '';
  String pptUrl = '';
  String videoUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Unit'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: _unitNameController,
            decoration: InputDecoration(labelText: 'Unit Name'),
            onChanged: (value) {
              setState(() {
                unitName = value;
              });
            },
          ),
          TextField(
            controller: _unitDesController,
            decoration: InputDecoration(labelText: 'Unit Description'),
            onChanged: (value) {
              setState(() {
                unitDescription = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () async {
              // Upload PPTs to Firebase Storage.
              File? pptFile = await _pickPPTFile();
              String? pptUrl = await _firebaseService.uploadPPT(pptFile!);

              if (pptUrl != null) {
                // Successfully uploaded. Use the URL as needed.
                setState(() {
                  this.pptUrl = pptUrl;
                });
              } else {
                // Handle the error.
              }
            },
            child: Text('Upload PPTs'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Upload videos to Firebase Storage.
              File? videoFile = await _pickVideoFile();
              String? videoUrl = await _firebaseService.uploadVideo(videoFile!);

              if (videoUrl != null) {
                setState(() {
                  this.videoUrl = videoUrl;
                });
              } else {
                // Handle the error.
              }
            },
            child: Text('Upload Video'),
          ),
          Container(
            child: Text(
              'To proceed with the submission, it is essential to include at least one unit test question. '
                  'Kindly click the button below to add questions to your unit and finalize the process.',
              style: TextStyle(
                fontSize: 10,
                color: Colors.blue,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Upload unit tests to Firebase Storage.
              Navigator.push(context, MaterialPageRoute(builder: (context) => UnitTestScreen(
                courseCode: widget.courseCode,
                saveUnitDetailsToFirestoreCallback: saveUnitDetailsToFirestore,
                ),
              ),);
            },
            child: Text('Upload Unit Test'),
          ),
          ElevatedButton(
            onPressed: () {
              clearInputFields();
            },
            child: Text('Reset Fields'),
          ),
        ],
      ),
    );
  }

  Future<void> saveUnitDetailsToFirestore() async {
    final user = _auth.currentUser;
    final uid = user?.uid;

    try {
      // Calculate the next unit ID based on existing subcollections
      String nextUnitId = await getNextUnitId(uid);

      // Create a Firestore document reference with the generated ID
      DocumentReference unitRef = _firestore
          .collection('courses')
          .doc(uid)
          .collection(widget.courseCode)
          .doc('Units')
          .collection('Units')
          .doc(nextUnitId);

      // Define the unit data you want to save.
      Map<String, dynamic> unitData = {
        'unitName': unitName,
        'unitDescription': unitDescription,
        'pptUrl': pptUrl,
        'videoUrl': videoUrl,
      };

      // Set the unit data in the Firestore document.
      await unitRef.set(unitData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unit uploaded successfully.'),
      ));
      // Clear input fields after successful upload
      clearInputFields();
    } catch (e) {
      // Handle any errors that occur during the save operation.
      print('Error saving unit details: $e');
    }
  }

  Future<String> getNextUnitId(String? uid) async {
    try {
      CollectionReference unitsCollection = _firestore
          .collection('courses')
          .doc(uid)
          .collection(widget.courseCode)
          .doc('Units')
          .collection('Units');

      // Get the list of subcollections under 'Units'
      QuerySnapshot unitCollections = await unitsCollection.get();

      int maxId = 0;

      // Loop through the subcollections to find the largest ID
      for (QueryDocumentSnapshot doc in unitCollections.docs) {
        int id = int.tryParse(doc.id) ?? 0;
        if (id > maxId) {
          maxId = id;
        }
      }

      // Calculate the next unit ID by incrementing the largest ID
      String nextIdString = (maxId + 1).toString().padLeft(3, '0');

      return nextIdString;
    } catch (e) {
      print('Error getting the next unit ID: $e');
      return '000'; // Default to '000' if there's an error
    }
  }

  void clearInputFields() {
    setState(() {
      _unitDesController.text = '';
      _unitNameController.text = '';
      unitName = '';
      unitDescription = '';
      pptUrl = '';
      videoUrl = '';
    });
  }

  Future<File?> _pickPPTFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ppt', 'pptx'],
    );

    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.first.path;
      if (filePath != null) {
        return File(filePath);
      } else {
        // Handle the case where the user didn't pick a file.
        return null; // You can return an empty File or handle the error accordingly.
      }
    }
  }

  Future<File?> _pickVideoFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false, // You can allow multiple video selections if needed.
    );

    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.first.path;
      if (filePath != null) {
        return File(filePath);
      } else {
        // Handle the case where the user didn't pick a file.
        return null; // You can return an empty File or handle the error accordingly.
      }
    } else {
      // Handle the case where the user canceled the file selection.
      return null;
    }
  }

}
