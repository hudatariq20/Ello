// lib/app/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/features/auth/presentation/auth_provider/auth_providers.dart';
import 'package:voice_input/features/auth/presentation/screens/login_screen.dart';
import 'package:voice_input/features/ello/screens/ello_home_screen.dart';
import 'package:voice_input/features/personas/nova/presentation/screens/nova_hub.dart';

import 'package:voice_input/features/personas/nova/presentation/screens/nova_todo_addTaskToday.dart';
import 'package:voice_input/features/personas/nova/presentation/screens/nova_todo_reminder.dart';
import 'package:voice_input/features/personas/nova/presentation/widgets/nova_grocery_dialog.dart';
import 'package:voice_input/shared/screens/chat_screen.dart';
import 'package:voice_input/shared/screens/ello_screen.dart';
import 'package:voice_input/shared/screens/persona_presets.dart';
import 'package:voice_input/shared/widgets/persona_card.dart';


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
