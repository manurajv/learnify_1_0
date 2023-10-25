import 'package:flutter/material.dart';
import 'package:learnify_1_0/units_screen.dart';

class CourseSettingsScreen extends StatelessWidget {
  final String courseName;
  final String courseCode;
  final String imageUrl;

  CourseSettingsScreen({
    required this.courseName,
    required this.courseCode,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Use courseName and courseCode in this screen as needed
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Settings'),
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 0.8,
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0), // Add some padding
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
                  Container(
                    child: Image.network(
                      imageUrl, // Display the image using the provided imageUrl
                      fit: BoxFit.cover, // Adjust the fit based on your design
                    ),
                    height: 140,
                  ),

                  Container(
                    child: Text(
                      'Course Name: $courseName',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      'Course Code: $courseCode',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle adding a new unit here
                      // You can open a dialog or navigate to a new screen to add a unit
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UnitsScreen(courseCode: courseCode,)));
                    },
                    child: Text('Add Unit'),
                  ),
                  // Other course settings widgets go here
                ],
              ),
            ),
          ),
          // Add more course settings here if needed
        ],
      ),
    );
  }
}
