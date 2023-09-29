import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreentate();
}

class _SettingsScreentate extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 3),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Settings screen',style: TextStyle(fontSize: 40)),
            ],
          ),
          
        ],
      ),
    );
  }
}
