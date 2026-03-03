import 'package:flutter/material.dart';

class TimerText extends StatefulWidget {
  const TimerText({
    required this.mins,
    required this.seconds,
    required this.text,
    super.key,
  });

  final int mins;
  final int seconds;
  final String text;

  @override
  State<TimerText> createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            '${widget.text}!',
            style: const TextStyle(
              fontSize: 92,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(child: Container()),
          Container(
            padding: const EdgeInsets.only(bottom: 100),
            child: Text(
              '${widget.mins.toString().padLeft(2, '0')}:${widget.seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 300,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
