import 'package:flutter/material.dart';

class NovaMic extends StatelessWidget {
  final double width;
  final double height;
  final Color micColor;
  final List<Color> gradientColors;
  const NovaMic({
    super.key,
    this.width = 80,
    this.height = 80,
    this.micColor = Colors.white,
    this.gradientColors = const [
      Color(0xFFBAAEFF),
      Color(0xFFA0B2FA),]
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        //color: Colors.purple.withOpacity(0.5)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            // Color(0xFFBAAEFF), // Lavender
            // Color(0xFFA0B2FA), // Blue-violet
            gradientColors[0],
            gradientColors[1],
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFA0B2FA).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(Icons.mic, color: micColor, size: 45),
        //mic
      ),
    );
  }
}
