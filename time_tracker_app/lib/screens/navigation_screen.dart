import 'package:flutter/material.dart';

import 'package:time_tracker_app/screens/edit_screen.dart';
import 'package:time_tracker_app/screens/timelog_screen.dart';
import 'package:time_tracker_app/screens/reports_screen.dart';

import 'package:time_tracker_app/screens/settings_screen.dart';


class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
 
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const TimelogScreen(),
    const EditScreen(),
    const ReportsScreen(),
    const SettingsScreen(),
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
              icon: Icon(Icons.access_time_outlined),
              label: 'Log Time',
              backgroundColor: Colors.blue
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.mode_edit_outline_outlined),
              label: 'Edit',
              backgroundColor: Colors.indigo
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.data_thresholding_outlined),
              label: 'Reports',
              backgroundColor: Colors.green
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings_applications),
              label: 'Settings',
              backgroundColor: Colors.black45
            ),
          ],
        ),
      );
  }
}
