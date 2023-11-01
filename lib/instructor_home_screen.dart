import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import 'course_model.dart';
import 'course_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'login_screen.dart';

class InstructorHomeScreen extends StatefulWidget {
  const InstructorHomeScreen({super.key});

  @override
  _InstructorHomeScreenState createState() => _InstructorHomeScreenState();
}

class _InstructorHomeScreenState extends State<InstructorHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseCodeController = TextEditingController();
  XFile? selectedImage; // This variable will hold the selected image file.
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool isLoggedIn = true;

  DocumentSnapshot? _selectedCourses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructor Homepage'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Add your logout logic here
              _signOut(context);
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _startNewCourse(context); // Call the method to show the dialog
            },
            child: Text('Start a New Course'),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: StreamBuilder<QuerySnapshot>(
                stream:
                FirebaseFirestore.instance.collection(
                    'courses_metadata').snapshots(),
                builder: (context, snapshot){
                  if(snapshot.hasData)
                  {
                    final List<DocumentSnapshot> documents = snapshot.data!.docs;

                    if(documents.isNotEmpty)
                    {
                      return GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 0.8,
                      ),
                        children: documents.map((doc) => _gridViewItemContainer(doc, context)).toList(),
                      );
                    }
                    else
                    {
                      return Center(
                        child: Container(
                          child: Text('No courses !!!!!!!!!!!!!!'),
                        ),
                      );
                    }
                  }
                  else
                  {
                    return Center(
                      child: Container(
                        child: Text('No courses'),
                      ),
                    );
                  }
                },
              ),
             ),
          ),
        ],
      ),
    );
  }

  Widget _gridViewItemContainer(DocumentSnapshot doc, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseScreen(
              courseName: doc['courseName'],
              courseCode: doc['courseCode'],
              imageUrl: doc['imageUrl'],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: 16), // Add spacing
            Container(
              child: Image.network(doc['imageUrl']
                  ?? 'https://5.imimg.com/data5/SELLER/Default/2021/8/YN/SE/FV/72826034/red-apple.jpg',
                  fit: BoxFit.cover,
              ),
              height: 140,
            ),
            SizedBox(height: 10), // Add spacing
            Container(
              child: Text(
                doc['courseName'],
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              child: Text(
                doc['courseCode'],
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startNewCourse(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Start a New Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final XFile? image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );

                  if (image != null) {
                    setState(() {
                      selectedImage = image;
                    });
                  }
                },
                child: Text('Select Image'),
              ),
              TextField(
                controller: _courseNameController,
                decoration: InputDecoration(labelText: 'Course Name'),
              ),
              TextField(
                controller: _courseCodeController,
                decoration: InputDecoration(labelText: 'Course Code'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Get the current user
                final user = _auth.currentUser;

                if (user != null) {
                  final uid = user.uid;
                  final courseName = _courseNameController.text;
                  final courseCode = _courseCodeController.text;
                  String? imageUrl;

                  if (selectedImage != null) {
                    final imageFile = File(selectedImage!.path);

                    // Upload the image to Firebase Storage
                    final storageRef = _storage.ref().child('course_images/$uid/$courseCode.jpg');
                    await storageRef.putFile(imageFile);

                    // Get the URL of the uploaded image
                    imageUrl = await storageRef.getDownloadURL();
                  }

                  // Create a new course document with the entered data and the image URL
                  await FirebaseFirestore.instance
                      .collection('courses')
                      .doc(uid) // Use the instructor's UID as the document ID
                      .collection(courseCode)
                      .add({
                    'courseName': courseName,
                    'courseCode': courseCode,
                    'imageUrl': imageUrl, // Add the image URL
                  });

                  await FirebaseFirestore.instance
                      .collection('courses_metadata')
                      .doc(courseCode)
                      .set({
                    'instructorUid': uid,
                    'courseName': courseName,
                    'courseCode': courseCode,
                    'imageUrl': imageUrl, // Add the image URL
                  });

                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseScreen(
                        courseName: courseName,
                        courseCode: courseCode,
                        imageUrl: imageUrl!, // Pass the image URL to CourseScreen
                      ),
                    ),
                  );
                }
              },
              child: Text('Create Course'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Update the login status
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('loggedIn', false);

      setState(() {
        isLoggedIn = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );

    } catch (e) {
      print('Error during logout: $e');
    }
  }

}
