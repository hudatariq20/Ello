// lib/features/onboarding/presentation/onboarding_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/features/onboarding/data/onboarding_local_service.dart';

final onboardingLocalServiceProvider = Provider<OnboardingLocalService>((ref) {
  return OnboardingLocalService();
});
