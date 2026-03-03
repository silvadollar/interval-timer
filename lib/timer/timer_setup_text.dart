import 'package:flutter/material.dart';

class TimerSetupText extends StatelessWidget {
  final int rounds;
  final int minutes;
  final int seconds;
  final bool intervalEnabled;
  final int intervalMinutes;
  final int intervalSeconds;

  const TimerSetupText(
    this.rounds,
    this.minutes,
    this.seconds,
    this.intervalEnabled,
    this.intervalMinutes,
    this.intervalSeconds, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Rounds: $rounds\n'
        'Main: $minutes:${seconds.toString().padLeft(2, '0')}\n'
        'Interval: $intervalMinutes:${intervalSeconds.toString().padLeft(2, '0')}\n'
        'Interval Timer Enabled: ${intervalEnabled ? "Yes" : "No"}',
        style: const TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
      ),
    );
  }
}
