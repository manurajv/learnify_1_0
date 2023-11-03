import 'package:flutter/material.dart';
import 'course_model.dart';
import 'unitcontentpage.dart';


class CourseDetailsPage extends StatelessWidget {
  final Course course;

  // Add more relevant course data as needed

  CourseDetailsPage({
    required this.course,

    // Add more constructor parameters for other course data
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(course.courseName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen (CourseCatalog)
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course header section with image, title, and instructor name
            Container(
              // Add course image here
              height: 200,
              color: Colors.grey, // Replace with course image or use NetworkImage
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.all(16),
              // child: Text(
              //   course.instructor,
              //   style: TextStyle(color: Colors.white, fontSize: 18),
              // ),
            ),
            SizedBox(height: 16),

            // Course description section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              // child: Text(
              //   course.courseName,
              //   style: TextStyle(fontSize: 16),
              // ),
            ),
            SizedBox(height: 16),

            // Course syllabus section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Course Syllabus',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  //
                  // Add syllabus items here using ListView.builder or ListTile
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: course.units.length,
                    itemBuilder: (context, index) {
                      final unit = course.units[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UnitContentPage(
                                unitTitle: unit.unitTitle,
                                unitContent: unit.unitContent,
                                videoUrl: 'URL_to_unit_x_video.mp4', unitDescription: '', pptUrl: '',
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(unit.unitTitle),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Course enrollment options and CTA button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  // Handle course enrollment logic here
                },
                child: Text('Enroll in Course'),
              ),
            ),

            // Add more course details sections as needed, such as prerequisites, reviews, related courses, etc.
          ],
        ),
      ),

    );
  }
}


