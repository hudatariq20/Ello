import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:voice_input/shared/widgets/widgets.dart';

class OnboardingCard extends ConsumerStatefulWidget {
  final String iconPath;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final Color buttonColor;
  final Color widgetText;
  final PageController controller;
  final int currentPage;
  final int totalPages;
  final Gradient buttonGradient;
  const OnboardingCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onButtonPressed,
    required this.buttonColor,
    required this.widgetText,
    required this.controller,
    required this.currentPage,
    required this.totalPages,
    required this.buttonGradient,
  });

  @override
  ConsumerState<OnboardingCard> createState() => _OnboardingCardState();
}

class _OnboardingCardState extends ConsumerState<OnboardingCard> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late final theme = ref.watch(personaThemeProvider);
    return GradientBackground(
      child: Stack(children: [
        //top curved bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
            ),
          ),
        ),
        //bottom curved bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: SmoothPageIndicator(
                      controller: widget.controller,
                      count: widget.totalPages,
                      effect: ExpandingDotsEffect(
                          activeDotColor: theme.buttonColors[1],
                          dotColor: Colors.grey,
                          dotHeight: 10,
                          dotWidth: 10,
                          spacing: 5),
                    )),
                  ],
                ),
              )),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Expanded(child: child),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.buttonColors[1].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    widget.iconPath, // Use the imagePath here
                    width: 96,
                    height: 96,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 56),
                Text(widget.title,
                    style: TextStyle(
                        fontSize: 40,
                        color: widget.widgetText,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Rubik')),
                //const SizedBox(height: 12),
                Container(
                  constraints: const BoxConstraints(
                      maxWidth: 260), // Adjust the width as needed
                  child: Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 30,
                      color: widget.widgetText,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Rubik',
                    ),
                    textAlign: TextAlign.center, // Center align the text
                  ),
                ),
                const SizedBox(height: 56),
                //const Spacer(),
                InkWell(
                  onTap: widget.onButtonPressed,
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.7, // 50% of screen width
                    height: MediaQuery.of(context).size.height *
                        0.06, // 8% of screen height
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: widget.buttonGradient.colors,
                          stops: const [0.0, 0.7, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.15), // glow or shadow
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ] //border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Let's Continue",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Rubik',
                      ),
                    ),
                    // child: ElevatedButton(
                    //   onPressed: widget.onButtonPressed,
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.transparent,
                    //     shadowColor: Colors.transparent,
                    //     surfaceTintColor: Colors.transparent,
                    //     elevation: 0,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(24),
                    //     ),
                    //   ),
                    //   child: Text(widget.buttonText,
                    //       style: const TextStyle(
                    //           fontSize: 24,
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.w400,
                    //           fontFamily: 'Rubik')),
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
