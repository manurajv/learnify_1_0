import 'package:flutter/material.dart';
import 'course_card.dart';
import 'course_model.dart';

class CourseExploreTab extends StatelessWidget {
  final List<String> courseCategories = [
    'Programming',
    'Design',
    'Business',
    'Marketing',
    'Health',
  ];

  // Dummy course data (you can replace this with data from your database)
  final List<Course> courses = [
    Course(
      courseName: 'Introduction to Flutter',
      courseCode: 'a1000001',
      instructor: 'John Doe',
      imageUrl: 'https://subzfresh.com/wp-content/uploads/2022/04/apple_158989157.jpg',
      rating: 4.5,
    ),
    Course(
      courseName: 'UI Design Basics',
      courseCode: 'b1000001',
      instructor: 'Jane Smith',
      imageUrl: 'https://subzfresh.com/wp-content/uploads/2022/04/apple_158989157.jpg',
      rating: 4.2,
    ),
    // Add more courses
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Explore'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Course Categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (String category in courseCategories)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Chip(
                        label: Text(category),
                        // Implement onTap for category filtering
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Course List
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return CourseCard(course: courses[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
