import 'package:flutter/material.dart';
import 'course_slideshow.dart';
import 'home_top_image.dart';

class HomeTabE extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: ListView(
        children: [
          TopImage(),
          SizedBox(height: 20),
          CourseSlideshow(),
        ],
      ),
    );
  }
}
