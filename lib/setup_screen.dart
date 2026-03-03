import 'package:flutter/material.dart';

class SetupScreen extends StatefulWidget {
  final Function(
    int rounds,
    int minutes,
    int seconds,
    bool intervalEnabled,
    int intervalMinutes,
    int intervalSeconds,
  ) onSave;

  const SetupScreen({
    super.key,
    required this.onSave,
  });

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int rounds = 1;
  int minutesLeft = 0;
  int secondsLeft = 0;
  bool intervalTimerEnabled = false;
  int intervalMinutesLeft = 0;
  int intervalSecondsLeft = 0;

  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Screen'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.all(40),
        child: ListView(
          children: [
            const Text('Enter timer settings below. '
                'Timer minutes and seconds will be used for the main game timer. '
                'Interval timer minutes and seconds will be used for the break between games if enabled. '
                'Timer will start with a warmup period for the first "interval/break".'),
            FormField(builder: (context) {
              return TextFormField(
                enabled: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of Rounds',
                ),
                onChanged: (value) {
                  setState(() {
                    rounds = int.tryParse(value) ?? 1;
                  });
                },
              );
            }),
            FormField(builder: (context) {
              return TextFormField(
                enabled: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Timer Minutes',
                ),
                onChanged: (value) {
                  setState(() {
                    minutesLeft = int.tryParse(value) ?? 0;
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
                    secondsLeft = int.tryParse(value) ?? 0;
                  });
                },
              );
            }),
            Container(
              margin: const EdgeInsets.only(
                top: 20,
                left: 40,
              ),
              child: Row(
                children: [
                  Checkbox(
                    semanticLabel: 'Enable Interval Timer',
                    value: intervalTimerEnabled,
                    onChanged: (value) {
                      setState(
                        () {
                          intervalTimerEnabled = value ?? false;
                        },
                      );
                    },
                  ),
                  const Text(
                      'Enable Interval Timer. Used for breaks between rounds and a warmup period.'),
                ],
              ),
            ),
            FormField(builder: (context) {
              return TextFormField(
                enabled: intervalTimerEnabled,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Interval Timer Minutes',
                ),
                onChanged: (value) {
                  setState(() {
                    intervalMinutesLeft = int.tryParse(value) ?? 0;
                  });
                },
              );
            }),
            FormField(builder: (context) {
              return TextFormField(
                enabled: intervalTimerEnabled,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Interval Timer Seconds',
                ),
                onChanged: (value) {
                  setState(() {
                    intervalSecondsLeft = int.tryParse(value) ?? 0;
                  });
                },
              );
            }),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: _saving
                        ? Colors.grey[800]
                        : const Color.fromARGB(255, 15, 56, 90),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _saving = true;
                      });
                      widget.onSave(
                        rounds,
                        minutesLeft,
                        secondsLeft,
                        intervalTimerEnabled,
                        intervalMinutesLeft,
                        intervalSecondsLeft,
                      );
                    },
                    icon: Icon(_saving ? Icons.hourglass_bottom : Icons.save,
                        color: _saving ? Colors.grey[600] : Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
