// lib/features/onboarding/presentation/onboarding_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/features/onboarding/data/onboarding_local_service.dart';

final onboardingLocalServiceProvider = Provider<OnboardingLocalService>((ref) {
  return OnboardingLocalService();//provide an OnboardingLocalService whenever something needs it
});

///Whether this device has already seen onboarding, per the local Hive flag.
final hasSeenOnboardingProvider = Provider<bool>((ref) {
  final service = ref.watch(onboardingLocalServiceProvider);
  return service.hasSeenOnboarding();
});