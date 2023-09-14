import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:time_tracker_app/screens/selector_screen.dart';
import 'package:time_tracker_app/widgets/text_field.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreentate();
}

class _MainScreentate extends State<MainScreen> {
  final TextEditingController textController = TextEditingController();
  final StopWatchTimer _stopWatchTimer1 = StopWatchTimer();
  final StopWatchTimer _stopWatchTimer2 = StopWatchTimer();
  final StopWatchTimer _stopWatchTimer3 = StopWatchTimer();
  final StopWatchTimer _stopWatchTimer4 = StopWatchTimer();
  final StopWatchTimer _stopWatchTimer5 = StopWatchTimer();
  final StopWatchTimer _stopWatchTimer6 = StopWatchTimer();
  final StopWatchTimer _stopWatchTimerOther = StopWatchTimer();
  late final List<StopWatchTimer> _stopWatchTimers = [
    _stopWatchTimer1,
    _stopWatchTimer2,
    _stopWatchTimer3,
    _stopWatchTimer4,
    _stopWatchTimer5,
    _stopWatchTimer6,
    _stopWatchTimerOther
  ];
  String buttonName1 = '<empty>';
  String buttonName2 = '<empty>';
  String buttonName3 = '<empty>';
  String buttonName4 = '<empty>';
  String buttonName5 = '<empty>';
  String buttonName6 = '<empty>';
  String buttonNameOther = 'other...';
  String _formattedTime1 = '00:00';
  String _formattedTime2 = '00:00';
  String _formattedTime3 = '00:00';
  String _formattedTime4 = '00:00';
  String _formattedTime5 = '00:00';
  String _formattedTime6 = '00:00';
  String _formattedTimeOther = '00:00';
  int totalTimeInSeconds1 = 0;
  int totalTimeInSeconds2 = 0;
  int totalTimeInSeconds3 = 0;
  int totalTimeInSeconds4 = 0;
  int totalTimeInSeconds5 = 0;
  int totalTimeInSeconds6 = 0;
  int totalTimeInSecondsOther = 0;
  bool isTimerRunning1 = false;
  bool isTimerRunning2 = false;
  bool isTimerRunning3 = false;
  bool isTimerRunning4 = false;
  bool isTimerRunning5 = false;
  bool isTimerRunning6 = false;
  bool isTimerRunningOther = false;
  MaterialStateProperty<Color?>? bgColor1 = MaterialStateProperty.all<Color>(
      const Color.fromARGB(255, 255, 255, 255));
  Color? timerColor1 = Colors.black;
  MaterialStateProperty<Color?>? bgColor2 = MaterialStateProperty.all<Color>(
      const Color.fromARGB(255, 255, 255, 255));
  Color? timerColor2 = Colors.black;
  MaterialStateProperty<Color?>? bgColor3 = MaterialStateProperty.all<Color>(
      const Color.fromARGB(255, 255, 255, 255));
  Color? timerColor3 = Colors.black;
  MaterialStateProperty<Color?>? bgColor4 = MaterialStateProperty.all<Color>(
      const Color.fromARGB(255, 255, 255, 255));
  Color? timerColor4 = Colors.black;
  MaterialStateProperty<Color?>? bgColor5 = MaterialStateProperty.all<Color>(
      const Color.fromARGB(255, 255, 255, 255));
  Color? timerColor5 = Colors.black;
  MaterialStateProperty<Color?>? bgColor6 = MaterialStateProperty.all<Color>(
      const Color.fromARGB(255, 255, 255, 255));
  Color? timerColor6 = Colors.black;
  MaterialStateProperty<Color?>? bgColorOther =
      MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 255, 255, 255));
  Color? timerColorOther = Colors.black;
  bool anyTimerRunning = false;

  @override
  void initState() {
    super.initState();
    checkFirstTimeRun();
    _loadButtonNameFromPrefs();
    loadTimers();
    convertTimes();
  }

  void _loadSavedText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedText = prefs.getString('savedText');

    for (int i = 0; i < _stopWatchTimers.length; i++) {
      if (_stopWatchTimers[i].isRunning) {
        setState(() {
          anyTimerRunning = true;
          savedText ??= '';
          textController.text = savedText!;
        });
      }
      setState(() {
        if (anyTimerRunning) {
          
          String? savedText = prefs.getString('savedText');
          savedText ??= '';
          textController.text = savedText; // Устанавливаем сохраненный текст
        }
      });
    }
  }

  clearText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedText = prefs.getString('savedText');
    setState(() {
      for (int i = 0; i < _stopWatchTimers.length; i++) {
        if (_stopWatchTimer1.isRunning ||
            _stopWatchTimer2.isRunning ||
            _stopWatchTimer3.isRunning ||
            _stopWatchTimer4.isRunning ||
            _stopWatchTimer5.isRunning ||
            _stopWatchTimer6.isRunning ||
            _stopWatchTimerOther.isRunning) {
          if (savedText != null) {
            setState(() {
              textController.text = savedText;
            });
          }
        } else {
          setState(() {
            anyTimerRunning = false;
            textController.text = '';
          });
        }
      }
    });
  }

  void _saveText(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedText', text);
  }

  convertTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? timerStartTime1 = prefs.getInt('initialTime1');
    int? timerStartTime2 = prefs.getInt('initialTime2');
    int? timerStartTime3 = prefs.getInt('initialTime3');
    int? timerStartTime4 = prefs.getInt('initialTime4');
    int? timerStartTime5 = prefs.getInt('initialTime5');
    int? timerStartTime6 = prefs.getInt('initialTime6');
    int? timerStartTimeOther = prefs.getInt('initialTimeOther');
    List<String> timeComponents1 = _formattedTime1.split(':');
    List<String> timeComponents2 = _formattedTime2.split(':');
    List<String> timeComponents3 = _formattedTime3.split(':');
    List<String> timeComponents4 = _formattedTime4.split(':');
    List<String> timeComponents5 = _formattedTime5.split(':');
    List<String> timeComponents6 = _formattedTime6.split(':');
    List<String> timeComponentsOther = _formattedTimeOther.split(':');

    int minutes1 = int.parse(timeComponents1[0]);
    int seconds1 = int.parse(timeComponents1[1]);

    int minutes2 = int.parse(timeComponents2[0]);
    int seconds2 = int.parse(timeComponents2[1]);

    int minutes3 = int.parse(timeComponents3[0]);
    int seconds3 = int.parse(timeComponents3[1]);

    int minutes4 = int.parse(timeComponents4[0]);
    int seconds4 = int.parse(timeComponents4[1]);

    int minutes5 = int.parse(timeComponents5[0]);
    int seconds5 = int.parse(timeComponents5[1]);

    int minutes6 = int.parse(timeComponents6[0]);
    int seconds6 = int.parse(timeComponents6[1]);

    int minutesOther = int.parse(timeComponentsOther[0]);
    int secondsOther = int.parse(timeComponentsOther[1]);

    totalTimeInSeconds1 = minutes1 * 60 + seconds1;
    totalTimeInSeconds2 = minutes2 * 60 + seconds2;
    totalTimeInSeconds3 = minutes3 * 60 + seconds3;
    totalTimeInSeconds4 = minutes4 * 60 + seconds4;
    totalTimeInSeconds5 = minutes5 * 60 + seconds5;
    totalTimeInSeconds6 = minutes6 * 60 + seconds6;
    totalTimeInSecondsOther = minutesOther * 60 + secondsOther;

    setState(() {
      timerStartTime1 = totalTimeInSeconds1;
      prefs.setInt('initialTime1', timerStartTime1!);
      totalTimeInSeconds1 = timerStartTime1!;
    });

    setState(() {
      timerStartTime2 = totalTimeInSeconds2;
      prefs.setInt('initialTime2', timerStartTime2!);
      totalTimeInSeconds2 = timerStartTime2!;
    });

    setState(() {
      timerStartTime3 = totalTimeInSeconds3;
      prefs.setInt('initialTime3', timerStartTime3!);
      totalTimeInSeconds3 = timerStartTime3!;
    });

    setState(() {
      timerStartTime4 = totalTimeInSeconds4;
      prefs.setInt('initialTime4', timerStartTime4!);
      totalTimeInSeconds4 = timerStartTime4!;
    });

    setState(() {
      timerStartTime5 = totalTimeInSeconds5;
      prefs.setInt('initialTime5', timerStartTime5!);
      totalTimeInSeconds5 = timerStartTime5!;
    });

    setState(() {
      timerStartTime6 = totalTimeInSeconds6;
      prefs.setInt('initialTime6', timerStartTime6!);
      totalTimeInSeconds6 = timerStartTime6!;
    });

    setState(() {
      timerStartTimeOther = totalTimeInSecondsOther;
      prefs.setInt('initialTimeOther', timerStartTimeOther!);
      totalTimeInSecondsOther = timerStartTimeOther!;
    });
  }

  loadTimer1() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer1 = prefs.getString('timer1');
    if (timer1 != null) {
    setState(() {
      _formattedTime1 = timer1;
    });
   }
  }

  loadTimer2() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer2 = prefs.getString('timer2');
    if (timer2 != null) {
    setState(() {
      _formattedTime2 = timer2;
    });
   }
  }

  loadTimer3() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer3 = prefs.getString('timer3');
    if (timer3 != null) {
    setState(() {
      _formattedTime3 = timer3;
    });
   }
  }

  loadTimer4() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer4 = prefs.getString('timer4');
    if (timer4 != null) {
    setState(() {
      _formattedTime4 = timer4;
    });
   }
  }

  loadTimer5() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer5 = prefs.getString('timer5');
    if (timer5 != null) {
    setState(() {
      _formattedTime5 = timer5;
    });
   }
  }

  loadTimer6() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer6 = prefs.getString('timer6');
    if (timer6 != null) {
    setState(() {
      _formattedTime6 = timer6;
    });
   }
  }

  loadTimerOther() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timerOther = prefs.getString('timerOther');
    if (timerOther  != null) {
    setState(() {
      _formattedTimeOther  = timerOther ;
    });
   }
  }

  void loadTimers() async {
    loadTimer1();
    loadTimer2();
    loadTimer3();
    loadTimer4();
    loadTimer5();
    loadTimer6();
    loadTimerOther();
  }

  void _startTimer1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer1 = prefs.getString('timer1');
    int initialTimeInSeconds = totalTimeInSeconds1;

    if (!isTimerRunning1) {
      _stopWatchTimer1.setPresetTime(mSec: initialTimeInSeconds * 1000);
      isTimerRunning1 = true; // Устанавливаем флаг, что таймер запущен
    }

    _stopWatchTimer1.rawTime.listen((value) {
      final minutes = (value / 60000).floor();
      final seconds = ((value % 60000) / 1000).floor();
      setState(() {
        _formattedTime1 = '$minutes:${seconds.toString().padLeft(2, '0')}';
        timer1 = _formattedTime1;
        prefs.setString('timer1', timer1!);
        _formattedTime1 = timer1!;
      });
    });
    _stopWatchTimer1.onStartTimer();
  }

  void _startTimer2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer2 = prefs.getString('timer2');
    int initialTimeInSeconds = totalTimeInSeconds2;

    if (!isTimerRunning2) {
      _stopWatchTimer2.setPresetTime(mSec: initialTimeInSeconds * 1000);
      isTimerRunning2 = true; // Устанавливаем флаг, что таймер запущен
    }

    _stopWatchTimer2.rawTime.listen((value) {
      final minutes = (value / 60000).floor();
      final seconds = ((value % 60000) / 1000).floor();
      setState(() {
        _formattedTime2 = '$minutes:${seconds.toString().padLeft(2, '0')}';
        timer2 = _formattedTime2;
        prefs.setString('timer2', timer2!);
        _formattedTime2 = timer2!;
      });
    });
    _stopWatchTimer2.onStartTimer();
  }

  void _startTimer3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer3 = prefs.getString('timer3');
    int initialTimeInSeconds = totalTimeInSeconds3;

    if (!isTimerRunning3) {
      _stopWatchTimer3.setPresetTime(mSec: initialTimeInSeconds * 1000);
      isTimerRunning3 = true; // Устанавливаем флаг, что таймер запущен
    }
    _stopWatchTimer3.rawTime.listen((value) {
      final minutes = (value / 60000).floor();
      final seconds = ((value % 60000) / 1000).floor();
      setState(() {
        _formattedTime3 = '$minutes:${seconds.toString().padLeft(2, '0')}';
        timer3 = _formattedTime3;
        prefs.setString('timer3', timer3!);
        _formattedTime3 = timer3!;
      });
    });
    _stopWatchTimer3.onStartTimer();
  }

  void _startTimer4() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer4 = prefs.getString('timer4');
    int initialTimeInSeconds = totalTimeInSeconds4;

    if (!isTimerRunning4) {
      _stopWatchTimer4.setPresetTime(mSec: initialTimeInSeconds * 1000);
      isTimerRunning4 = true; // Устанавливаем флаг, что таймер запущен
    }

    _stopWatchTimer4.rawTime.listen((value) {
      final minutes = (value / 60000).floor();
      final seconds = ((value % 60000) / 1000).floor();
      setState(() {
        _formattedTime4 = '$minutes:${seconds.toString().padLeft(2, '0')}';
        timer4 = _formattedTime4;
        prefs.setString('timer4', timer4!);
        _formattedTime4 = timer4!;
      });
    });
    _stopWatchTimer4.onStartTimer();
  }

  void _startTimer5() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer5 = prefs.getString('timer5');
    int initialTimeInSeconds = totalTimeInSeconds5;

    if (!isTimerRunning5) {
      _stopWatchTimer5.setPresetTime(mSec: initialTimeInSeconds * 1000);
      isTimerRunning5 = true; // Устанавливаем флаг, что таймер запущен
    }

    _stopWatchTimer5.rawTime.listen((value) {
      final minutes = (value / 60000).floor();
      final seconds = ((value % 60000) / 1000).floor();
      setState(() {
        _formattedTime5 = '$minutes:${seconds.toString().padLeft(2, '0')}';
        timer5 = _formattedTime5;
        prefs.setString('timer5', timer5!);
        _formattedTime5 = timer5!;
      });
    });
    _stopWatchTimer5.onStartTimer();
  }

  void _startTimer6() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer6 = prefs.getString('timer6');
    int initialTimeInSeconds = totalTimeInSeconds6;

    if (!isTimerRunning6) {
      _stopWatchTimer6.setPresetTime(mSec: initialTimeInSeconds * 1000);
      isTimerRunning6 = true; // Устанавливаем флаг, что таймер запущен
    }

    _stopWatchTimer6.rawTime.listen((value) {
      final minutes = (value / 60000).floor();
      final seconds = ((value % 60000) / 1000).floor();
      setState(() {
        _formattedTime6 = '$minutes:${seconds.toString().padLeft(2, '0')}';
        timer6 = _formattedTime6;
        prefs.setString('timer6', timer6!);
        _formattedTime6 = timer6!;
      });
    });
    _stopWatchTimer6.onStartTimer();
  }

  void _startTimerOther() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timerOther = prefs.getString('timerOther');
    int initialTimeInSeconds = totalTimeInSecondsOther;

    if (!isTimerRunningOther) {
      _stopWatchTimerOther.setPresetTime(mSec: initialTimeInSeconds * 1000);
      isTimerRunningOther = true; // Устанавливаем флаг, что таймер запущен
    }

    _stopWatchTimerOther.rawTime.listen((value) {
      final minutes = (value / 60000).floor();
      final seconds = ((value % 60000) / 1000).floor();
      setState(() {
        _formattedTimeOther = '$minutes:${seconds.toString().padLeft(2, '0')}';
        timerOther = _formattedTimeOther;
        prefs.setString('timerOther', timerOther!);
        _formattedTimeOther = timerOther!;
      });
    });
    _stopWatchTimerOther.onStartTimer();
  }

  _loadButtonNameFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name1 = prefs.getString('fileName1');
    String? name2 = prefs.getString('fileName2');
    String? name3 = prefs.getString('fileName3');
    String? name4 = prefs.getString('fileName4');
    String? name5 = prefs.getString('fileName5');
    String? name6 = prefs.getString('fileName6');
    String? other = prefs.getString('fileNameOther');
    if (name1 != null) {
      setState(() {
        buttonName1 = name1;
      });
    }
    if (name2 != null) {
      setState(() {
        buttonName2 = name2;
      });
    }
    if (name3 != null) {
      setState(() {
        buttonName3 = name3;
      });
    }
    if (name4 != null) {
      setState(() {
        buttonName4 = name4;
      });
    }
    if (name5 != null) {
      setState(() {
        buttonName5 = name5;
      });
    }
    if (name6 != null) {
      setState(() {
        buttonName6 = name6;
      });
    }
    if (other != null) {
      setState(() {
        buttonNameOther = 'other...';
      });
    }
  }

  @override
  void dispose() {
    textController.dispose();
    _stopWatchTimer1.dispose();
    _stopWatchTimer2.dispose();
    _stopWatchTimer3.dispose();
    _stopWatchTimer4.dispose();
    _stopWatchTimer5.dispose();
    _stopWatchTimer6.dispose();
    _stopWatchTimerOther.dispose();
    super.dispose();
  }

  void checkFirstTimeRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('first_time_run') ?? true;
    if (isFirstTime) {
      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            title: const Text('Welcome!'),
            content: const Text(
                'Log your time by pressing a button. Press any empty button to configure.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('ОК'),
              ),
            ],
          );
        },
      );

      prefs.setBool('first_time_run', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> names = [
      buttonName1,
      buttonName2,
      buttonName3,
      buttonName4,
      buttonName5,
      buttonName6,
      buttonNameOther
    ];
    List<String> timers = [
      _formattedTime1,
      _formattedTime2,
      _formattedTime3,
      _formattedTime4,
      _formattedTime5,
      _formattedTime6,
      _formattedTimeOther
    ];
    return Scaffold(
        body: SafeArea(
      child: IntrinsicHeight(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.05,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onLongPress: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? name = prefs.getString('fileName1');
                              if (!_stopWatchTimer1.isRunning) {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          SelectorScreen(timerNames: names)),
                                );
                                setState(() {
                                  if (result != null) {
                                    name = result;
                                    prefs.setString('fileName1', name!);
                                    buttonName1 = name!;
                                  }
                                });
                              }
                            },
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                padding: const MaterialStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 0)),
                                side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                  width: 2.0,
                                )),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 0, 0, 0)),
                                backgroundColor: bgColor1),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? name = prefs.getString('fileName1');
                              // ignore: use_build_context_synchronously
                              if (buttonName1 != '<empty>') {
                                if (_stopWatchTimer1.isRunning) {
                                  bgColor1 = MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 255, 255, 255));
                                  timerColor1 = Colors.black;
                                  _stopWatchTimer1.onStopTimer();
                                  clearText();
                                } else {
                                  bgColor1 = MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 171, 211, 251));
                                  timerColor1 = Color.fromARGB(255, 0, 175, 6);
                                  _startTimer1();
                                  _loadSavedText();
                                }
                              } else {
                                // ignore: use_build_context_synchronously
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          SelectorScreen(timerNames: names)),
                                );
                                setState(() {
                                  if (result != null) {
                                    name = result;
                                    prefs.setString('fileName1', name!);
                                    buttonName1 = name!;
                                  }
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  buttonName1, // Замените на название вашей кнопки
                                  style: TextStyle(
                                    color: Colors.black, // Цвет текста
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                if (_stopWatchTimer1.isRunning)
                                  StreamBuilder<int>(
                                    stream: _stopWatchTimer1.rawTime,
                                    initialData: totalTimeInSeconds1,
                                    builder: (context, snapshot) {
                                      return Text(
                                        _formattedTime1,
                                        style: TextStyle(
                                            fontSize: 20, color: timerColor1),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onLongPress: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? name = prefs.getString('fileName2');
                              if (!_stopWatchTimer2.isRunning) {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          SelectorScreen(timerNames: names)),
                                );
                                setState(() {
                                  if (result != null) {
                                    name = result;
                                    prefs.setString('fileName2', name!);
                                    buttonName2 = name!;
                                  }
                                });
                              }
                            },
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                padding: const MaterialStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 0)),
                                side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                  width: 2.0,
                                )),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 0, 0, 0)),
                                backgroundColor: bgColor2),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? name = prefs.getString('fileName2');
                              // ignore: use_build_context_synchronously
                              if (buttonName2 != '<empty>') {
                                if (_stopWatchTimer2.isRunning) {
                                  bgColor2 = MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 255, 255, 255));
                                  timerColor2 = Colors.black;
                                  _stopWatchTimer2.onStopTimer();
                                  clearText();
                                } else {
                                  bgColor2 = MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 171, 211, 251));
                                  timerColor2 = Color.fromARGB(255, 0, 175, 6);
                                  _startTimer2();
                                  _loadSavedText();
                                }
                              } else {
                                // ignore: use_build_context_synchronously
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          SelectorScreen(timerNames: names)),
                                );
                                setState(() {
                                  if (result != null) {
                                    name = result;
                                    prefs.setString('fileName2', name!);
                                    buttonName2 = name!;
                                  }
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  buttonName2, // Замените на название вашей кнопки
                                  style: TextStyle(
                                    color: Colors.black, // Цвет текста
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                if (_stopWatchTimer2.isRunning)
                                  StreamBuilder<int>(
                                    stream: _stopWatchTimer2.rawTime,
                                    initialData: totalTimeInSeconds2,
                                    builder: (context, snapshot) {
                                      return Text(
                                        _formattedTime2,
                                        style: TextStyle(
                                            fontSize: 20, color: timerColor2),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onLongPress: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? name = prefs.getString('fileName3');
                              if (!_stopWatchTimer3.isRunning) {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          SelectorScreen(timerNames: names)),
                                );
                                setState(() {
                                  if (result != null) {
                                    name = result;
                                    prefs.setString('fileName3', name!);
                                    buttonName3 = name!;
                                  }
                                });
                              }
                            },
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                padding: const MaterialStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 0)),
                                side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                  width: 2.0,
                                )),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 0, 0, 0)),
                                backgroundColor: bgColor3),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? name = prefs.getString('fileName3');
                              // ignore: use_build_context_synchronously
                              if (buttonName3 != '<empty>') {
                                if (_stopWatchTimer3.isRunning) {
                                  bgColor3 = MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 255, 255, 255));
                                  timerColor3 = Colors.black;
                                  _stopWatchTimer3.onStopTimer();
                                  clearText();
                                } else {
                                  bgColor3 = MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 171, 211, 251));
                                  timerColor3 = Color.fromARGB(255, 0, 175, 6);
                                  _startTimer3();
                                  _loadSavedText();
                                }
                              } else {
                                // ignore: use_build_context_synchronously
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          SelectorScreen(timerNames: names)),
                                );
                                setState(() {
                                  if (result != null) {
                                    name = result;
                                    prefs.setString('fileName3', name!);
                                    buttonName3 = name!;
                                  }
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  buttonName3, // Замените на название вашей кнопки
                                  style: TextStyle(
                                    color: Colors.black, // Цвет текста
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                if (_stopWatchTimer3.isRunning)
                                  StreamBuilder<int>(
                                    stream: _stopWatchTimer3.rawTime,
                                    initialData: totalTimeInSeconds3,
                                    builder: (context, snapshot) {
                                      return Text(
                                        _formattedTime3,
                                        style: TextStyle(
                                            fontSize: 20, color: timerColor3),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onLongPress: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? name = prefs.getString('fileName4');
                              if (!_stopWatchTimer4.isRunning) {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          SelectorScreen(timerNames: names)),
                                );
                                setState(() {
                                  if (result != null) {
                                    name = result;
                                    prefs.setString('fileName4', name!);
                                    buttonName4 = name!;
                                  }
                                });
                              }
                            },
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                padding: const MaterialStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 0)),
                                side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                  width: 2.0,
                                )),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 0, 0, 0)),
                                backgroundColor: bgColor4),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? name = prefs.getString('fileName4');
                              // ignore: use_build_context_synchronously
                              if (buttonName4 != '<empty>') {
                                if (_stopWatchTimer4.isRunning) {
                                  bgColor4 = MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 255, 255, 255));
                                  timerColor4 = Colors.black;
                                  _stopWatchTimer4.onStopTimer();
                                  clearText();
                                } else {
                                  bgColor4 = MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 171, 211, 251));
                                  timerColor4 = Color.fromARGB(255, 0, 175, 6);
                                  _startTimer4();
                                  _loadSavedText();
                                }
                              } else {
                                // ignore: use_build_context_synchronously
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          SelectorScreen(timerNames: names)),
                                );
                                setState(() {
                                  if (result != null) {
                                    name = result;
                                    prefs.setString('fileName4', name!);
                                    buttonName4 = name!;
                                  }
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  buttonName4, // Замените на название вашей кнопки
                                  style: TextStyle(
                                    color: Colors.black, // Цвет текста
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                if (_stopWatchTimer4.isRunning)
                                  StreamBuilder<int>(
                                    stream: _stopWatchTimer4.rawTime,
                                    initialData: totalTimeInSeconds4,
                                    builder: (context, snapshot) {
                                      return Text(
                                        _formattedTime4,
                                        style: TextStyle(
                                            fontSize: 20, color: timerColor4),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onLongPress: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? name = prefs.getString('fileName5');
                              if (!_stopWatchTimer5.isRunning) {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          SelectorScreen(timerNames: names)),
                                );
                                setState(() {
                                  if (result != null) {
                                    name = result;
                                    prefs.setString('fileName5', name!);
                                    buttonName5 = name!;
                                  }
                                });
                              }
                            },
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                padding: const MaterialStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 0)),
                                side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                  width: 2.0,
                                )),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 0, 0, 0)),
                                backgroundColor: bgColor5),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? name = prefs.getString('fileName5');
                              // ignore: use_build_context_synchronously
                              if (buttonName5 != '<empty>') {
                                if (_stopWatchTimer5.isRunning) {
                                  bgColor5 = MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 255, 255, 255));
                                  timerColor5 = Colors.black;
                                  _stopWatchTimer5.onStopTimer();
                                  clearText();
                                } else {
                                  bgColor5 = MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 171, 211, 251));
                                  timerColor5 = Color.fromARGB(255, 0, 175, 6);
                                  _startTimer5();
                                  _loadSavedText();
                                }
                              } else {
                                // ignore: use_build_context_synchronously
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          SelectorScreen(timerNames: names)),
                                );
                                setState(() {
                                  if (result != null) {
                                    name = result;
                                    prefs.setString('fileName5', name!);
                                    buttonName5 = name!;
                                  }
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  buttonName5, // Замените на название вашей кнопки
                                  style: TextStyle(
                                    color: Colors.black, // Цвет текста
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                if (_stopWatchTimer5.isRunning)
                                  StreamBuilder<int>(
                                    stream: _stopWatchTimer5.rawTime,
                                    initialData: totalTimeInSeconds5,
                                    builder: (context, snapshot) {
                                      return Text(
                                        _formattedTime5,
                                        style: TextStyle(
                                            fontSize: 20, color: timerColor5),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onLongPress: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? name = prefs.getString('fileName6');
                              if (!_stopWatchTimer6.isRunning) {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          SelectorScreen(timerNames: names)),
                                );
                                setState(() {
                                  if (result != null) {
                                    name = result;
                                    prefs.setString('fileName6', name!);
                                    buttonName6 = name!;
                                  }
                                });
                              }
                            },
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                padding: const MaterialStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 0)),
                                side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                  width: 2.0,
                                )),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 0, 0, 0)),
                                backgroundColor: bgColor6),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? name = prefs.getString('fileName6');
                              // ignore: use_build_context_synchronously
                              if (buttonName6 != '<empty>') {
                                if (_stopWatchTimer6.isRunning) {
                                  bgColor6 = MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 255, 255, 255));
                                  timerColor6 = Colors.black;
                                  _stopWatchTimer6.onStopTimer();
                                  clearText();
                                } else {
                                  bgColor6 = MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 171, 211, 251));
                                  timerColor6 = Color.fromARGB(255, 0, 175, 6);
                                  _startTimer6();
                                  _loadSavedText();
                                }
                              } else {
                                // ignore: use_build_context_synchronously
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          SelectorScreen(timerNames: names)),
                                );
                                setState(() {
                                  if (result != null) {
                                    name = result;
                                    prefs.setString('fileName6', name!);
                                    buttonName6 = name!;
                                  }
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  buttonName6, // Замените на название вашей кнопки
                                  style: TextStyle(
                                    color: Colors.black, // Цвет текста
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                if (_stopWatchTimer6.isRunning)
                                  StreamBuilder<int>(
                                    stream: _stopWatchTimer6.rawTime,
                                    initialData: totalTimeInSeconds6,
                                    builder: (context, snapshot) {
                                      return Text(
                                        _formattedTime6,
                                        style: TextStyle(
                                            fontSize: 20, color: timerColor6),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                padding: const MaterialStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 0)),
                                side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                  width: 2.0,
                                )),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 0, 0, 0)),
                                backgroundColor: bgColorOther),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? name = prefs.getString('fileNameOther');
                              // ignore: use_build_context_synchronously
                              if (buttonNameOther != 'other...') {
                                if (_stopWatchTimerOther.isRunning) {
                                  bgColorOther =
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 255, 255, 255));
                                  timerColorOther = Colors.black;
                                  _stopWatchTimerOther.onStopTimer();
                                  clearText();
                                  setState(() {
                                    buttonNameOther = 'other...';
                                  });
                                } else {
                                  bgColorOther =
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 171, 211, 251));
                                  timerColorOther =
                                      Color.fromARGB(255, 0, 175, 6);
                                  _startTimerOther();
                                  _loadSavedText();
                                }
                              } else {
                                // ignore: use_build_context_synchronously
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          SelectorScreen(timerNames: names)),
                                );
                                setState(() {
                                  if (result != null) {
                                    name = result;
                                    prefs.setString('fileNameOther', name!);
                                    buttonNameOther = name!;
                                  }
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  buttonNameOther, // Замените на название вашей кнопки
                                  style: const TextStyle(
                                    color: Colors.black, // Цвет текста
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                if (_stopWatchTimerOther.isRunning)
                                  StreamBuilder<int>(
                                    stream: _stopWatchTimerOther.rawTime,
                                    initialData: totalTimeInSecondsOther,
                                    builder: (context, snapshot) {
                                      return Text(
                                        _formattedTimeOther,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: timerColorOther),
                                      );
                                    },
                                  )
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
                const Text(
                    "Press and hold a button when timer is off to configure "),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  hintText: 'Additional timelog remark',
                  controller: textController,
                  function: _saveText,
                  editingAbility: anyTimerRunning, formKey: null, names: [],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width -
                            (MediaQuery.of(context).size.width / 1.025)),
                    Text('Today',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: Colors.black,
                            fontSize: 16)),
                  ],
                ),
                Container(
                  height: 280,
                  width: MediaQuery.of(context).size.width / 1.05,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Цвет границы
                      width: 3.0, // Ширина границы
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListView.builder(
                    itemCount: names
                        .length, // Замените на количество элементов в вашем списке данных
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(names[index]),
                                Text(
                                  timers[
                                      index], // Замените на данные из второй колонки
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            // Вставьте Divider между строками
                            color: Colors.black, // Цвет полоски
                            thickness: 1.0, // Толщина полоски
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
