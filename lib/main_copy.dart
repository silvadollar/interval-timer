import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pickleball Timer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Pickleball Timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? _timer;
  var timerRunning = false;
  int _minutesLeft = 0;
  int _secondsLeft = 10;

  Timer? _intervalTimer;
  var intervalTimerEnabled = false;
  var intervalTimerRunning = false;
  int _intervalMinutesLeft = 0;
  int _intervalSecondsLeft = 0;

  int workingMinutes = 0;
  int workingSeconds = 0;
  int intervalWorkingMinutes = 0;
  int intervalWorkingSeconds = 0;

  void _startTimer() {
    workingMinutes = _minutesLeft;
    workingSeconds = _secondsLeft;
    intervalWorkingMinutes = _intervalMinutesLeft;
    intervalWorkingSeconds = _intervalSecondsLeft;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(
        () {
          timerRunning = true;
          if (workingMinutes > 0 && workingSeconds == 0) {
            workingMinutes--;
            workingSeconds = 59;
          } else if (workingSeconds > 0) {
            workingSeconds--;
          } else if (workingMinutes == 0 && workingSeconds == 0) {
            if (intervalTimerEnabled) {
              timer.cancel();
              intervalTimerRunning = true;
              _runIntervalTimer(intervalWorkingMinutes, intervalWorkingSeconds);
            } else {
              timer.cancel();
            }
          }
        },
      );
    });
  }

  void _runIntervalTimer(int min, int sec) {
    int workingMins = min;
    int workingSecs = sec;
    _intervalTimer =
        Timer.periodic(const Duration(seconds: 1), (intervalTimer) {
      setState(
        () {
          if (workingMins > 0 && workingSecs == 0) {
            workingMins--;
            workingSecs = 59;
          } else if (workingSecs > 0) {
            workingSecs--;
          } else if (workingMins == 0 && workingSecs == 0) {
            intervalTimer.cancel();
            intervalTimerRunning = false;
            _startTimer();
          }
        },
      );
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _intervalTimer?.cancel();
    setState(() {
      timerRunning = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _intervalTimer?.cancel();
    super.dispose();
  }

  onload() {
    setState(
      () {
        workingMinutes = _minutesLeft;
        workingSeconds = _secondsLeft;
        intervalWorkingMinutes = _intervalMinutesLeft;
        intervalWorkingSeconds = _intervalSecondsLeft;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.settings),
              );
            },
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            FormField(builder: (context) {
              return TextFormField(
                enabled: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Timer Minutes',
                ),
                onChanged: (value) {
                  setState(() {
                    _minutesLeft = int.tryParse(value) ?? 0;
                  });
                },
              );
            }),
            FormField(builder: (context) {
              return TextFormField(
                enabled: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Timer Seconds',
                ),
                onChanged: (value) {
                  setState(() {
                    _secondsLeft = int.tryParse(value) ?? 0;
                  });
                },
              );
            }),
            Checkbox(
              value: intervalTimerEnabled,
              onChanged: (bool? value) {
                setState(
                  () {
                    intervalTimerEnabled = value ?? false;
                  },
                );
              },
            ),
            FormField(builder: (context) {
              return TextFormField(
                enabled: intervalTimerEnabled,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Interval Minutes',
                ),
                onChanged: (value) {
                  setState(() {
                    _intervalMinutesLeft = int.tryParse(value) ?? 0;
                  });
                },
              );
            }),
            FormField(builder: (context) {
              return TextFormField(
                enabled: intervalTimerEnabled,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Interval Seconds',
                ),
                onChanged: (value) {
                  setState(() {
                    _intervalSecondsLeft = int.tryParse(value) ?? 0;
                  });
                },
              );
            }),
          ],
        ),
      ),
      backgroundColor: timerRunning
          ? intervalTimerRunning
              ? Colors.purple
              : Colors.green
          : Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            intervalTimerRunning
                ? Text(
                    '${intervalWorkingMinutes.toString().padLeft(2, '0')}:${intervalWorkingSeconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 92,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                : Text(
                    '${workingMinutes.toString().padLeft(2, '0')}:${workingSeconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 92,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: timerRunning ? _stopTimer : _startTimer,
        tooltip: timerRunning ? 'Stop Timer' : 'Start Timer',
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: Icon(timerRunning ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
