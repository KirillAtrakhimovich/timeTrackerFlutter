import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker_app/screens/main_screen.dart';
import 'package:time_tracker_app/screens/navigation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, 

    ]);
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home:  NavigationScreen(),

    );
  }
}


