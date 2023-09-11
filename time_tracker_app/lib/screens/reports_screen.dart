import 'package:flutter/material.dart';
import 'package:time_tracker_app/widgets/bottom_navigation_bar.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreentate();
}

class _ReportsScreentate extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('222222222222222'),
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
