// lib/app/onboarding_completion.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/app/app_router.dart';
import 'package:voice_input/features/onboarding/presentation/providers/onboarding_providers.dart';

///Marks on-device onboarding as seen, then replaces the current route with
///This is the single place that owns "onboarding just finished, what happens next"
Future<void> finishOnboarding(
  BuildContext context,
  WidgetRef ref,
) async {
  final service = ref.read(onboardingLocalServiceProvider);

  await service.init();
  await service.setOnboardingSeen();

  ref.invalidate(hasSeenOnboardingProvider);

  if (!context.mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const AppRouter()),
  );
}