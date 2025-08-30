import 'package:flutter/material.dart';

class TapToSpeak extends StatefulWidget {
  const TapToSpeak({super.key});

  @override
  State<TapToSpeak> createState() => _TapToSpeakState();
}

class _TapToSpeakState extends State<TapToSpeak> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.red,
    );
  }
}
