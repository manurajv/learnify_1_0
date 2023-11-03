import 'package:flutter/material.dart';
import 'course_model.dart';
import 'course_details.dart';

class CourseCatalog extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Catalog'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // When the back button is pressed, navigate back to the LoginScreen
            Navigator.pop(context);
          },
        ),
      ),
      // body: ListView.builder(
      //   itemCount: courses.length,
      //   itemBuilder: (context, index) {
      //     return _buildCourseCard(context, courses[index]);
      //   },
      // ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        //leading: Icon(course.iconData, size: 40),
        //title: Text(course.courseName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(course.instructor), // Display instructor name
            // SizedBox(height: 8),
            // Text(course.courseName),
            // SizedBox(height: 8), // Add some spacing between the description and progress bar
            LinearProgressIndicator(
              //value: course.progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CourseDetailsPage(course: course)),
          );
          // Implement what should happen when the course card is tapped
          // For example, navigate to a detailed course page
        },
      ),
    );
  }

}

