import 'package:flutter/material.dart';
import 'package:time_tracker_app/widgets/bottom_navigation_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreentate();
}

class _SettingsScreentate extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 3),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('3333333333333'),
              IconButton(
                icon: const Icon(
                    Icons.edit), 
                onPressed: () {
                 
                },
              )
            ],
          ),
          
        ],
      ),
    );
  }
}
