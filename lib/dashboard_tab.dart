import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'course.dart';

class DashboardTabE extends StatefulWidget {
  const DashboardTabE({Key? key}) : super(key: key);

  @override
  _DashboardTabEState createState() => _DashboardTabEState();
}

class _DashboardTabEState extends State<DashboardTabE> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<QuerySnapshot> _enrollments;

  @override
  void initState() {
    super.initState();
    _enrollments = _fetchEnrollments();
  }

  Future<QuerySnapshot> _fetchEnrollments() {
    return _firestore.collection('enrollments').doc(_auth.currentUser!.uid).collection('courses').get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _enrollments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle error
            return Text('An error occurred. Please check your data and permissions.');
          } else if (snapshot.hasData) {
            final courseCodes = snapshot.data!.docs.map((doc) => doc['courseCode'] as String).toList();

            if (courseCodes.isEmpty) {
              return Text('You have not enrolled in any courses.');
            }

            return ListView.builder(
              itemCount: courseCodes.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4, // Add shadow
                  margin: EdgeInsets.all(8), // Add margin for spacing
                  color: Colors.white, // Background color
                  child: ListTile(
                    title: Text(courseCodes[index]),
                    onTap: () {
                      // Handle tap gesture
                      _navigateToCourseScreen(context, courseCodes[index]);
                    },
                  ),
                );
              },
            );
          } else {
            return Text('No data available');
          }
        },
      ),
    );
  }

  void _navigateToCourseScreen(BuildContext context, String courseCode) {
    // Use the Navigator to push the CourseScreen and pass the courseCode
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Course(courseCode: courseCode),
      ),
    );
  }

}
