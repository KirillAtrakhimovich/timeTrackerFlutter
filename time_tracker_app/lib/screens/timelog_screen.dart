import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:time_tracker_app/screens/selector_screen.dart';
import 'package:time_tracker_app/widgets/text_field.dart';

class TimelogScreen extends StatefulWidget {
  const TimelogScreen({super.key});

  @override
  State<TimelogScreen> createState() => _TimelogScreentate();
}

class _TimelogScreentate extends State<TimelogScreen> {
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
  bool isTimerActive1 = false;
  bool isTimerActive2 = false;
  bool isTimerActive3 = false;
  bool isTimerActive4 = false;
  bool isTimerActive5 = false;
  bool isTimerActive6 = false;
  bool isTimerActiveOther = false;
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
  MaterialStateProperty<Color?>? timerBgColor1 =
      MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 255, 255, 255));
  Color? timerTextColor1 = Colors.black;
  MaterialStateProperty<Color?>? timerBgColor2 =
      MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 255, 255, 255));
  Color? timerTextColor2 = Colors.black;
  MaterialStateProperty<Color?>? timerBgColor3 =
      MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 255, 255, 255));
  Color? timerTextColor3 = Colors.black;
  MaterialStateProperty<Color?>? timerBgColor4 =
      MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 255, 255, 255));
  Color? timerTextColor4 = Colors.black;
  MaterialStateProperty<Color?>? timerBgColor5 =
      MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 255, 255, 255));
  Color? timerTextColor5 = Colors.black;
  MaterialStateProperty<Color?>? timerBgColor6 =
      MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 255, 255, 255));
  Color? timerTextColor6 = Colors.black;
  MaterialStateProperty<Color?>? timerBgColorOther =
      MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 255, 255, 255));
  Color? timerTextColorOther = Colors.black;
  bool anyTimerRunning = false;

  @override
  void initState() {
    super.initState();
    checkFirstTimeRun();
    _loadButtonNameFromPrefs();
    loadTimers();
    convertTimes();
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
          textController.text = savedText;
        }
      });
    }
  }

  loadTimer1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer1 = prefs.getString('timer1');
    if (timer1 != null) {
      setState(() {
        _formattedTime1 = timer1;
      });
    }
  }

  loadTimer2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer2 = prefs.getString('timer2');
    if (timer2 != null) {
      setState(() {
        _formattedTime2 = timer2;
      });
    }
  }

  loadTimer3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer3 = prefs.getString('timer3');
    if (timer3 != null) {
      setState(() {
        _formattedTime3 = timer3;
      });
    }
  }

  loadTimer4() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer4 = prefs.getString('timer4');
    if (timer4 != null) {
      setState(() {
        _formattedTime4 = timer4;
      });
    }
  }

  loadTimer5() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer5 = prefs.getString('timer5');
    if (timer5 != null) {
      setState(() {
        _formattedTime5 = timer5;
      });
    }
  }

  loadTimer6() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer6 = prefs.getString('timer6');
    if (timer6 != null) {
      setState(() {
        _formattedTime6 = timer6;
      });
    }
  }

  loadTimerOther() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timerOther = prefs.getString('timerOther');
    if (timerOther != null) {
      setState(() {
        _formattedTimeOther = timerOther;
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

  void _startTimer1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timer1 = prefs.getString('timer1');
    int initialTimeInSeconds = totalTimeInSeconds1;

    if (!isTimerActive1) {
      _stopWatchTimer1.setPresetTime(mSec: initialTimeInSeconds * 1000);
      isTimerActive1 = true;
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

    if (!isTimerActive2) {
      _stopWatchTimer2.setPresetTime(mSec: initialTimeInSeconds * 1000);
      isTimerActive2 = true;
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

    if (!isTimerActive3) {
      _stopWatchTimer3.setPresetTime(mSec: initialTimeInSeconds * 1000);
      isTimerActive3 = true;
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

    if (!isTimerActive4) {
      _stopWatchTimer4.setPresetTime(mSec: initialTimeInSeconds * 1000);
      isTimerActive4 = true;
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

    if (!isTimerActive5) {
      _stopWatchTimer5.setPresetTime(mSec: initialTimeInSeconds * 1000);
      isTimerActive5 = true;
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

    if (!isTimerActive6) {
      _stopWatchTimer6.setPresetTime(mSec: initialTimeInSeconds * 1000);
      isTimerActive6 = true;
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

    if (!isTimerActiveOther) {
      _stopWatchTimerOther.setPresetTime(mSec: initialTimeInSeconds * 1000);
      isTimerActiveOther = true;
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

    List<bool> activeTimersStates = [
      isTimerActive1,
      isTimerActive2,
      isTimerActive3,
      isTimerActive4,
      isTimerActive5,
      isTimerActive6,
      isTimerActiveOther,
    ];

    List<String> filteredNames = [];
    List<String> filteredTimers = [];
    List<bool> filteredActiveTimers = [];

    for (int i = 0; i < timers.length; i++) {
      if (timers[i] != "00:00") {
        filteredNames.add(names[i]);
        filteredTimers.add(timers[i]);
        filteredActiveTimers.add(activeTimersStates[i]);
      }
    }

    return Scaffold(
        body: SafeArea(
      child: IntrinsicHeight(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.05,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 111, 190, 255),
                    border: Border.all(
                      color: Colors.black,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: ElevatedButton(
                                onLongPress: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? name = prefs.getString('fileName1');
                                  if (!_stopWatchTimer1.isRunning) {
                                    // ignore: use_build_context_synchronously
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SelectorScreen(
                                              timerNames: names)),
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
                                    side: MaterialStateProperty.all<BorderSide>(
                                        const BorderSide(
                                      width: 2.0,
                                    )),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(255, 0, 0, 0)),
                                    backgroundColor: timerBgColor1),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? name = prefs.getString('fileName1');
                                  // ignore: use_build_context_synchronously
                                  if (buttonName1 != '<empty>') {
                                    if (_stopWatchTimer1.isRunning) {
                                      timerBgColor1 =
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 255, 255, 255));
                                      timerTextColor1 = Colors.black;
                                      _stopWatchTimer1.onStopTimer();
                                      isTimerActive1 = false;
                                      clearText();
                                    } else {
                                      timerBgColor1 =
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 171, 211, 251));
                                      timerTextColor1 =
                                          const Color.fromARGB(255, 0, 175, 6);
                                      _startTimer1();
                                      _loadSavedText();
                                    }
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SelectorScreen(
                                              timerNames: names)),
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
                                child: _stopWatchTimer1.isRunning
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              buttonName1,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          StreamBuilder<int>(
                                            stream: _stopWatchTimer1.rawTime,
                                            initialData: totalTimeInSeconds1,
                                            builder: (context, snapshot) {
                                              return Text(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                _formattedTime1,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: timerTextColor1),
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              buttonName1,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: ElevatedButton(
                                onLongPress: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? name = prefs.getString('fileName2');
                                  if (!_stopWatchTimer2.isRunning) {
                                    // ignore: use_build_context_synchronously
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SelectorScreen(
                                              timerNames: names)),
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
                                    side: MaterialStateProperty.all<BorderSide>(
                                        const BorderSide(
                                      width: 2.0,
                                    )),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(255, 0, 0, 0)),
                                    backgroundColor: timerBgColor2),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? name = prefs.getString('fileName2');
                                  // ignore: use_build_context_synchronously
                                  if (buttonName2 != '<empty>') {
                                    if (_stopWatchTimer2.isRunning) {
                                      timerBgColor2 =
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 255, 255, 255));
                                      timerTextColor2 = Colors.black;
                                      _stopWatchTimer2.onStopTimer();
                                      clearText();
                                      isTimerActive2 = false;
                                    } else {
                                      timerBgColor2 =
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 171, 211, 251));
                                      timerTextColor2 =
                                          const Color.fromARGB(255, 0, 175, 6);
                                      _startTimer2();
                                      _loadSavedText();
                                    }
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SelectorScreen(
                                              timerNames: names)),
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
                                child: _stopWatchTimer2.isRunning
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              buttonName2,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          StreamBuilder<int>(
                                            stream: _stopWatchTimer2.rawTime,
                                            initialData: totalTimeInSeconds2,
                                            builder: (context, snapshot) {
                                              return Text(
                                                _formattedTime2,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: timerTextColor2),
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              buttonName2,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: ElevatedButton(
                                onLongPress: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? name = prefs.getString('fileName3');
                                  if (!_stopWatchTimer3.isRunning) {
                                    // ignore: use_build_context_synchronously
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SelectorScreen(
                                              timerNames: names)),
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
                                    side: MaterialStateProperty.all<BorderSide>(
                                        const BorderSide(
                                      width: 2.0,
                                    )),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(255, 0, 0, 0)),
                                    backgroundColor: timerBgColor3),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? name = prefs.getString('fileName3');
                                  // ignore: use_build_context_synchronously
                                  if (buttonName3 != '<empty>') {
                                    if (_stopWatchTimer3.isRunning) {
                                      timerBgColor3 =
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 255, 255, 255));
                                      timerTextColor3 = Colors.black;
                                      _stopWatchTimer3.onStopTimer();
                                      clearText();
                                      isTimerActive3 = false;
                                    } else {
                                      timerBgColor3 =
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 171, 211, 251));
                                      timerTextColor3 =
                                          const Color.fromARGB(255, 0, 175, 6);
                                      _startTimer3();
                                      _loadSavedText();
                                    }
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SelectorScreen(
                                              timerNames: names)),
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
                                child: _stopWatchTimer3.isRunning
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              buttonName3,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          StreamBuilder<int>(
                                            stream: _stopWatchTimer3.rawTime,
                                            initialData: totalTimeInSeconds3,
                                            builder: (context, snapshot) {
                                              return Text(
                                                _formattedTime3,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: timerTextColor3),
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              buttonName3,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: ElevatedButton(
                                onLongPress: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? name = prefs.getString('fileName4');
                                  if (!_stopWatchTimer4.isRunning) {
                                    // ignore: use_build_context_synchronously
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SelectorScreen(
                                              timerNames: names)),
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
                                    side: MaterialStateProperty.all<BorderSide>(
                                        const BorderSide(
                                      width: 2.0,
                                    )),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(255, 0, 0, 0)),
                                    backgroundColor: timerBgColor4),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? name = prefs.getString('fileName4');
                                  // ignore: use_build_context_synchronously
                                  if (buttonName4 != '<empty>') {
                                    if (_stopWatchTimer4.isRunning) {
                                      timerBgColor4 =
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 255, 255, 255));
                                      timerTextColor4 = Colors.black;
                                      _stopWatchTimer4.onStopTimer();
                                      clearText();
                                      isTimerActive4 = false;
                                    } else {
                                      timerBgColor4 =
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 171, 211, 251));
                                      timerTextColor4 =
                                          const Color.fromARGB(255, 0, 175, 6);
                                      _startTimer4();
                                      _loadSavedText();
                                    }
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SelectorScreen(
                                              timerNames: names)),
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
                                child: _stopWatchTimer4.isRunning
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              buttonName4,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          StreamBuilder<int>(
                                            stream: _stopWatchTimer4.rawTime,
                                            initialData: totalTimeInSeconds4,
                                            builder: (context, snapshot) {
                                              return Text(
                                                _formattedTime4,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: timerTextColor4),
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              buttonName4,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: ElevatedButton(
                                onLongPress: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? name = prefs.getString('fileName5');
                                  if (!_stopWatchTimer5.isRunning) {
                                    // ignore: use_build_context_synchronously
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SelectorScreen(
                                              timerNames: names)),
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
                                    side: MaterialStateProperty.all<BorderSide>(
                                        const BorderSide(
                                      width: 2.0,
                                    )),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(255, 0, 0, 0)),
                                    backgroundColor: timerBgColor5),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? name = prefs.getString('fileName5');
                                  // ignore: use_build_context_synchronously
                                  if (buttonName5 != '<empty>') {
                                    if (_stopWatchTimer5.isRunning) {
                                      timerBgColor5 =
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 255, 255, 255));
                                      timerTextColor5 = Colors.black;
                                      _stopWatchTimer5.onStopTimer();
                                      clearText();
                                      isTimerActive5 = false;
                                    } else {
                                      timerBgColor5 =
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 171, 211, 251));
                                      timerTextColor5 =
                                          const Color.fromARGB(255, 0, 175, 6);
                                      _startTimer5();
                                      _loadSavedText();
                                    }
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SelectorScreen(
                                              timerNames: names)),
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
                                child: _stopWatchTimer5.isRunning
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              buttonName5,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          StreamBuilder<int>(
                                            stream: _stopWatchTimer5.rawTime,
                                            initialData: totalTimeInSeconds5,
                                            builder: (context, snapshot) {
                                              return Text(
                                                _formattedTime2,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: timerTextColor5),
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              buttonName5,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: ElevatedButton(
                                onLongPress: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? name = prefs.getString('fileName6');
                                  if (!_stopWatchTimer6.isRunning) {
                                    // ignore: use_build_context_synchronously
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SelectorScreen(
                                              timerNames: names)),
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
                                    side: MaterialStateProperty.all<BorderSide>(
                                        const BorderSide(
                                      width: 2.0,
                                    )),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(255, 0, 0, 0)),
                                    backgroundColor: timerBgColor6),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? name = prefs.getString('fileName6');
                                  // ignore: use_build_context_synchronously
                                  if (buttonName6 != '<empty>') {
                                    if (_stopWatchTimer6.isRunning) {
                                      timerBgColor6 =
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 255, 255, 255));
                                      timerTextColor6 = Colors.black;
                                      _stopWatchTimer6.onStopTimer();
                                      clearText();
                                      isTimerActive6 = false;
                                    } else {
                                      timerBgColor6 =
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 171, 211, 251));
                                      timerTextColor6 =
                                          const Color.fromARGB(255, 0, 175, 6);
                                      _startTimer6();
                                      _loadSavedText();
                                    }
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SelectorScreen(
                                              timerNames: names)),
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
                                child: _stopWatchTimer6.isRunning
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              buttonName6,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          StreamBuilder<int>(
                                            stream: _stopWatchTimer6.rawTime,
                                            initialData: totalTimeInSeconds6,
                                            builder: (context, snapshot) {
                                              return Text(
                                                _formattedTime6,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: timerTextColor6),
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              buttonName6,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6))),
                                    side: MaterialStateProperty.all<BorderSide>(
                                        const BorderSide(
                                      width: 2.0,
                                    )),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(255, 0, 0, 0)),
                                    backgroundColor: timerBgColorOther),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? name =
                                      prefs.getString('fileNameOther');
                                  // ignore: use_build_context_synchronously
                                  if (buttonNameOther != 'other...') {
                                    if (_stopWatchTimerOther.isRunning) {
                                      timerBgColorOther =
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 255, 255, 255));
                                      timerTextColorOther = Colors.black;
                                      _stopWatchTimerOther.onStopTimer();
                                      clearText();
                                      isTimerActiveOther = false;
                                      setState(() {
                                        buttonNameOther = 'other...';
                                      });
                                    }
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SelectorScreen(
                                              timerNames: names)),
                                    );
                                    setState(() {
                                      if (result != null) {
                                        name = result;
                                        prefs.setString('fileNameOther', name!);
                                        buttonNameOther = name!;
                                        timerBgColorOther =
                                            MaterialStateProperty.all<Color>(
                                                const Color.fromARGB(
                                                    255, 171, 211, 251));
                                        timerTextColorOther =
                                            const Color.fromARGB(
                                                255, 0, 175, 6);
                                        _startTimerOther();
                                        _loadSavedText();
                                      }
                                    });
                                  }
                                },
                                child: _stopWatchTimerOther.isRunning
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              buttonNameOther,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          StreamBuilder<int>(
                                            stream:
                                                _stopWatchTimerOther.rawTime,
                                            initialData:
                                                totalTimeInSecondsOther,
                                            builder: (context, snapshot) {
                                              return Text(
                                                _formattedTimeOther,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: timerTextColorOther),
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              buttonNameOther,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                      ),
                    ],
                  ),
                ),
                const Text(
                    "Press and hold a button when timer is off to configure "),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                CustomTextField(
                  hintText: 'Additional timelog remark',
                  controller: textController,
                  function: _saveText,
                  editingAbility: anyTimerRunning,
                  formKey: null,
                  names: const [],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width -
                            (MediaQuery.of(context).size.width / 1.025)),
                    const Text('Today',
                        style: TextStyle(
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
                      color: Colors.black,
                      width: 3.0,
                    ),
                  ),
                  child: ListView.separated(
                    itemCount: filteredNames.length,
                    itemBuilder: (context, index) {
                      Color backgroundColor = filteredActiveTimers[index]
                          ? const Color.fromARGB(255, 111, 190, 255)
                          : Colors.white;

                      return Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(filteredNames[index],
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(filteredTimers[index],
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(height: 0.3, color: Colors.black);
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 60,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
