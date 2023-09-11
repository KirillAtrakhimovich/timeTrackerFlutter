import 'package:flutter/material.dart';
import 'package:time_tracker_app/screens/edit_screen.dart';
import 'package:time_tracker_app/screens/main_screen.dart';
import 'package:time_tracker_app/screens/reports_screen.dart';
import 'package:time_tracker_app/screens/settings_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int? currentIndex;

  CustomBottomNavigationBar({
    required this.currentIndex,

  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex!,
      onTap: (index) {
          if (index == 0) {
            // Перейти на экран Home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          } else if (index == 1) {
            // Перейти на экран Search
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EditScreen()),
            );
          } else if (index == 2) {
            // Перейти на экран Search
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ReportsScreen()),
            );
          } else if (index == 3) {
            // Перейти на экран Search
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          }
          // Добавьте обработку для остальных экранов
        },
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
    );
  }
}
