import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'course_card.dart';
import 'course_information_screen.dart';
import 'course_model.dart';

class CourseExploreTab extends StatefulWidget {
  @override
  _CourseExploreTabState createState() => _CourseExploreTabState();
}

class _CourseExploreTabState extends State<CourseExploreTab> {
  final List<String> courseCategories = [
    'Programming',
    'Design',
    'Business',
    'Marketing',
    'Health',
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Explore'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CourseSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (String category in courseCategories)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Chip(
                          label: Text(category),
                          backgroundColor: Colors.blue,
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('courses_metadata').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return SliverToBoxAdapter(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                if (documents.isNotEmpty) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return _courseListItem(documents[index]);
                      },
                      childCount: documents.length,
                    ),
                  );
                } else {
                  return SliverToBoxAdapter(child: Center(child: Text('No courses available!')));
                }
              } else {
                return SliverToBoxAdapter(child: Center(child: Text('No courses available')));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _courseListItem(QueryDocumentSnapshot doc) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseInformationScreen(
              courseName: doc['courseName'],
              courseCode: doc['courseCode'],
              imageUrl: doc['imageUrl'],
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(4),
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              doc['courseName'],
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            Text(
              doc['courseCode'],
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('courses_metadata')
          .where('courseName', isGreaterThanOrEqualTo: query)
          .where('courseName', isLessThan: query + 'z')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          if (documents.isNotEmpty) {
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return _courseListItem(documents[index], context);
              },
            );
          } else {
            return Center(child: Text('No courses found'));
          }
        } else {
          return Center(child: Text('No courses found'));
        }
      },
    );
  }

  Widget _courseListItem(QueryDocumentSnapshot doc, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseInformationScreen(
              courseName: doc['courseName'],
              courseCode: doc['courseCode'],
              imageUrl: doc['imageUrl'],
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(4),
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              doc['courseName'],
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            Text(
              doc['courseCode'],
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
