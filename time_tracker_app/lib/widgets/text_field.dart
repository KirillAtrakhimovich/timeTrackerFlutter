import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  String hintText;
  Function? function;
  bool? editingAbility;
  late TextEditingController? controller;
  CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.function,
    required this.editingAbility
  });

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
        SizedBox(
          width: (MediaQuery.of(context).size.width / 1.05),
          child: TextFormField(
            enabled: widget.editingAbility,
            controller: widget.controller,
            keyboardType: TextInputType.text,
            textInputAction:
                TextInputAction.done,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
              filled: true,
              border: OutlineInputBorder(),
              // hintText: widget.hintText,
              isDense: true,
            ),
            // onFieldSubmitted: (text) {
            //   // Вызываем метод FocusScope.of(context).unfocus() для скрытия клавиатуры
            //   FocusScope.of(context).unfocus();
            //   // Здесь вы можете выполнить другие действия по обработке введенного текста
            //   widget.function!(text);
            // },
            onChanged: (text) {
              widget.function!(text);
            },
          ),
        )
      ],
    );
  }
}
