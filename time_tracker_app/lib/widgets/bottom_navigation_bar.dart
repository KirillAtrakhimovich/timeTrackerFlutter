import 'package:flutter/material.dart';
import 'package:time_tracker_app/screens/edit_screen.dart';
import 'package:time_tracker_app/screens/timelog_screen.dart';
import 'package:time_tracker_app/screens/reports_screen.dart';
import 'package:time_tracker_app/screens/settings_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int? currentIndex;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  CustomBottomNavigationBar({
    required this.currentIndex,

  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex!,
      onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TimelogScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const EditScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ReportsScreen()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          }
        },
      items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
              backgroundColor: Colors.amber
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
              backgroundColor: Colors.green
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.pink
            ),
          ],
    );
  }
}
