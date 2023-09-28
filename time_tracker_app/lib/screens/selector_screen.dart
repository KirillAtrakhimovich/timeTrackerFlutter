// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:time_tracker_app/widgets/primary_button.dart';
import 'package:time_tracker_app/widgets/text_field.dart';

// ignore: must_be_immutable
class SelectorScreen extends StatefulWidget {
  List<String> timerNames;
  SelectorScreen({super.key, required this.timerNames});

  @override
  State<SelectorScreen> createState() => _SelectorScreentate();
}

class _SelectorScreentate extends State<SelectorScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  bool editModeOff = true;
  List<String> filteredList = [];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initNames();
  }

  initNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var names = prefs.getStringList('names');
    if (names != null) {
      names.sort();
      setState(() {
        filteredList =
            names.where((item) => !widget.timerNames.contains(item)).toList();
      });
    }
  }

  updateNames(List<String> names) {
    names.sort();
    setState(() {
      filteredList =
          names.where((item) => !widget.timerNames.contains(item)).toList();
    });
  }

  showAddActivityDialog(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var names = prefs.getStringList('names');
    textController.text = '';
    names ??= [];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create new activity'),
        content: SizedBox(
            height: 100,
            child: CustomTextField(
              hintText: 'Name:',
              controller: textController,
              function: null,
              editingAbility: null,
              formKey: _formKey,
              names: names!,
            )),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                names!.add(textController.text);
                prefs.setStringList('names', names);
                setState(() {});
                textController.text = '';
                names.sort();
                updateNames(names);
                Navigator.of(context).pop();
              } else {
                return;
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  deleteActivity(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var names = prefs.getStringList('names');
    if (names != null) {
      setState(() {
        names.removeWhere((element) => element == name);
        updateNames(names);
      });
      prefs.setStringList('names', names);
    }
  }

  showEditActivityDialog(BuildContext context, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var names = prefs.getStringList('names');
    names!.sort();
    textController.text = filteredList[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit activity'),
        content: SizedBox(
            height: 100,
            child: CustomTextField(
              hintText: 'Name:',
              controller: textController,
              function: null,
              editingAbility: null,
              formKey: _formKey,
              names: names,
            )),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  var nameIndex = names
                      .indexWhere((element) => element == filteredList[index]);
                  names[nameIndex] = textController.text;
                  prefs.setStringList('names', names);
                  updateNames(names);
                });
              } else {
                return;
              }
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                const Text(
                  'Select subject to log time on',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Spacer(),
                IconButton(
                  icon: editModeOff
                      ? const Icon(
                          Icons.edit_off_rounded,
                          size: 30,
                        )
                      : const Icon(
                          Icons.edit,
                          size: 30,
                        ),
                  onPressed: () {
                    setState(() {
                      editModeOff = !editModeOff;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            PrimaryButton(
              text: const Text(
                'Add new...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              function: () {
                showAddActivityDialog(context);
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
                child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                Color backgroundColor = index % 2 != 0
                    ? Colors.white
                    : const Color.fromARGB(255, 111, 190, 255);
                if (editModeOff) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: backgroundColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 30),
                          SizedBox(
                            width: MediaQuery.of(context).size.width -
                                MediaQuery.of(context).size.width / 8,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  Navigator.pop(context, filteredList[index]);
                                  filteredList.removeAt(index);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(filteredList[index],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: backgroundColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 30),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  Navigator.pop(context, filteredList[index]);
                                  filteredList.removeAt(index);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(filteredList[index],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1),
                                    ),
                                  ],
                                )),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 12),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showEditActivityDialog(context, index);
                            },
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 60),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteActivity(filteredList[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
