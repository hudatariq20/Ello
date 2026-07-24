import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voice_input/app/startup_gate.dart';
import 'package:voice_input/features/onboarding/data/onboarding_local_service.dart';
import 'package:voice_input/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:voice_input/shared/providers/persona_theme_provider.dart';
import 'package:voice_input/shared/theme/app_theme.dart';

import 'firebase_options.dart';

bool _isEnvLoaded = false;

Future<void> loadEnvOnce() async {
  if (_isEnvLoaded) return;

  await dotenv.load(fileName: '.env');
  _isEnvLoaded = true;

  debugPrint('✅ .env loaded');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadEnvOnce();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final onboardingService = OnboardingLocalService();
  await onboardingService.init();

  runApp(
    ProviderScope(
      overrides: [
        onboardingLocalServiceProvider.overrideWithValue(
          onboardingService,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personaTheme = ref.watch(personaThemeProvider);

    return MaterialApp(
      title: 'Ello',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(personaTheme),
      themeAnimationDuration: const Duration(milliseconds: 400),
      themeAnimationCurve: Curves.easeInOut,
      home: const StartupGate(),
    );
  }
}