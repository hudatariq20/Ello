import 'package:flutter/material.dart';

class ElloBottomNavigation extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;

  const ElloBottomNavigation({
    super.key,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72 + MediaQuery.paddingOf(context).bottom,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: backgroundColor,
        surfaceTintColor: Colors.transparent,
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom,
        ),
        child: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.home_outlined, color: iconColor),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.history, color: iconColor),
              ),
              const SizedBox(width: 64),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.chat_bubble_outline, color: iconColor),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.person_outline, color: iconColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}