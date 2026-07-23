import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/shared/theme/persona_theme_model.dart';
import 'package:voice_input/shared/providers/persona_theme_provider.dart';
import 'package:voice_input/shared/theme/persona_type.dart';
import 'package:voice_input/shared/widgets/widgets.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key, required this.onFinished});

  final Future<void> Function() onFinished;

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final PageController _pageController =
      PageController(); //For maintaining the page controller for the onboarding cards
  int _currentPage = 0;

  Future<void> _gotoNextPage() async {
    final currentIndex = _pageController.page?.round() ?? 0;

    if (currentIndex < 3) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      return;
    }

    await widget.onFinished();

    ref.read(personaThemeProvider.notifier).setPersona(PersonaType.nova);
  }

  List<Widget> _buildOnboardingScreens(PersonaTheme personaTheme) {
    return [
      OnboardingCard(
          iconPath: 'assets/icons/zen_icon.png',
          title: "Zen - ",
          description: "Your Calm Space.",
          buttonText: "Let's Continue",
          onButtonPressed: _gotoNextPage,
          buttonColor: personaTheme.gradientColors.last,
          widgetText: Colors.deepPurple,
          // topcurvedBarColor: personaTheme.buttonColors[1].withOpacity(0.2),
          // bottomcurvedBarColor: personaTheme.buttonColors[1].withOpacity(0.2),
          controller: _pageController,
          currentPage: _currentPage,
          totalPages: 4,
          buttonGradient: LinearGradient(
            colors: personaTheme.buttonColors,
          )),
      OnboardingCard(
          iconPath: 'assets/icons/nova_icon.png',
          title: "Meet Nova - ",
          description: "Your Smart Assistant",
          buttonText: "Got it - Next",
          onButtonPressed: _gotoNextPage,
          buttonColor: personaTheme.gradientColors.first,
          widgetText: Colors.black,
          // topcurvedBarColor: personaTheme.appBarIconColor.withOpacity(0.5),
          // bottomcurvedBarColor: personaTheme.appBarIconColor.withOpacity(0.5),
          controller: _pageController,
          currentPage: _currentPage,
          totalPages: 4,
          buttonGradient: LinearGradient(
            colors: personaTheme.buttonColors,
          )),
      OnboardingCard(
          iconPath: 'assets/icons/sage_icon.png',
          title: "Sage - ",
          description: "Trusted Parenting Advice",
          buttonText: "Next",
          onButtonPressed: _gotoNextPage,
          buttonColor: personaTheme.gradientColors.first,
          widgetText: Colors.black,
          //topcurvedBarColor: personaTheme.appBarIconColor.withOpacity(0.5),
          //bottomcurvedBarColor: personaTheme.appBarIconColor.withOpacity(0.5),
          controller: _pageController,
          currentPage: _currentPage,
          totalPages: 4,
          buttonGradient: LinearGradient(
            colors: personaTheme.buttonColors,
          )),
      OnboardingCard(
          iconPath: 'assets/icons/spark_icon.png',
          title: "Spark - ",
          description: "Your Planning Buddy",
          buttonText: "Let's Get Started",
          onButtonPressed: _gotoNextPage,
          buttonColor: personaTheme.gradientColors.first,
          widgetText: Colors.black,
          // topcurvedBarColor: personaTheme.appBarIconColor.withOpacity(0.5),
          //bottomcurvedBarColor: personaTheme.appBarIconColor.withOpacity(0.5),
          controller: _pageController,
          currentPage: _currentPage,
          totalPages: 4,
          buttonGradient: LinearGradient(
            colors: personaTheme.buttonColors,
          ))
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final personaTheme = ref.watch(personaThemeProvider);
    final _onboardingScreens = _buildOnboardingScreens(personaTheme);

    return Scaffold(
      body: PageView.builder(
          controller: _pageController,
          itemBuilder: (context, index) {
            return _onboardingScreens[index];
          },
          itemCount: _onboardingScreens.length,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
            final themeNotifier = ref.read(personaThemeProvider.notifier);

            switch (index) {
              case 0:
                themeNotifier.setPersona(PersonaType.nova);
                break;
              case 1:
                themeNotifier.setPersona(PersonaType.zen);
                break;
              case 2:
                themeNotifier.setPersona(PersonaType.sage);
                break;
              case 3:
                themeNotifier.setPersona(PersonaType.spark);
                break;
            }
          }),
    );
  }
}
