import 'package:flutter/material.dart';
import 'course_settings_screen.dart';
import 'units_screen.dart';

class CourseScreen extends StatelessWidget {

  late final String courseName;
  late final String courseCode;
  late final String imageUrl;

  CourseScreen({
    required this.courseName,
    required this.courseCode,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          children: [
            CourseSettingsScreen(courseName: courseName, courseCode: courseCode, imageUrl: imageUrl,),
            UnitsScreen(courseCode: courseCode,),
          ],
        ),
      ),
    );
  }
}
