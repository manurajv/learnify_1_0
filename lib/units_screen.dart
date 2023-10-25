import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  String unitName = '';
  String unitDescription = '';
  String pptUrl = '';
  String videoUrl = '';
  String unitTestUrl = '';

  // Reference to the Firestore instance.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to save unit details to Firestore.
  Future<void> saveUnitDetailsToFirestore() async {

    final user = _auth.currentUser;
    final uid = user?.uid;

    try {
      // Create a Firestore document reference with an auto-generated ID.
      DocumentReference unitRef = _firestore
          .collection('courses')
          .doc(uid)
          .collection(widget.courseCode)
          .doc()
          .collection('Units').doc();


      // Define the unit data you want to save.
      Map<String, dynamic> unitData = {
        'unitName': unitName,
        'unitDescription': unitDescription,
        'pptUrl': pptUrl,
        'videoUrl': videoUrl,
        'unitTestUrl': unitTestUrl,
      };

      // Set the unit data in the Firestore document.
      await unitRef.set(unitData);

      // Show a success message or navigate back to the UnitsScreen.
    } catch (e) {
      // Handle any errors that occur during the save operation.
      print('Error saving unit details: $e');
      // You can display an error message or handle the error as needed.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Unit'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Unit Name'),
            onChanged: (value) {
              setState(() {
                unitName = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Unit Description'),
            onChanged: (value) {
              setState(() {
                unitDescription = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Upload PPTs to Firebase Storage.
            },
            child: Text('Upload PPTs'),
          ),
          ElevatedButton(
            onPressed: () {
              // Upload videos to Firebase Storage.
            },
            child: Text('Upload Videos'),
          ),
          ElevatedButton(
            onPressed: () {
              // Upload unit tests to Firebase Storage.
            },
            child: Text('Upload Unit Test'),
          ),
          ElevatedButton(
            onPressed: () {
              // Save unit details to Firestore when the button is pressed.
              saveUnitDetailsToFirestore();
            },
            child: Text('Add Unit'),
          ),
        ],
      ),
    );
  }
}
