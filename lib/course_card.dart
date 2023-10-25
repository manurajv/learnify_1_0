import 'package:flutter/material.dart';
import 'course_model.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Handle tapping on a course card to navigate to the course details screen
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.network(
            //   course.imageUrl,
            //   width: double.infinity,
            //   height: 120,
            //   fit: BoxFit.cover,
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   course.courseName,
                  //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  // ),
                  SizedBox(height: 4),
                  Text('Instructor: ${course.instructor}'),
                  SizedBox(height: 4),
                  Text('Rating: ${course.rating}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
