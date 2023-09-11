import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker_app/screens/edit_screen.dart';
import 'package:time_tracker_app/screens/main_screen.dart';
import 'package:time_tracker_app/screens/reports_screen.dart';
import 'package:time_tracker_app/screens/selector_screen.dart';
import 'package:time_tracker_app/screens/settings_screen.dart';
import 'package:time_tracker_app/widgets/primary_button.dart';
import 'package:time_tracker_app/widgets/text_field.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
 
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MainScreen(),
    EditScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
              backgroundColor: Colors.amber
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
              backgroundColor: Colors.green
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.pink
            ),
          ],
        ),
      );
  }
}
