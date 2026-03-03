import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pickleball_timer/timer/finished_text.dart';
import 'package:pickleball_timer/timer/timer_setup_text.dart';
import 'package:pickleball_timer/timer/timer_text.dart';

enum TimerPhase {
  idle,
  ready,
  timerRunning,
  intervalTimerRunning,
  finished,
}

class TimerScreen extends StatefulWidget {
  final int rounds;
  final int minutes;
  final int seconds;
  final bool intervalEnabled;
  final int intervalMinutes;
  final int intervalSeconds;
  final Function(TimerPhase) onPhaseChanged;

  const TimerScreen({
    super.key,
    required this.rounds,
    required this.minutes,
    required this.seconds,
    required this.intervalEnabled,
    required this.intervalMinutes,
    required this.intervalSeconds,
    required this.onPhaseChanged,
  });

  @override
  State<TimerScreen> createState() => TimerScreenState();
}

class TimerScreenState extends State<TimerScreen> {
  late int copyRounds;
  late int copyMinutes;
  late int copySeconds;
  late int copyIntervalMinutes;
  late int copyIntervalSeconds;
  var timerRunning = false;
  TimerPhase _phase = TimerPhase.ready;
  Timer? _timer;

  void toggleTimer() {
    if (_phase == TimerPhase.ready || _phase == TimerPhase.finished) {
      if (widget.intervalEnabled) {
        _startIntervalTimer();
      } else {
        _startMainTimer();
      }
    } else {
      _stopTimer();
    }
  }

  void _startMainTimer() {
    copyMinutes = widget.minutes;
    copySeconds = widget.seconds;

    setState(() {
      _phase = TimerPhase.timerRunning;
    });

    widget.onPhaseChanged(TimerPhase.timerRunning);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (copyMinutes > 0 && copySeconds == 0) {
          copyMinutes--;
          copySeconds = 59;
        } else if (copySeconds > 0) {
          copySeconds--;
        } else {
          timer.cancel();
          _onMainFinished();
        }
      });
    });
  }

  void _onMainFinished() {
    copyRounds--;

    if (copyRounds > 0) {
      if (widget.intervalEnabled) {
        _startIntervalTimer();
      } else {
        _startMainTimer();
      }
    } else {
      _finishAll();
    }
  }

  void _startIntervalTimer() {
    copyIntervalMinutes = widget.intervalMinutes;
    copyIntervalSeconds = widget.intervalSeconds;

    setState(() {
      _phase = TimerPhase.intervalTimerRunning;
    });

    widget.onPhaseChanged(TimerPhase.intervalTimerRunning);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (copyIntervalMinutes > 0 && copyIntervalSeconds == 0) {
          copyIntervalMinutes--;
          copyIntervalSeconds = 59;
        } else if (copyIntervalSeconds > 0) {
          copyIntervalSeconds--;
        } else {
          timer.cancel();

          if (_phase == TimerPhase.intervalTimerRunning &&
              widget.intervalEnabled) {
            _startMainTimer();
          }
        }
      });
    });
  }

  void _finishAll() {
    setState(() {
      _phase = TimerPhase.finished;
    });

    widget.onPhaseChanged(TimerPhase.finished);
  }

  void _stopTimer() {
    _timer?.cancel();

    setState(() {
      _phase = TimerPhase.ready;
    });

    widget.onPhaseChanged(TimerPhase.ready);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    copyRounds = widget.rounds;
    copyMinutes = widget.minutes;
    copySeconds = widget.seconds;
    copyIntervalMinutes = widget.intervalMinutes;
    copyIntervalSeconds = widget.intervalSeconds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return switch (_phase) {
      TimerPhase.timerRunning => TimerText(
          mins: copyMinutes,
          seconds: copySeconds,
          text:
              'Playing Round ${widget.rounds - copyRounds + 1} of ${widget.rounds}',
        ),
      TimerPhase.intervalTimerRunning => TimerText(
          mins: copyIntervalMinutes,
          seconds: copyIntervalSeconds,
          text: widget.rounds - copyRounds == 0
              ? 'Warm-up before Round 1 of ${widget.rounds}'
              : 'Break for Round ${widget.rounds - copyRounds + 1} of ${widget.rounds}',
        ),
      TimerPhase.finished => const FinishedText(),
      TimerPhase.ready || TimerPhase.idle => TimerSetupText(
          copyRounds,
          copyMinutes,
          copySeconds,
          widget.intervalEnabled,
          copyIntervalMinutes,
          copyIntervalSeconds,
        ),
    };
  }
}
