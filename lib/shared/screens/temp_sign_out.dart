import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_input/features/auth/presentation/screens/signup_screen.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SignupScreen()),
            (route) => false,
          );
        }
      },
      //icon: const Icon(Icons.logout),
      //label: const SizedBox.shrink(),
      label: const Text("Out"),
    );
  }
}
