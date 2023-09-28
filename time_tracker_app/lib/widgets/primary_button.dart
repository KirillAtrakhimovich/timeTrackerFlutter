import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PrimaryButton extends StatelessWidget {
  Text text;
  Function function;

  PrimaryButton({super.key, required this.text, required this.function});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
          padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 50, vertical: 0)),
          side: MaterialStateProperty.all<BorderSide>(const BorderSide(
            width: 2.0,
          )),
          foregroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 0, 0, 0)),
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 255, 255, 255))),
      onPressed: () {
        function();
      },
      child: text,
    );
  }
}
