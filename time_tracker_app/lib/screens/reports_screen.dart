import 'package:flutter/material.dart';


class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreentate();
}

class _ReportsScreentate extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Reports screen',style: TextStyle(fontSize: 40)),
            ],
          ),
          
        ],
      ),
    );
  }
}
