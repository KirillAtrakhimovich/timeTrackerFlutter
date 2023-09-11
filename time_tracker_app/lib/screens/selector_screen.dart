// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker_app/screens/edit_screen.dart';
import 'package:time_tracker_app/screens/main_screen.dart';
import 'package:time_tracker_app/screens/reports_screen.dart';
import 'package:time_tracker_app/screens/settings_screen.dart';
import 'package:time_tracker_app/widgets/bottom_navigation_bar.dart';
import 'package:time_tracker_app/widgets/primary_button.dart';
import 'package:time_tracker_app/widgets/text_field.dart';

class SelectorScreen extends StatefulWidget {
  const SelectorScreen({super.key});

  @override
  State<SelectorScreen> createState() => _SelectorScreentate();
}

class _SelectorScreentate extends State<SelectorScreen> {
  final TextEditingController textController = TextEditingController();
  bool editModeOff = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  Future<List<String>?> getItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var names = prefs.getStringList('fileNames');
    names!.sort();

    return names;
  }

  showAddActivityDialog(BuildContext context) {
    textController.text = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create new activity'),
        content: SizedBox(
            height: 80,
            child:
                CustomTextField(hintText: 'Name:', controller: textController, function: null, editingAbility: null,)),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var names = prefs.getStringList('fileNames');

              names ??= [];
              names.add(textController.text);
              prefs.setStringList('fileNames', names);
              setState(() {});
              textController.text = '';
              names.sort();
              Navigator.of(context).pop();
              print('NAMES $names');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  deleteActivity(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var names = prefs.getStringList('fileNames');

    if (names != null && index >= 0 && index < names.length) {
      names.sort();
      setState(() {
        names.removeAt(index); // Удаляем элемент по индексу
      });
      prefs.setStringList('fileNames', names);
      print(names);
    }
  }

  showEditActivityDialog(BuildContext context, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var names = prefs.getStringList('fileNames');
    names!.sort();
    textController.text = names[index]; // Устанавливаем начальное значение
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit activity'), // Изменили текст заголовка
        content: SizedBox(
          height: 80,
          child: TextField(
            controller: textController, // Подключаем контроллер
            decoration: InputDecoration(hintText: 'Name:'),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              setState(() {
                names[index] = textController.text;
                names.sort();
                prefs.setStringList('fileNames', names);
              });
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
                SizedBox(
                  width: 30,
                ),
                const Text('Select subject to log time on'),
                Spacer(),
                IconButton(
                  icon: editModeOff
                      ? const Icon(Icons.edit_off_rounded)
                      : const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      editModeOff = !editModeOff;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('fileNames');
                    setState(() {});
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
            Expanded(
              child: FutureBuilder(
                future: getItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var itemCount = snapshot.data?.length ?? 0;

                    return ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        if (editModeOff) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                15),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context, snapshot.data![index]);
                                          },
                                          child: Text(snapshot.data![index],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1)),
                                    ),
                                  ],
                                ),
                              ),
                              if (index < itemCount - 1)
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 1.0,
                                ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                15),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: ElevatedButton(
                                          onPressed: () {},
                                          child: Text(snapshot.data![index],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1)),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                7),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        showEditActivityDialog(context, index);
                                      },
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                80),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        deleteActivity(index);
                                        print(index);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              if (index < itemCount - 1)
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 1.0,
                                ),
                            ],
                          );
                        }
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
