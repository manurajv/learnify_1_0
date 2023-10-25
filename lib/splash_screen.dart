import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay for demonstration purposes (e.g., loading data).
    // Replace this with any async tasks you want to perform during the splash screen.
    Future.delayed(Duration(seconds: 6), () {
      //Navigate to the main screen (e.g., HomeScreen) after the splash screen.
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen(),
          )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color of the splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace 'assets/loading_img.gif' with your GIF icon path
            Image.asset(
              'assets/loading_img.gif',
              //width: MediaQuery.of(context).size.width,
              //height: 100,
            ),
            SizedBox(height: 20.0),
            Text(
              'Learnify',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
