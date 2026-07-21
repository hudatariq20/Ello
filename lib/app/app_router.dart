// lib/app/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/features/auth/presentation/auth_provider/auth_providers.dart';
import 'package:voice_input/features/auth/presentation/screens/login_screen.dart';
import 'package:voice_input/features/ello/presentation/screens/ello_home_screen.dart';



class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUserAsync = ref.watch(AuthUserProvider);

    return authUserAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const LoginScreen(),
      data: (user) {
        if (user == null) return const LoginScreen();
        return ElloHome();
      },
    );
  }
}
