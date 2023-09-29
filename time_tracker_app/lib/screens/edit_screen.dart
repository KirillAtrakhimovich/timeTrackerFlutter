import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreentate();
}

class _EditScreentate extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text('Edit screen',style: TextStyle(fontSize: 40)),
            ],
          ),
          
        ],
      ),
    );
  }
}



void main() {
  
}

