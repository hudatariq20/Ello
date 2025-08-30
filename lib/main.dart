import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_input/shared/models/personaTheme_model.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/personas/ nova/presentation/screens/nova_screen.dart';
import 'firebase_options.dart';

bool _isEnvLoaded = false;

Future<void> loadEnvOnce() async {
  if (!_isEnvLoaded) {
    await dotenv.load(fileName: '.env');
    _isEnvLoaded = true;
    debugPrint("✅ .env loaded");
  }
}

void main() async {
  await loadEnvOnce();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

//CONVERT TO STATEFUL WIDGET
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late PersonaTheme personaTheme;
  @override
  void initState() {
    super.initState();
    personaTheme = ref.read(personaThemeProvider);
    //ref.read(personaThemeProvider.notifier).setPersona("Nova");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(personaThemeProvider.notifier).setPersona("Nova");
    });
  }

  @override
  Widget build(BuildContext context) {
    //final personaTheme = ref.watch(personaThemeProvider);
    // Listen and update state when theme changes
    ref.listen(personaThemeProvider, (previous, next) {
      if (previous != next) {
        setState(() {
          personaTheme = next;
        });
      }
    });

    return AnimatedTheme(
      data: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: personaTheme.gradientColors.first,
          brightness: Brightness.light,
        ),
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: personaTheme
                .gradientColors.first, // Dynamically use persona seed color
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: AppBarTheme(
            backgroundColor: personaTheme.appBarColor,
            elevation: 2,
            foregroundColor: personaTheme.appBarIconColor,
            titleTextStyle: GoogleFonts.urbanist(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: personaTheme.appBarIconColor,
            ),
          ),
        ),

        //home:  PersonaPresets(initialText: ""),
        // home: const ElloHomeScreen(),
        home: const NovaTodoAddTaskToday(),
        //home: const NovaHubScreen(),
        // home: const OnboardingFlow(),
        //home: const Scaffold(body: ZenJournalScreen()),
      ),
    );
  }
}
