import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'units_screen.dart';

class UnitTestScreen extends StatefulWidget {
  final String courseCode;
  late final Function() saveUnitDetailsToFirestoreCallback;

  UnitTestScreen({
    required this.courseCode,
    required this.saveUnitDetailsToFirestoreCallback,
  });

  @override
  _UnitTestScreenState createState() => _UnitTestScreenState();
}

class _UnitTestScreenState extends State<UnitTestScreen> {
  int numberOfQuestions = 5;
  List<String> questions = List.filled(50, '');
  List<List<String>> answers = List.generate(50, (index) => List.filled(4, ''));
  List<int> correctAnswers = List.filled(50, 0);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? unit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Test'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Number of Questions:'),
            DropdownButton<int>(
              value: numberOfQuestions,
              items: List.generate(50, (index) => index + 1)
                  .map((value) => DropdownMenuItem<int>(
                value: value,
                child: Text('$value'),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  numberOfQuestions = value!;
                });
              },
            ),
            for (var i = 0; i < numberOfQuestions; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Question ${i + 1}:'),
                  TextField(
                    onChanged: (value) {
                      questions[i] = value;
                    },
                  ),
                  for (var j = 0; j < 4; j++)
                    Row(
                      children: [
                        Radio(
                          value: j,
                          groupValue: correctAnswers[i],
                          onChanged: (value) {
                            setState(() {
                              correctAnswers[i] = value!;
                            });
                          },
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              answers[i][j] = value;
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ElevatedButton(
              onPressed: () async {
                //Saving Unit Details to firestore
                String nextId = await getUnitId(_auth.currentUser!.uid);
                widget.saveUnitDetailsToFirestoreCallback();

                // Handle saving unit test details to Firestore
                try{
                  saveUnitTestDetailsToFirestore(
                    nextId: nextId,
                    questions: questions.take(numberOfQuestions).toList(),
                    answers: answers.take(numberOfQuestions).toList(),
                    correctAnswers:
                        correctAnswers.take(numberOfQuestions).toList(),
                  );
                } catch(e){
                  print('Error saving unit test details: $e');
                }

                Navigator.pop(context, 'Unit saved successfully');
              },
              child: Text('Save Unit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveUnitTestDetailsToFirestore({
    required String nextId,
    required List<String> questions,
    required List<List<String>> answers,
    required List<int> correctAnswers,
  }) async {
    try {
      final user = _auth.currentUser;
      final uid = user?.uid;
      nextId = await getUnitId(uid);
      print(uid);
      print(nextId);
      final CollectionReference unitTestCollection = _firestore
          .collection('courses')
          .doc(uid)
          .collection(widget.courseCode)
          .doc('Units')
          .collection('Units').doc(nextId).collection('Test');
          //.doc();

      // Create a document reference for the unit test
      DocumentReference unitTestRef = unitTestCollection.doc(nextId);

      // Flatten the answers list of lists into a list of maps
      List<Map<String, dynamic>> flattenedAnswers = answers.map((answerList) {
        return {'subAnswers': answerList};
      }).toList();

      // Define the unit test data
      Map<String, dynamic> unitTestData = {
        'questions': questions,
        'correctAnswers': correctAnswers,
        // You can add more fields as needed
      };

      // Set the unit test data in the Firestore document
      await unitTestRef.set(unitTestData);

      // Create a subcollection for the answers
      CollectionReference answersCollection = unitTestRef.collection('Answers');

      // Store each answer set in a separate document
      for (int i = 0; i < flattenedAnswers.length; i++) {
        await answersCollection.doc('Answer$i').set(flattenedAnswers[i]);
      }

      print('Unit test details uploaded successfully');
    } catch (e) {
      print('Error saving unit test details: $e');
    }
  }

  Future<String> getUnitId(String? uid) async {
    try {
      CollectionReference unitsCollection = _firestore
          .collection('courses')
          .doc(uid)
          .collection(widget.courseCode)
          .doc('Units')
          .collection('Units');

      // Get the list of subcollections under 'Units'
      QuerySnapshot unitCollections = await unitsCollection.get();

      int maxId = 0;

      // Loop through the subcollections to find the largest ID
      for (QueryDocumentSnapshot doc in unitCollections.docs) {
        int id = int.tryParse(doc.id) ?? 0;
        if (id > maxId) {
          maxId = id;
        }
      }

      // Calculate the next unit ID by incrementing the largest ID
      String nextId = (maxId + 1).toString().padLeft(3, '0');

      return nextId;
    } catch (e) {
      print('Error getting the next unit ID: $e');
      return '000'; // Default to '000' if there's an error
    }
  }

}
