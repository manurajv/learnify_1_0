import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:card_swiper/card_swiper.dart';
import 'course_model.dart';
import 'course_card.dart';
import 'course_information_screen.dart'; // Import the CourseInformationScreen

class CourseSlideshow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('courses_metadata').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Data is still loading
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Error occurred while fetching data
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

            if (documents.isNotEmpty) {
              return Swiper(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  return _gridViewItemContainer(documents[index], context);
                },
                pagination: SwiperPagination(), // Show dots at the bottom
                autoplay: true, // Auto-rotate slides
                autoplayDelay: 3000, // 3 seconds per slide
              );
            } else {
              return Center(
                child: Text('No courses available!'),
              );
            }
          } else {
            return Center(
              child: Text('No courses available'),
            );
          }
        },
      ),
    );
  }

  Widget _gridViewItemContainer(QueryDocumentSnapshot doc, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Use Navigator to navigate to the CourseInformationScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseInformationScreen(
              // Provide the necessary arguments
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
              child: Image.network(
                doc['imageUrl'] ??
                    'https://5.imimg.com/data5/SELLER/Default/2021/8/YN/SE/FV/72826034/red-apple.jpg',
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
}
