import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/app/app_router.dart';
import 'package:voice_input/app/onboarding_completion.dart';
import 'package:voice_input/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:voice_input/features/onboarding/presentation/screens/onboarding_flow_screen.dart';

class StartupGate extends ConsumerWidget {
  const StartupGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasSeenOnboarding = ref.watch(hasSeenOnboardingProvider);

    if (!hasSeenOnboarding) {
      return OnboardingFlow(onFinished: () => finishOnboarding(context, ref));
    }
    return const AppRouter();
  }
}