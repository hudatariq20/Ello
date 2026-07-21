import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ElloAssistantOrb extends StatefulWidget {
  const ElloAssistantOrb({super.key});

  @override
  State<ElloAssistantOrb> createState() => _ElloAssistantOrbState();
}

class _ElloAssistantOrbState extends State<ElloAssistantOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bounceAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(
      begin: 0,
      end: -10,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.96,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: SizedBox(
        width: 150,
        height: 150,
        child: Lottie.asset(
          'assets/images/AI.json',
          repeat: true,
          fit: BoxFit.contain,
        ),
      ),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
    );
  }
}