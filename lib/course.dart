import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'unitcontentpage.dart';

class Course extends StatefulWidget {
  final String courseCode;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Course(

  {

  required
  this.courseCode,
  });
  // Future<Map<String, String>> fetchUnitUrls(String unitId) async {
  //   try {
  //     DocumentSnapshot unitDoc = await FirebaseFirestore.instance
  //         .collection('courses')
  //         .doc(_CourseState().instructorUid)
  //         .collection(courseCode)
  //         .doc('Units')
  //         .collection('Units').doc(unitId).get();
  //
  //     if (unitDoc.exists) {
  //       return {
  //         'pptUrl': unitDoc.get('pptUrl'),
  //         'videoUrl': unitDoc.get('videoUrl'),
  //       };
  //     } else {
  //       return {
  //         'pptUrl': '',
  //         'videoUrl': '',
  //       };
  //     }
  //   } catch (e) {
  //     print('Error getting unit URLs: $e');
  //     return {
  //       'pptUrl': '',
  //       'videoUrl': '',
  //     };
  //   }
  // }

  @override
  _CourseState createState() => _CourseState();
}

class _CourseState extends State<Course> {
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
        title: Text('Course Details'),
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 0.1,
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
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
                  Container(
                    // child: Image.network(
                    //   widget.imageUrl,
                    //   fit: BoxFit.cover,
                    // ),
                    height: 140,
                  ),
                  Container(
                    // child: Text(
                    //   'Course Name: ${widget.courseName}',
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     color: Colors.black,
                    //   ),
                    // ),
                  ),
                  Container(
                    child: Text(
                      'Course Code: ${widget.courseCode}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<List<String>>>(
                      future: fetchUnitDetails(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          List<List<String>> unitsDetailsArr1 = snapshot.data!;

                          return SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: unitsDetailsArr1.length,
                              itemBuilder: (context, index) {
                                List<String> unitDetails = unitsDetailsArr1[index];
                                int x = index + 1;

                                return GestureDetector(
                                  onTap: () {
                                    // Navigate to the EditUnitScreen when the card is tapped
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UnitContentPage(
                                          unitTitle: 'Unit $x',
                                          videoUrl: 'URL_to_unit_x_video.mp4', unitDescription: '', pptUrl: '', unitContent: null,
                                        ),

                                      ),
                                    );
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (BuildContext context) {
                                    //     return AlertDialog(
                                    //       title: Text("Message"),
                                    //       content: Text("Access to proceed with unit will be allowed soon"),
                                    //       actions: <Widget>[
                                    //         TextButton(
                                    //           child: Text("OK"),
                                    //           onPressed: () {
                                    //             Navigator.of(context).pop(); // Close the popup
                                    //           },
                                    //         ),
                                    //       ],
                                    //     );
                                    //   },
                                    // );
                                  },
                                  child: Card(
                                    child: ListTile(
                                      title: Text('Unit $x'),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          for (String detail in unitDetails) Text(detail),
                                        ],
                                      ),
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
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
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
            'PPT URL: $pptUrl',
            'Video URL: $videoUrl',
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

}
