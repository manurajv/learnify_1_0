import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseInformationScreen extends StatefulWidget {
  final String courseName;
  final String courseCode;
  final String imageUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CourseInformationScreen({
    required this.courseName,
    required this.courseCode,
    required this.imageUrl,
  });

  @override
  _CourseInformationScreenState createState() => _CourseInformationScreenState();
}

class _CourseInformationScreenState extends State<CourseInformationScreen> {
  String? instructorUid;

  Future<List<List<String>>> fetchUnitDetails() async {
    instructorUid = await getInstructorUID(widget.courseCode);
    return await getUnitsDetails(instructorUid!, widget.courseCode);
  }

  @override
  void initState() {
    super.initState();
    _fetchInstructorUid();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Course Code: ${widget.courseCode}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your enrollment logic here
                // This button will trigger enrollment.
                enrollStudent();

              },
              child: Text('Enroll'),
            ),
            FutureBuilder<List<List<String>>>(
              future: fetchUnitDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<List<String>> unitsDetailsArr1 = snapshot.data!;

                  return Container(
                    height: MediaQuery.of(context).size.height - 400,
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: unitsDetailsArr1.length,
                      itemBuilder: (context, index) {
                        List<String> unitDetails = unitsDetailsArr1[index];
                        int x = index + 1;

                        return Card(
                          child: ListTile(
                            title: Text('Unit $x'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (String detail in unitDetails) Text(detail),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Text('No data available');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<List<String>>> getUnitsDetails(String uid, String courseCode) async {
    List<List<String>> unitsDetailsArr = [];

    try {
      CollectionReference unitsCollection = widget._firestore
          .collection('courses')
          .doc(uid)
          .collection(courseCode)
          .doc('Units')
          .collection('Units');

      QuerySnapshot unitCollections = await unitsCollection.get();

      for (QueryDocumentSnapshot doc in unitCollections.docs) {
        DocumentReference unitRef = unitsCollection.doc(doc.id);

        DocumentSnapshot unitData = await unitRef.get();

        if (unitData.exists) {
          String unitName = unitData.get('unitName');
          String unitDescription = unitData.get('unitDescription');
          String pptUrl = unitData.get('pptUrl');
          String videoUrl = unitData.get('videoUrl');

          List<String> unitDetail = [
            'Unit Name: $unitName',
            'Unit Description: $unitDescription',
          ];

          unitsDetailsArr.add(unitDetail);
        }
      }

      return unitsDetailsArr;
    } catch (e) {
      print('Error getting unit details: $e');
      return [];
    }
  }

  Future<String?> getInstructorUID(String courseCode) async {
    try {
      DocumentSnapshot courseDoc = await widget._firestore
          .collection('courses_metadata')
          .doc(courseCode)
          .get();

      if (courseDoc.exists) {
        return courseDoc.get('instructorUid');
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting instructorUID: $e');
      return null;
    }
  }

  Future<void> _fetchInstructorUid() async {
    instructorUid = await getInstructorUID(widget.courseCode);
    setState(() {});
  }

  // Function to enroll a student in a course
  Future<void> enrollStudent() async {
    try {
      // Get the user's UID
      String userUid = widget._auth.currentUser!.uid;
      String courseCode = widget.courseCode;

      // Create a reference to the student's subcollection for enrollments
      CollectionReference studentEnrollments = widget._firestore.collection('enrollments').doc(userUid).collection('courses');

      // Check if the student is already enrolled in the specified course
      QuerySnapshot existingEnrollments = await studentEnrollments.where('courseCode', isEqualTo: courseCode).get();

      if (existingEnrollments.docs.isNotEmpty) {
        // User is already enrolled in the course
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Already Enrolled!'),
              content: Text('You are already enrolled in this course.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        print('You are already enrolled in this course.');
      } else {
        // User is not enrolled, proceed with enrollment.

        // Create a data map with the enrollment information
        Map<String, dynamic> enrollmentData = {
          'courseCode': courseCode,
          // You can add more details to the enrollment data as needed.
        };

        // Add the enrollment data to the student's subcollection
        await studentEnrollments.add(enrollmentData);

        // Show a success message or navigate to a different screen
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Enrollment successful!'),
              content: Text('Enrollment successful! You are now enrolled in the course.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        print('Enrollment successful! You are now enrolled in the course.');
      }
    } catch (e) {
      // Handle any errors that occur during the enrollment process
      print('Error enrolling in the course: $e');
    }
  }


  Future<bool> checkEnrollment() async {
    try {
      // Get the current user's UID
      String userUid = widget._auth.currentUser!.uid;
      String courseCode = widget.courseCode;

      // Check if there is an enrollment document for the user in the 'enrollments' collection
      DocumentSnapshot enrollmentDoc = await widget._firestore.collection('enrollments').doc(userUid).get();

      if (enrollmentDoc.exists) {
        // Check if the user is enrolled in the specified course
        Map<String, dynamic>? data = enrollmentDoc.data() as Map<String, dynamic>?;
        if (data != null && data['courseCode'] == courseCode) {
          // User is already enrolled in the course
          return true;
        }
      }

      // User is not enrolled in the course
      return false;
    } catch (e) {
      print('Error checking enrollment: $e');
      return false; // Handle the error appropriately
    }
  }


}
