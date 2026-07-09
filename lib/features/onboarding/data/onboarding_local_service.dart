// lib/features/onboarding/data/onboarding_local_service.dart

import 'package:hive_flutter/hive_flutter.dart';

/// Stores on-device whether the user has already been shown onboarding.
class OnboardingLocalService {
  static const String _boxName = 'onboarding_box';
  static const String _hasSeenOnboardingKey = 'hasSeenOnboarding';

  Box<bool>? _box;

  ///Opens the local Hive box. Must be called once (e.g. during appstartup) before any other method on this service is used.
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<bool>(_boxName);
  }

  Box<bool> get _onboardingBox {
    final box = _box;
    if (box == null) {
      throw StateError(
          'OnboardingLocalService.init() must be called before use.');
    }
    return box;
  }

  ///Whether onboarding has already been shown on this device.
  bool hasSeenOnboarding() {
    return _onboardingBox.get(_hasSeenOnboardingKey, defaultValue: false) ??
        false;
  }

  ///Marks onboarding as seen (or unseen) on this device.
  Future<void> setOnboardingSeen({bool seen = true}) async {
    await _onboardingBox.put(_hasSeenOnboardingKey, seen);
  }

  ///Clears the stored flag, resetting onboarding to unseen.
  Future<void> clear() async {
    await _onboardingBox.delete(_hasSeenOnboardingKey);
  }
}
