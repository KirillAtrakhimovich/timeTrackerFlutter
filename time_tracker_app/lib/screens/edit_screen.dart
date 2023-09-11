import 'package:flutter/material.dart';
import 'package:time_tracker_app/widgets/bottom_navigation_bar.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreentate();
}

class _EditScreentate extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('1111111111111111'),
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
