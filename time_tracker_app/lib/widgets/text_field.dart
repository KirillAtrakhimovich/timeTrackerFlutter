import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  String hintText;
  Function? function;
  bool? editingAbility;
  List<String> names;
  GlobalKey<FormState>? formKey;
  late TextEditingController? controller;
  CustomTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.function,
      required this.editingAbility,
      required this.formKey,
      required this.names});

  @override
  State<CustomTextField> createState() => _CustomTetFiledState();
}

class _CustomTetFiledState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width -
                    (MediaQuery.of(context).size.width / 1.025)),
            Text(
              widget.hintText,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        Form(
          key: widget.formKey,
          child: SizedBox(
            width: (MediaQuery.of(context).size.width / 1.05),
            child: TextFormField(
              enabled: widget.editingAbility,
              autofocus: true,
              controller: widget.controller,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Field cannot be empty';
                } else if (widget.names.contains(value)) {
                  return 'This kind of activity already exists';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                filled: true,
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (text) {
                if (widget.function != null) {
                  widget.function!(text);
                } else {
                  return;
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
