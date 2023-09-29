import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../screens/selector_screen.dart';

// ignore: must_be_immutable
class ActivityButton extends StatefulWidget {
  String fileName;
  StopWatchTimer stopWatchTimer;
  List<String> names;
  String buttonName;
  int totalTimeInSeconds;
  String formattedTime;
  Function clearText;
  Function startTimer;
  Function loadSavedText;
  ActivityButton({
    super.key,
    required this.fileName,
    required this.stopWatchTimer,
    required this.names,
    required this.buttonName,
    required this.totalTimeInSeconds,
    required this.formattedTime,
    required this.clearText,
    required this.startTimer,
    required this.loadSavedText,
  });

  @override
  State<ActivityButton> createState() => _ActivityButtonState();
}

class _ActivityButtonState extends State<ActivityButton> {
  MaterialStateProperty<Color?>? bgColor = MaterialStateProperty.all<Color>(
      const Color.fromARGB(255, 255, 255, 255));
  Color? timerColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.5,
      child: ElevatedButton(
          onLongPress: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? name = prefs.getString(widget.fileName);
            if (!widget.stopWatchTimer.isRunning) {
              // ignore: use_build_context_synchronously
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => SelectorScreen(timerNames: widget.names)),
              );
              setState(() {
                if (result != null) {
                  name = result;
                  prefs.setString(widget.fileName, name!);
                  widget.buttonName = name!;
                }
              });
            }
          },
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6))),
              side: MaterialStateProperty.all<BorderSide>(const BorderSide(
                width: 2.0,
              )),
              foregroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 0, 0, 0)),
              backgroundColor: bgColor),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? name = prefs.getString(widget.fileName);
            // ignore: use_build_context_synchronously
            if (widget.buttonName != '<empty>') {
              if (widget.stopWatchTimer.isRunning) {
                bgColor = MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255));
                timerColor = Colors.black;
                widget.stopWatchTimer.onStopTimer();
                widget.clearText();
              } else {
                bgColor = MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 171, 211, 251));
                timerColor = const Color.fromARGB(255, 0, 175, 6);
                widget.startTimer();
                widget.loadSavedText();
              }
            } else {
              // ignore: use_build_context_synchronously
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => SelectorScreen(timerNames: widget.names)),
              );
              setState(() {
                if (result != null) {
                  name = result;
                  prefs.setString(widget.fileName, name!);
                  widget.buttonName = name!;
                }
              });
            }
          },
          child: widget.stopWatchTimer.isRunning
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.buttonName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.black, // Цвет текста
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    StreamBuilder<int>(
                      stream: widget.stopWatchTimer.rawTime,
                      initialData: widget.totalTimeInSeconds,
                      builder: (context, snapshot) {
                        return Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          widget.formattedTime,
                          style: TextStyle(fontSize: 20, color: timerColor),
                        );
                      },
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        widget.buttonName, // Замените на название вашей кнопки
                        style: const TextStyle(
                          color: Colors.black, // Цвет текста
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }
}
