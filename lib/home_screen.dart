import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'course_explore_tab.dart';
import 'dashboard_tab.dart';
import 'home_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    HomeTab(), // Replace HomeTab with your own implementation
    ExploreTab(), // Replace ExploreTab with your own implementation
    DashboardTab(), // Replace DashboardTab with your own implementation
    LikesTab(), // Replace LikesTab with your own implementation
    ProfileTab(), // Replace ProfileTab with your own implementation
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dash Board',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.favorite),
            //   label: 'Favourite',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// Implement custom tab screens (e.g., HomeTab, ExploreTab, DashboardTab, LikesTab, ProfileTab) here.
// Each tab should be a separate StatefulWidget or StatelessWidget.

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeTabE();
  }
}

//////// Explore Tab ............
class ExploreTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CourseExploreTab();
  }
}

class DashboardTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardTabE();
  }
}

class LikesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Likes Tab'),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Profile Tab'),
      ),
    );
  }
}
