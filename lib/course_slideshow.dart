import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'course_model.dart';
import 'course_card.dart';

class CourseSlideshow extends StatelessWidget {
  // Dummy data for course cards. Replace this with your actual data.
  final List<Course> courses = [
    Course(courseName: 'Flutter Crash Course',courseCode: 'a1000001', instructor: 'John Doe', imageUrl: 'https://subzfresh.com/wp-content/uploads/2022/04/apple_158989157.jpg', rating: 6.8),
    Course(courseName: 'Dart Fundamentals',courseCode: 'a1000001', instructor: 'Jane Smith', imageUrl: 'https://subzfresh.com/wp-content/uploads/2022/04/apple_158989157.jpg', rating: 8.9),
    // Add more courses here
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Swiper(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return CourseCard(course: courses[index]);
        },
        pagination: SwiperPagination(), // Show dots at the bottom
        autoplay: true, // Auto-rotate slides
        autoplayDelay: 3000, // 3 seconds per slide
      ),
    );
  }
}
