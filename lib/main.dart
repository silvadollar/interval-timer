import 'package:flutter/material.dart';
import 'package:pickleball_timer/setup_screen.dart';
import 'package:pickleball_timer/timer_screen.dart';
import 'dart:html' as html;
import 'package:text_scroll/text_scroll.dart';

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
  TimerPhase currentPhase = TimerPhase.idle;
  GlobalKey<TimerScreenState> timerKey = GlobalKey<TimerScreenState>();

  int rounds = 1;
  int minutes = 0;
  int seconds = 0;
  bool intervalEnabled = false;
  int intervalMinutes = 0;
  int intervalSeconds = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).colorScheme.primary,
          child: Container(
            height: 50,
            alignment: Alignment.center,
            child: Column(
              children: [
                currentPhase == TimerPhase.intervalTimerRunning
                    ? const Expanded(
                        child: TextScroll(
                          'Created by: Nick Silva! '
                          '                '
                          'Don\'t forget to drink water. '
                          '                '
                          'Stretching is good for you. '
                          '                '
                          'Have fun its just a game. '
                          '                '
                          'Feel free to make a donation to nicksplace.org if you like the app. '
                          '                '
                          'Follow me on Instagram @silvadollar_ because I can write whatever I want here. ╭∩╮(Ο_Ο)╭∩╮ '
                          '                '
                          'Thank you for using my app! '
                          '                '
                          'Suggestions can be put in the nearest trash can. '
                          '                '
                          'Lol I am just kidding <3 '
                          '                '
                          'But seriously, if you have any suggestions or want to see a new feature, let me know! '
                          '                ',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                          velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
                        ),
                      )
                    : const Text(
                        'Designed by: Nick Silva',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
              ],
            ),
          ),
        ),
        backgroundColor: switch (currentPhase) {
          TimerPhase.idle => Colors.white,
          TimerPhase.ready => const Color.fromARGB(255, 196, 133, 39),
          TimerPhase.timerRunning => const Color.fromARGB(255, 34, 113, 36),
          TimerPhase.intervalTimerRunning =>
            const Color.fromARGB(255, 101, 27, 114),
          TimerPhase.finished => const Color.fromARGB(255, 22, 66, 163),
        },
        body: currentPhase == TimerPhase.idle
            ? SetupScreen(
                onSave: (r, m, s, iEnabled, iMin, iSec) {
                  setState(() {
                    rounds = r;
                    minutes = m;
                    seconds = s;
                    intervalEnabled = iEnabled;
                    intervalMinutes = iMin;
                    intervalSeconds = iSec;
                    currentPhase = TimerPhase.ready;
                  });
                },
              )
            : TimerScreen(
                key: timerKey,
                rounds: rounds,
                minutes: minutes,
                seconds: seconds,
                intervalEnabled: intervalEnabled,
                intervalMinutes: intervalMinutes,
                intervalSeconds: intervalSeconds,
                onPhaseChanged: (phase) {
                  setState(() {
                    currentPhase = phase;
                  });
                },
              ),
        floatingActionButton: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomRight,
              child: currentPhase == TimerPhase.ready ||
                      currentPhase == TimerPhase.timerRunning ||
                      currentPhase == TimerPhase.intervalTimerRunning ||
                      currentPhase == TimerPhase.finished
                  ? FloatingActionButton(
                      onPressed: () {
                        if (currentPhase == TimerPhase.finished) {
                          html.window.location.reload();
                          return;
                        } else {
                          timerKey.currentState?.toggleTimer();
                        }
                      },
                      tooltip: switch (currentPhase) {
                        TimerPhase.ready => 'Start Timer',
                        TimerPhase.timerRunning => 'Stop Timer',
                        TimerPhase.intervalTimerRunning => 'Stop Timer',
                        TimerPhase.finished => 'Reset Timer',
                        _ => 'Start Timer',
                      },
                      backgroundColor: switch (currentPhase) {
                        TimerPhase.ready =>
                          const Color.fromARGB(255, 30, 76, 31),
                        TimerPhase.timerRunning =>
                          const Color.fromARGB(255, 55, 54, 53),
                        TimerPhase.intervalTimerRunning =>
                          const Color.fromARGB(255, 55, 54, 53),
                        TimerPhase.finished =>
                          const Color.fromARGB(255, 15, 41, 98),
                        _ => const Color.fromARGB(255, 30, 76, 31),
                      },
                      foregroundColor: Colors.white,
                      child: switch (currentPhase) {
                        TimerPhase.ready => const Icon(Icons.play_arrow),
                        TimerPhase.timerRunning => const Icon(Icons.stop),
                        TimerPhase.intervalTimerRunning =>
                          const Icon(Icons.stop),
                        TimerPhase.finished => const Icon(Icons.refresh),
                        _ => const Icon(Icons.play_arrow),
                      },
                    )
                  : null,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: currentPhase == TimerPhase.ready
                    ? FloatingActionButton(
                        onPressed: () {
                          html.window.location.reload();
                          return;
                        },
                        tooltip: 'Reset Timer',
                        backgroundColor: const Color.fromARGB(255, 15, 41, 98),
                        foregroundColor: Colors.white,
                        child: const Icon(Icons.refresh),
                      )
                    : null,
              ),
            ),
          ],
        ));
  }
}
