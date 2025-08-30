import 'package:flutter/material.dart';

class ZenBubble extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;
  const ZenBubble({super.key, required this.message, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: const Color(0xFFEDE7F6), // A light purple shade
          // color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          fontFamily: 'Rubik',
          color: Color(0xFF5A2F9E),
        ),
      ),
    );
  }
}
