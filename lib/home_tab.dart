import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnify_1_0/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'course_slideshow.dart';
import 'home_top_image.dart';

class HomeTabE extends StatefulWidget {
  @override
  _HomeTabEState createState() => _HomeTabEState();
}

class _HomeTabEState extends State<HomeTabE> {
  bool isLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Add your logout logic here
              _signOut(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          TopImage(),
          SizedBox(height: 25),
          CourseSlideshow(),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Update the login status
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('loggedIn', false);

      setState(() {
        isLoggedIn = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
