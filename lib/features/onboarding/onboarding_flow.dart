import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/features/ello/screens/ello_home.dart';
import 'package:voice_input/shared/models/personaTheme_model.dart';
import 'package:voice_input/shared/providers/providers.dart';
import 'package:voice_input/shared/screens/ello_screen.dart';
import 'package:voice_input/shared/widgets/widgets.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final PageController _pageController =
      PageController(); //For maintaining the page controller for the onboarding cards
  int _currentPage = 0;

  void _gotoNextPage() async {
    final totalPages = 4;
    final currentIndex = _pageController.page?.round() ?? 0;
    if (currentIndex < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      //Mark onboarding complete in firebase
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'onboardingCompleted': true,
        });
      }
      //navigate to Ello screen
      //LOGIC NEEDS TO BE IF ONBOARDING IS FALSE, GO TO ONBOARDING SCREEN ELSE GO TO ELLO SCREEN
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ElloHomeScreen()),
        );
      }

      // Reset theme after navigation to avoid frame rebuild lag
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(personaThemeProvider.notifier).setPersona("Zen");
      });
    }
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
                themeNotifier.setPersona("Zen");
                break;
              case 1:
                themeNotifier.setPersona("Nova");
                break;
              case 2:
                themeNotifier.setPersona("Sage");
                break;
              case 3:
                themeNotifier.setPersona("Spark");
                break;
            }
          }),
    );
  }
}
