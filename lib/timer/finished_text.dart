import 'package:flutter/material.dart';

class FinishedText extends StatefulWidget {
  const FinishedText({super.key});

  @override
  State<FinishedText> createState() => _FinishedTextState();
}

class _FinishedTextState extends State<FinishedText> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(child: Container()),
          const Text(
            'GAME OVER!\nThanks for playing!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 150,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
